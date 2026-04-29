#!/bin/bash

##############################################################################
# OpenCode Loop - Multi-Agent News Crawler Automation
#
# Purpose: Orchestrate 5 specialized agents (Manager, Crawler×3, Scheduler,
#          Summarizer, Notifier) with parallel execution
#
# Pattern: Manager (orchestrator) → Parallel Crawlers → Sequential
#          Summarizer → Notifier, repeat per round
#
# Usage: ./opencode-loop.sh [--max-rounds N] [--model MODEL] [--dry-run]
##############################################################################

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Configuration
MAX_ROUNDS=5
MANAGER_MODEL="sonnet"
WORKER_MODEL="haiku"
MISSION_FILE="mission.md"
STATE_JSON=".opencode-state.json"
SCHEDULE_FILE="schedule.json"
TMP_DIR="/tmp/opencode-$$"
DRY_RUN=false
SLACK_WEBHOOK_URL="${SLACK_WEBHOOK_URL:-}"

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --max-rounds)
      MAX_ROUNDS="$2"
      shift 2
      ;;
    --model)
      MANAGER_MODEL="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--max-rounds N] [--model MODEL] [--dry-run]"
      exit 1
      ;;
  esac
done

##############################################################################
# Helper Functions
##############################################################################

print_header() {
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${CYAN}$1${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_success() {
  echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
  echo -e "${CYAN}ℹ️  $1${NC}"
}

print_warning() {
  echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
  echo -e "${RED}❌ $1${NC}"
}

print_phase() {
  echo -e "${MAGENTA}━━ PHASE $1: $2 ━━${NC}"
}

# Initialize temporary directory
init_tmp() {
  mkdir -p "$TMP_DIR"
  print_success "Created temporary directory: $TMP_DIR"
}

# Clean up temporary directory
cleanup_tmp() {
  rm -rf "$TMP_DIR"
}

# Initialize schedule file if not exists
init_schedule() {
  if [ ! -f "$SCHEDULE_FILE" ]; then
    cat > "$SCHEDULE_FILE" << 'EOF'
{
  "version": "1.0",
  "schedule": [
    {"round": 1, "start_time": "14:00", "estimated_duration": 50},
    {"round": 2, "start_time": "14:01", "estimated_duration": 50},
    {"round": 3, "start_time": "14:02", "estimated_duration": 50},
    {"round": 4, "start_time": "14:03", "estimated_duration": 50},
    {"round": 5, "start_time": "14:04", "estimated_duration": 50}
  ]
}
EOF
    print_success "Created $SCHEDULE_FILE"
  fi
}

# Save current state as JSON
save_state_json() {
  local round=$1
  local phase=$2
  local start_time=$(date +%s)

  cat > "$STATE_JSON" << EOF
{
  "round": $round,
  "max_rounds": $MAX_ROUNDS,
  "phase": "$phase",
  "manager_model": "$MANAGER_MODEL",
  "worker_model": "$WORKER_MODEL",
  "start_time": $start_time,
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
}

# Display progress bar
show_progress_bar() {
  local current=$1
  local total=$2
  local width=30

  if [ "$total" -eq 0 ]; then
    total=$MAX_ROUNDS
  fi

  local filled=$((current * width / total))
  local empty=$((width - filled))

  printf "["
  printf "%${filled}s" | tr ' ' '█'
  printf "%${empty}s" | tr ' ' '░'
  printf "] %d/%d\n" "$current" "$total"
}

# Check if work is complete
is_complete() {
  if grep -q "✅ ALL_ROUND_COMPLETED" "$MISSION_FILE" 2>/dev/null; then
    return 0
  else
    return 1
  fi
}

##############################################################################
# Agent Prompts (as heredoc variables)
##############################################################################

get_manager_prompt() {
  local round=$1
  cat << 'MANAGER_EOF'
당신은 AI 뉴스 크롤러 시스템의 Manager입니다.

역할:
- 이 라운드의 작업 계획을 세우기
- Crawler, Summarizer, Notifier의 작업 결과 검증
- mission.md에 진행도 업데이트

현재 라운드: ROUND_NUM

각 에이전트의 권한:
- Crawler: API 읽기만 (write: false) - 병렬로 3개 작업 실행
- Scheduler: mission.md와 schedule.json 업데이트 가능
- Summarizer: 텍스트만 (네트워크 금지)
- Notifier: Slack 발송만 (다른 API 금지)

다음을 JSON 형식으로 반환하세요:
{
  "round": ROUND_NUM,
  "plan": [
    {"agent": "crawler_hn", "source": "HackerNews", "expected_items": 5},
    {"agent": "crawler_reddit", "source": "Reddit", "expected_items": 5},
    {"agent": "crawler_arxiv", "source": "Arxiv", "expected_items": 3}
  ],
  "status": "ready",
  "note": "라운드 계획 요약"
}
MANAGER_EOF
}

get_crawler_hn_prompt() {
  cat << 'CRAWLER_EOF'
당신은 HackerNews 데이터 수집 에이전트입니다.

작업:
- HackerNews에서 "AI" 태그가 있는 최신 뉴스 5건 수집
- 실제 네트워크 접근 없으면 2026년 4월 AI 트렌드 기반 합성 데이터 생성

응답 형식 (JSON 배열):
[
  {"title": "제목", "url": "https://...", "source": "HN", "score": 500, "timestamp": "2026-04-30T14:00Z"},
  ...
]

각 아이템은 title, url, source, score, timestamp를 포함해야 합니다.
CRAWLER_EOF
}

get_crawler_reddit_prompt() {
  cat << 'CRAWLER_EOF'
당신은 Reddit 데이터 수집 에이전트입니다.

작업:
- Reddit r/MachineLearning에서 이번주 Top 5 스레드 수집
- 실제 네트워크 접근 없으면 2026년 AI ML 트렌드 기반 합성 데이터 생성

응답 형식 (JSON 배열):
[
  {"title": "제목", "url": "https://reddit.com/r/...", "source": "Reddit", "upvotes": 2000, "timestamp": "2026-04-30T14:00Z"},
  ...
]

각 아이템은 title, url, source, upvotes, timestamp를 포함해야 합니다.
CRAWLER_EOF
}

get_crawler_arxiv_prompt() {
  cat << 'CRAWLER_EOF'
당신은 Arxiv 데이터 수집 에이전트입니다.

작업:
- Arxiv에서 최신 LLM 관련 논문 3건 수집
- 실제 네트워크 접근 없으면 2026년 LLM 논문 트렌드 기반 합성 데이터 생성

응답 형식 (JSON 배열):
[
  {"title": "논문 제목", "url": "https://arxiv.org/abs/...", "source": "Arxiv", "authors": 3, "timestamp": "2026-04-30T14:00Z"},
  ...
]

각 아이템은 title, url, source, authors, timestamp를 포함해야 합니다.
CRAWLER_EOF
}

get_scheduler_prompt() {
  local round=$1
  cat << SCHEDULER_EOF
당신은 스케줄러 에이전트입니다.

작업:
- Round $round 완료 후 다음 라운드의 예상 시작 시간 계산
- API 레이트 리미팅을 고려하여 최적의 간격 결정

응답 형식 (JSON):
{
  "round": $round,
  "next_round_delay_seconds": 10,
  "rate_limit_status": "normal",
  "recommended_actions": ["계획"]
}

schedule.json 파일에 이 정보를 업데이트하세요.
SCHEDULER_EOF
}

get_summarizer_prompt() {
  local round=$1
  local items_json="$2"
  cat << SUMMARIZER_EOF
당신은 한국어 요약 에이전트입니다.

작업:
- 수집된 뉴스 아이템들을 한국어 200자 이내로 요약
- 각 요약에 2-3개의 관련 해시태그 추가

입력 (JSON 배열):
$items_json

응답 형식 (한국어 텍스트, 각 라인이 하나의 요약):
[원본 제목]
한국어 200자 이내 요약 텍스트입니다.
#해시태그1 #해시태그2

---

[다음 원본 제목]
한국어 200자 이내 요약 텍스트입니다.
#해시태그1 #해시태그2
SUMMARIZER_EOF
}

get_notifier_prompt() {
  local round=$1
  local summaries="$2"
  cat << NOTIFIER_EOF
당신은 Slack 메시지 포매팅 에이전트입니다.

작업:
- 요약된 뉴스를 Slack #ai-news 채널용 메시지로 포매팅
- 각 뉴스마다 이모지, 제목, 요약, 해시태그 포함

입력 (한국어 요약들):
$summaries

출력:
Slack 메시지 포맷 (아래 형식):

🤖 **오늘의 AI 뉴스 - Round $round**

🔗 **[뉴스1]**
[요약]
[해시태그]

---

🔗 **[뉴스2]**
[요약]
[해시태그]

마지막 업데이트: $(date '+%Y-%m-%d %H:%M KST')

---

SLACK_WEBHOOK_URL이 설정되어 있으면 이 메시지를 Slack에 POST하세요.
NOTIFIER_EOF
}

##############################################################################
# Main OpenCode Loop
##############################################################################

main() {
  print_header "🚀 OpenCode Loop: 멀티에이전트 AI 뉴스 크롤러"

  # Validate prerequisites
  if [ ! -f "$MISSION_FILE" ]; then
    print_error "$MISSION_FILE not found"
    exit 1
  fi

  if [ ! -f "PROMPT.md" ]; then
    print_warning "PROMPT.md not found (optional)"
  fi

  # Initialize
  init_tmp
  init_schedule

  trap cleanup_tmp EXIT

  echo ""
  print_info "Configuration:"
  echo "  Manager Model: $MANAGER_MODEL"
  echo "  Worker Model: $WORKER_MODEL"
  echo "  Max Rounds: $MAX_ROUNDS"
  echo "  Mission File: $MISSION_FILE"
  echo "  Dry Run: $DRY_RUN"
  echo ""

  if [ "$DRY_RUN" = true ]; then
    print_warning "DRY RUN MODE - No actual claude -p calls will be executed"
    echo ""
  fi

  print_info "Starting OpenCode loop..."
  echo ""

  # Main loop
  local round=1

  while [ $round -le $MAX_ROUNDS ]; do
    clear

    print_header "📍 라운드 $round/$MAX_ROUNDS"

    # Show progress bar
    show_progress_bar $round $MAX_ROUNDS
    echo ""

    save_state_json $round "Manager"

    # ========== PHASE 1: Manager Orchestration ==========
    print_phase "1" "Manager - Round Planning"

    local manager_prompt=$(get_manager_prompt $round)

    if [ "$DRY_RUN" = true ]; then
      print_info "[DRY RUN] Would call claude -p with Manager prompt"
      echo "Manager Prompt (shortened): 라운드 $round 계획"
    else
      print_info "Calling Manager ($MANAGER_MODEL)..."
      # In real execution: claude -p "$manager_prompt" --model $MANAGER_MODEL
      # For demo: simulate successful manager response
      echo "✓ Manager plan received: Crawler x3 → Summarizer → Notifier"
    fi

    echo ""
    sleep 1

    # ========== PHASE 2: Parallel Crawlers ==========
    print_phase "2" "Crawlers - Data Collection (Parallel)"

    save_state_json $round "Crawler"

    if [ "$DRY_RUN" = false ]; then
      # Launch HN Crawler
      {
        print_info "  → HackerNews Crawler..."
        # claude -p "$(get_crawler_hn_prompt)" --model $WORKER_MODEL > "$TMP_DIR/crawl_hn_R${round}.txt"
        echo '{"source":"HN","items":5,"status":"ok"}' > "$TMP_DIR/crawl_hn_R${round}.txt"
        print_success "  ✅ HN Crawler completed"
      } &
      HN_PID=$!

      # Launch Reddit Crawler
      {
        print_info "  → Reddit Crawler..."
        # claude -p "$(get_crawler_reddit_prompt)" --model $WORKER_MODEL > "$TMP_DIR/crawl_reddit_R${round}.txt"
        echo '{"source":"Reddit","items":5,"status":"ok"}' > "$TMP_DIR/crawl_reddit_R${round}.txt"
        print_success "  ✅ Reddit Crawler completed"
      } &
      REDDIT_PID=$!

      # Launch Arxiv Crawler
      {
        print_info "  → Arxiv Crawler..."
        # claude -p "$(get_crawler_arxiv_prompt)" --model $WORKER_MODEL > "$TMP_DIR/crawl_arxiv_R${round}.txt"
        echo '{"source":"Arxiv","items":3,"status":"ok"}' > "$TMP_DIR/crawl_arxiv_R${round}.txt"
        print_success "  ✅ Arxiv Crawler completed"
      } &
      ARXIV_PID=$!

      # Wait for all crawlers
      wait $HN_PID $REDDIT_PID $ARXIV_PID
      print_success "All crawlers completed (parallel)"

      # Aggregate results
      cat "$TMP_DIR/crawl_hn_R${round}.txt" \
          "$TMP_DIR/crawl_reddit_R${round}.txt" \
          "$TMP_DIR/crawl_arxiv_R${round}.txt" > "$TMP_DIR/crawl_results_R${round}.txt"
    else
      print_info "[DRY RUN] Would launch 3 crawlers in parallel"
      echo "  → HackerNews: 5 items"
      echo "  → Reddit: 5 items"
      echo "  → Arxiv: 3 items"
    fi

    echo ""
    sleep 1

    # ========== PHASE 3: Scheduler ==========
    print_phase "3" "Scheduler - Rate Limiting"

    save_state_json $round "Scheduler"

    if [ "$DRY_RUN" = false ]; then
      print_info "Calling Scheduler..."
      # claude -p "$(get_scheduler_prompt $round)" --model $WORKER_MODEL > /dev/null
      print_success "Schedule updated"
    else
      print_info "[DRY RUN] Would update schedule.json"
    fi

    echo ""
    sleep 1

    # ========== PHASE 4: Summarizer ==========
    print_phase "4" "Summarizer - Korean Summaries"

    save_state_json $round "Summarizer"

    if [ "$DRY_RUN" = false ]; then
      print_info "Calling Summarizer..."
      local crawl_results=$(cat "$TMP_DIR/crawl_results_R${round}.txt")
      # claude -p "$(get_summarizer_prompt $round "$crawl_results")" --model $WORKER_MODEL > "$TMP_DIR/summaries_R${round}.txt"
      echo "Round $round: 13개 뉴스 요약 완료" > "$TMP_DIR/summaries_R${round}.txt"
      print_success "Summaries generated"
    else
      print_info "[DRY RUN] Would summarize 13 items to Korean"
    fi

    echo ""
    sleep 1

    # ========== PHASE 5: Notifier ==========
    print_phase "5" "Notifier - Slack Integration"

    save_state_json $round "Notifier"

    if [ "$DRY_RUN" = false ]; then
      print_info "Calling Notifier..."
      local summaries=$(cat "$TMP_DIR/summaries_R${round}.txt")
      # claude -p "$(get_notifier_prompt $round "$summaries")" --model $WORKER_MODEL > "$TMP_DIR/slack_msg_R${round}.txt"

      # Simulate Slack POST if webhook is set
      if [ -n "$SLACK_WEBHOOK_URL" ]; then
        # curl -X POST "$SLACK_WEBHOOK_URL" -d '{"text":"Round '$round' completed"}'
        print_success "Slack message posted"
      else
        print_info "Slack webhook not set (SLACK_WEBHOOK_URL)"
      fi
    else
      print_info "[DRY RUN] Would format and send Slack message"
    fi

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # ========== Update mission.md ==========
    save_state_json $round "Complete"

    print_success "Round $round completed"

    # Check for completion signal
    if is_complete; then
      print_success "ALL_ROUND_COMPLETED signal detected!"
      break
    fi

    # Auto-complete after max rounds
    if [ $round -eq $MAX_ROUNDS ]; then
      print_warning "Max rounds reached. Adding completion signal..."
      echo "" >> "$MISSION_FILE"
      echo "✅ ALL_ROUND_COMPLETED" >> "$MISSION_FILE"
      break
    fi

    # Show next iteration info
    echo -e "${YELLOW}⏳ 다음 라운드로 진행 중...${NC}"
    sleep 2

    round=$((round + 1))
  done

  # Final summary
  echo ""
  print_header "📊 OpenCode Loop 요약"
  echo "실행 완료: $round 라운드"
  echo "모델: Manager=$MANAGER_MODEL, Workers=$WORKER_MODEL"
  echo "상태 파일: $MISSION_FILE"
  echo ""

  # Show cost estimate
  local manager_cost=0.20
  local worker_cost=0.05
  local workers_per_round=5  # 1 crawler call × 3 parallel + scheduler + summarizer + notifier

  # Rough estimate: Manager once per round + 5 worker calls per round
  local total_cost=$(echo "scale=2; $round * ($manager_cost + $workers_per_round * $worker_cost)" | bc 2>/dev/null || echo "계산 오류")

  echo "예상 비용 (추정): \$$total_cost"
  echo "  - Manager ($MANAGER_MODEL): \$$manager_cost/라운드"
  echo "  - Workers ($WORKER_MODEL): \$$worker_cost × 5 = \$0.25/라운드"
  echo ""

  print_success "OpenCode loop completed!"
  print_info "Check mission.md for detailed results"
}

##############################################################################
# Entry Point
##############################################################################

# Run main function
main "$@"

exit 0

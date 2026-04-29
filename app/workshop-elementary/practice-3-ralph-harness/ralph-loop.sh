#!/bin/bash

##############################################################################
# Ralph Loop - Korean Proverb Generation Automation
#
# Purpose: Iterate Claude's execution of proverb generation until completion
# Pattern: Same prompt + current state → repeated execution → gradual improvement
#
# Usage: ./ralph-loop.sh [--max-iterations N] [--model MODEL]
##############################################################################

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
MAX_ITERATIONS=30
CLAUDE_MODEL="sonnet"
PROMPT_FILE="PROMPT.md"
STATE_FILE="fix_plan.md"
OUTPUT_FILE="proverbs.md"
STATE_JSON=".ralph-state.json"
SLEEP_INTERVAL=2

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --max-iterations)
      MAX_ITERATIONS="$2"
      shift 2
      ;;
    --model)
      CLAUDE_MODEL="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: $0 [--max-iterations N] [--model MODEL]"
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

# Initialize state file if not exists
init_state() {
  if [ ! -f "$STATE_FILE" ]; then
    cat > "$STATE_FILE" << 'EOF'
# 속담 생성 진행도

## 체크리스트
- [ ] 기본 속담 5개 생성
- [ ] 각 속담의 뜻 상세 작성
- [ ] 속담 변형 2개씩 생성
- [ ] 현대 예시 추가
- [ ] 시적 수준 향상
- [ ] 최종 검증 및 정렬

## 현재 상태
진행 중: 라운드 1 시작

## 생성된 속담 목록
(아직 생성되지 않음)
EOF
    print_success "Created $STATE_FILE"
  fi
}

# Initialize output file if not exists
init_output() {
  if [ ! -f "$OUTPUT_FILE" ]; then
    cat > "$OUTPUT_FILE" << 'EOF'
# 한글 속담 생성 결과

이 파일은 ralph-loop.sh에 의해 자동으로 생성되고 업데이트됩니다.

## 생성된 속담들

(생성 진행 중...)

EOF
    print_success "Created $OUTPUT_FILE"
  fi
}

# Save current state as JSON
save_state_json() {
  local iteration=$1
  local completed=$(grep -c "\\[x\\]" "$STATE_FILE" 2>/dev/null || echo 0)
  local total=$(grep -c "\\[" "$STATE_FILE" 2>/dev/null || echo 0)
  local is_done=false

  if grep -q "ALL DONE" "$STATE_FILE" 2>/dev/null; then
    is_done=true
  fi

  cat > "$STATE_JSON" << EOF
{
  "iteration": $iteration,
  "max_iterations": $MAX_ITERATIONS,
  "model": "$CLAUDE_MODEL",
  "completed_tasks": $completed,
  "total_tasks": $total,
  "is_done": $is_done,
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
}
EOF
}

# Get current progress
get_progress() {
  local completed=$(grep -c "\\[x\\]" "$STATE_FILE" 2>/dev/null || echo 0)
  local total=$(grep -c "\\[" "$STATE_FILE" 2>/dev/null || echo 0)

  if [ "$total" -gt 0 ]; then
    echo "$completed/$total"
  else
    echo "0/6"
  fi
}

# Check if work is complete
is_complete() {
  if grep -q "ALL DONE" "$STATE_FILE" 2>/dev/null; then
    return 0
  else
    return 1
  fi
}

# Display progress bar
show_progress_bar() {
  local completed=$1
  local total=$2
  local width=30

  if [ "$total" -eq 0 ]; then
    total=6
  fi

  local filled=$((completed * width / total))
  local empty=$((width - filled))

  printf "["
  printf "%${filled}s" | tr ' ' '█'
  printf "%${empty}s" | tr ' ' '░'
  printf "] %d/%d\n" "$completed" "$total"
}

##############################################################################
# Main Ralph Loop
##############################################################################

main() {
  print_header "🚀 Ralph Loop: 한글 속담 생성 자동화"

  # Validate prerequisites
  if [ ! -f "$PROMPT_FILE" ]; then
    print_error "PROMPT.md not found"
    exit 1
  fi

  # Initialize files
  init_state
  init_output

  echo ""
  print_info "Configuration:"
  echo "  Model: $CLAUDE_MODEL"
  echo "  Max Iterations: $MAX_ITERATIONS"
  echo "  State File: $STATE_FILE"
  echo "  Output File: $OUTPUT_FILE"
  echo ""

  print_info "Starting Ralph loop..."
  echo ""

  # Main loop
  local iteration=1

  while [ $iteration -le $MAX_ITERATIONS ]; do
    # Clear screen for readability
    clear

    print_header "📍 라운드 $iteration/$MAX_ITERATIONS"

    # Show current progress
    local progress=$(get_progress)
    echo -e "${CYAN}Progress: $progress${NC}"
    show_progress_bar "$(echo $progress | cut -d'/' -f1)" "$(echo $progress | cut -d'/' -f2)"
    echo ""

    # Save iteration state
    save_state_json $iteration

    # Build the prompt
    local full_prompt="$(cat "$PROMPT_FILE")

---

## 현재 진행도:
$(cat "$STATE_FILE")

---

## 지금까지 생성된 속담:
$(cat "$OUTPUT_FILE")"

    # Execute Claude with the prompt
    print_info "Executing Claude ($CLAUDE_MODEL)..."
    echo ""

    # Call Claude and capture output
    # Note: This assumes 'claude' CLI is available in PATH
    claude -p "$full_prompt" 2>/dev/null || {
      print_error "Failed to execute Claude"
      print_warning "Make sure 'claude' CLI is installed and authenticated"
      exit 1
    }

    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # Check for completion signal
    if is_complete; then
      print_success "ALL DONE signal detected!"
      echo ""
      print_header "🎉 작업 완료!"
      echo ""
      print_success "한글 속담 생성이 완료되었습니다."
      echo ""
      print_info "최종 결과는 다음 파일을 확인하세요:"
      echo "  - proverbs.md (생성된 속담)"
      echo "  - fix_plan.md (진행도)"
      echo ""

      # Show final stats
      local completed=$(grep -c "\\[x\\]" "$STATE_FILE")
      local total=$(grep -c "\\[" "$STATE_FILE")
      echo -e "${CYAN}최종 완료율: $completed/$total (100%)${NC}"
      echo ""

      break
    fi

    # Show next iteration info
    echo -e "${YELLOW}⏳ 다음 라운드로 진행 중...${NC}"
    sleep $SLEEP_INTERVAL

    iteration=$((iteration + 1))
  done

  # Handle max iterations reached
  if [ $iteration -gt $MAX_ITERATIONS ]; then
    echo ""
    print_warning "최대 반복 횟수 도달"
    echo ""
    print_info "다음을 확인하세요:"
    echo "  1. fix_plan.md의 진행도 확인"
    echo "  2. 더 나은 프롬프트 작성 (PROMPT.md 수정)"
    echo "  3. 체크리스트 항목 줄이기 (6개 → 3개)"
    echo ""
  fi

  # Final summary
  echo ""
  print_header "📊 Ralph Loop 요약"
  echo "실행 완료: $iteration 라운드"
  echo "모델: $CLAUDE_MODEL"
  echo "상태 파일: $STATE_FILE"
  echo "결과 파일: $OUTPUT_FILE"
  echo ""

  # Show cost estimate
  case "$CLAUDE_MODEL" in
    "haiku")
      local cost_per_round=0.05
      ;;
    "sonnet")
      local cost_per_round=0.2
      ;;
    "opus")
      local cost_per_round=1.0
      ;;
    *)
      local cost_per_round=0.2
      ;;
  esac

  local total_cost=$(echo "scale=2; $iteration * $cost_per_round" | bc)
  echo "예상 비용: \$$total_cost ($CLAUDE_MODEL 기준)"
  echo ""
}

##############################################################################
# Entry Point
##############################################################################

# Run main function
main "$@"

exit 0

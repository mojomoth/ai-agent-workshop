#!/bin/bash

##############################################################################
# Task Tracker - Real-time Progress Monitoring for OpenCode Loop
#
# Purpose: Monitor mission.md in real-time and show multi-agent progress
# Usage: ./task-tracker.sh
#
# Run this in a separate terminal while opencode-loop.sh is running
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
STATE_FILE="mission.md"
STATE_JSON=".opencode-state.json"
REFRESH_INTERVAL=1

# Track last state to detect changes
LAST_STATE=""
LAST_ROUND=0

##############################################################################
# Helper Functions
##############################################################################

clear_screen() {
  clear
}

print_header() {
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${CYAN}$1${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_divider() {
  echo -e "${BLUE}────────────────────────────────────────────────────────────────${NC}"
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

# Display progress bar
show_progress_bar() {
  local completed=$1
  local total=$2
  local width=40

  if [ "$total" -eq 0 ]; then
    total=5
  fi

  local filled=$((completed * width / total))
  local empty=$((width - filled))
  local percentage=$((completed * 100 / total))

  printf "  ["
  printf "%${filled}s" | tr ' ' '█'
  printf "%${empty}s" | tr ' ' '░'
  printf "] %3d%% (%d/%d)\n" "$percentage" "$completed" "$total"
}

# Get current round and phase
get_round_and_phase() {
  if [ -f "$STATE_FILE" ]; then
    # Extract Round X/5 status
    local round_line=$(grep "^### Round " "$STATE_FILE" | head -1)
    if [ -n "$round_line" ]; then
      echo "$round_line" | sed 's/.*Round \([0-9]*\).*/\1/'
    fi
  else
    echo "0"
  fi
}

# Get phase status for current round
get_phase_status() {
  local round=$1
  if [ -f "$STATE_FILE" ]; then
    # Look for phase indicators in the current round section
    local in_round=0
    while IFS= read -r line; do
      if [[ "$line" =~ "### Round $round" ]]; then
        in_round=1
      elif [[ "$line" =~ "### Round" ]] && [ $in_round -eq 1 ]; then
        in_round=0
      fi

      if [ $in_round -eq 1 ]; then
        if [[ "$line" =~ "상태: 진행 중" ]]; then
          echo "RUNNING"
          return
        elif [[ "$line" =~ "상태: 완료됨" ]]; then
          echo "COMPLETE"
          return
        fi
      fi
    done < "$STATE_FILE"
    echo "WAITING"
  else
    echo "UNKNOWN"
  fi
}

# Get news count
get_news_count() {
  if [ -f "$STATE_FILE" ]; then
    grep "총 뉴스:" "$STATE_FILE" | grep -o "[0-9]*" | head -1
  else
    echo "0"
  fi
}

# Check for completion signal
check_completion() {
  if [ -f "$STATE_FILE" ] && grep -q "✅ ALL_ROUND_COMPLETED" "$STATE_FILE"; then
    return 0
  else
    return 1
  fi
}

# Get timestamp
get_timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

# Get elapsed time
get_elapsed_time() {
  if [ -f "$STATE_JSON" ]; then
    local start_time=$(grep "\"start_time\":" "$STATE_JSON" | grep -o "[0-9]*" | head -1)
    if [ -n "$start_time" ]; then
      local current_time=$(date +%s)
      local elapsed=$((current_time - start_time))
      printf "%02d:%02d:%02d" $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60))
    fi
  else
    echo "00:00:00"
  fi
}

##############################################################################
# Real-time Monitoring Loop
##############################################################################

monitor() {
  local update_count=0

  print_header "📊 OpenCode Task Tracker - Real-time Progress Monitor"
  echo ""
  print_info "Monitoring: $STATE_FILE"
  print_info "Refresh: every ${REFRESH_INTERVAL}s"
  print_info "Press Ctrl+C to exit"
  echo ""

  while true; do
    # Get current state
    local round=$(get_round_and_phase)
    local phase=$(get_phase_status "$round")
    local news_count=$(get_news_count)
    local is_complete=false

    if check_completion; then
      is_complete=true
    fi

    # Check if state changed
    if [ "$round:$phase" != "$LAST_ROUND:$LAST_STATE" ]; then
      clear_screen

      print_header "📡 AI 뉴스 크롤러 - 멀티에이전트 실행"

      echo ""
      echo -e "${MAGENTA}📍 라운드: Round $round/5${NC}"
      echo ""

      # Show phase status
      echo -e "${CYAN}현재 상태:${NC}"
      case "$phase" in
        WAITING)
          echo -e "  ${YELLOW}⏳ 대기 중${NC}"
          ;;
        RUNNING)
          echo -e "  ${YELLOW}⚡ 진행 중${NC}"
          ;;
        COMPLETE)
          echo -e "  ${GREEN}✅ 완료됨${NC}"
          ;;
        *)
          echo -e "  ${BLUE}❓ 상태 확인 중${NC}"
          ;;
      esac
      echo ""

      # Show progress bar
      echo "진행도:"
      show_progress_bar "$round" 5
      echo ""

      # Show news collection progress
      echo -e "${CYAN}수집된 뉴스:${NC}"
      echo "  📰 총 개수: $news_count개"
      echo ""

      # Show elapsed time
      local elapsed=$(get_elapsed_time)
      echo -e "${CYAN}경과 시간:${NC}"
      echo "  ⏱️  $elapsed"
      echo ""

      # Show last update time
      echo -e "${CYAN}마지막 업데이트:${NC}"
      echo "  $(get_timestamp)"
      echo ""

      print_divider

      # Show detailed mission status
      if [ -f "$STATE_FILE" ]; then
        echo ""
        echo -e "${CYAN}라운드별 상태:${NC}"
        echo ""

        # Parse and display round status
        local in_results=0
        while IFS= read -r line; do
          if [[ "$line" =~ "## 최종 결과" ]]; then
            in_results=1
          fi

          if [ $in_results -eq 1 ]; then
            if [[ "$line" =~ "총 라운드" ]]; then
              echo "  $line" | sed 's/^/  /'
            elif [[ "$line" =~ "총 뉴스" ]]; then
              echo "  $line" | sed 's/^/  /'
            elif [[ "$line" =~ "총 시간" ]]; then
              echo "  $line" | sed 's/^/  /'
            elif [[ "$line" =~ "마지막 발송" ]]; then
              echo "  $line" | sed 's/^/  /'
            fi
          fi
        done < "$STATE_FILE"
      fi

      echo ""

      # Show completion indicator
      if [ "$is_complete" = true ]; then
        print_divider
        echo ""
        print_success "모든 라운드가 완료되었습니다!"
        echo ""
        print_info "OpenCode 루프가 이제 종료됩니다."
        echo ""
        echo "최종 결과: mission.md"
        echo ""

        sleep 3
        break
      fi

      # Update tracking
      LAST_STATE=$phase
      LAST_ROUND=$round
      update_count=$((update_count + 1))
    fi

    sleep $REFRESH_INTERVAL
  done
}

##############################################################################
# Statistics Display
##############################################################################

show_statistics() {
  if [ ! -f "$STATE_FILE" ]; then
    print_error "State file not found: $STATE_FILE"
    return
  fi

  echo ""
  print_header "📈 최종 통계"

  local news_count=$(get_news_count)
  local elapsed=$(get_elapsed_time)

  echo ""
  echo -e "${CYAN}진행 현황:${NC}"
  show_progress_bar 5 5

  echo ""
  echo -e "${CYAN}상세:${NC}"
  echo "  📰 수집된 뉴스: $news_count개"
  echo "  ⏱️  총 소요 시간: $elapsed"
  echo "  ✅ 상태: 완료"

  echo ""
}

##############################################################################
# Entry Point
##############################################################################

main() {
  # Validate state file exists
  if [ ! -f "$STATE_FILE" ]; then
    print_error "State file not found: $STATE_FILE"
    print_info "Please run ./opencode-loop.sh first to initialize the state file"
    exit 1
  fi

  # Start monitoring
  monitor

  # Show final statistics
  show_statistics

  echo ""
  print_success "Task tracking completed!"
  echo ""
}

# Handle Ctrl+C gracefully
trap 'echo ""; print_info "Task tracker stopped"; show_statistics; exit 0' SIGINT

# Run main function
main "$@"

exit 0

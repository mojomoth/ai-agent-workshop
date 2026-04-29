#!/bin/bash

##############################################################################
# Task Tracker - Real-time Progress Monitoring for Ralph Loop
#
# Purpose: Monitor fix_plan.md in real-time and show progress updates
# Usage: ./task-tracker.sh
#
# Run this in a separate terminal while ralph-loop.sh is running
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
STATE_FILE="fix_plan.md"
OUTPUT_FILE="proverbs.md"
STATE_JSON=".ralph-state.json"
REFRESH_INTERVAL=1

# Track last state to detect changes
LAST_STATE=""
LAST_COMPLETED=0
LAST_TOTAL=0

##############################################################################
# Helper Functions
##############################################################################

clear_screen() {
  clear
}

print_header() {
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${CYAN}$1${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_divider() {
  echo -e "${BLUE}───────────────────────────────────────────────────${NC}"
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
    total=6
  fi

  local filled=$((completed * width / total))
  local empty=$((width - filled))
  local percentage=$((completed * 100 / total))

  printf "  ["
  printf "%${filled}s" | tr ' ' '█'
  printf "%${empty}s" | tr ' ' '░'
  printf "] %3d%% (%d/%d)\n" "$percentage" "$completed" "$total"
}

# Get task stats
get_stats() {
  local completed=0
  local total=0
  local pending=0

  if [ -f "$STATE_FILE" ]; then
    completed=$(grep -c "\\[x\\]" "$STATE_FILE" || echo 0)
    total=$(grep -c "\\[" "$STATE_FILE" || echo 0)
    pending=$((total - completed))
  fi

  echo "$completed:$total:$pending"
}

# Check for completion signal
check_completion() {
  if [ -f "$STATE_FILE" ] && grep -q "ALL DONE" "$STATE_FILE"; then
    return 0
  else
    return 1
  fi
}

# Get current iteration
get_iteration() {
  if [ -f "$STATE_JSON" ]; then
    grep "\"iteration\":" "$STATE_JSON" | grep -o "[0-9]*" | head -1
  else
    echo "?"
  fi
}

# Get proverb count
get_proverb_count() {
  if [ -f "$OUTPUT_FILE" ]; then
    grep -c "^원문:" "$OUTPUT_FILE" || echo 0
  else
    echo 0
  fi
}

# Format timestamp
get_timestamp() {
  date "+%Y-%m-%d %H:%M:%S"
}

##############################################################################
# Real-time Monitoring Loop
##############################################################################

monitor() {
  local iteration_count=0

  print_header "📊 Task Tracker - Real-time Progress Monitor"
  echo ""
  print_info "Monitoring: $STATE_FILE"
  print_info "Refresh: every ${REFRESH_INTERVAL}s"
  print_info "Press Ctrl+C to exit"
  echo ""

  while true; do
    # Get current stats
    local stats=$(get_stats)
    local completed=$(echo "$stats" | cut -d':' -f1)
    local total=$(echo "$stats" | cut -d':' -f2)
    local pending=$(echo "$stats" | cut -d':' -f3)
    local iteration=$(get_iteration)
    local proverb_count=$(get_proverb_count)
    local is_complete=false

    if check_completion; then
      is_complete=true
    fi

    # Check if state changed
    if [ "$completed:$total" != "$LAST_COMPLETED:$LAST_TOTAL" ]; then
      clear_screen

      print_header "📊 속담 생성 진행도"

      echo ""
      echo -e "${MAGENTA}📍 라운드: $iteration${NC}"
      echo ""

      # Show progress bar
      echo "완료도:"
      show_progress_bar "$completed" "$total"
      echo ""

      # Show task breakdown
      echo -e "${CYAN}과제 상태:${NC}"
      echo "  ✅ 완료: $completed개"
      echo "  ⏳ 대기: $pending개"
      echo "  📊 총계: $total개"
      echo ""

      # Show proverb generation progress
      echo -e "${CYAN}생성된 속담:${NC}"
      echo "  📝 개수: $proverb_count개"
      echo ""

      # Show last update time
      echo -e "${CYAN}마지막 업데이트:${NC}"
      echo "  $(get_timestamp)"
      echo ""

      print_divider

      # Show task details
      if [ -f "$STATE_FILE" ]; then
        echo ""
        echo -e "${CYAN}체크리스트:${NC}"
        echo ""

        # Read and display checklist with styling
        while IFS= read -r line; do
          if [[ "$line" =~ ^\-\ \[x\] ]]; then
            echo -e "${GREEN}✅ $line${NC}"
          elif [[ "$line" =~ ^\-\ \[\ \] ]]; then
            echo -e "${YELLOW}⏳ $line${NC}"
          elif [[ "$line" =~ ALL\ DONE ]]; then
            echo ""
            echo -e "${GREEN}🎉 $line${NC}"
          elif [ -n "$line" ]; then
            echo "$line"
          fi
        done < "$STATE_FILE"
      fi

      echo ""

      # Show completion indicator
      if [ "$is_complete" = true ]; then
        print_divider
        echo ""
        print_success "모든 작업이 완료되었습니다!"
        echo ""
        print_info "Ralph 루프가 이제 종료됩니다."
        echo ""
        echo "최종 결과: proverbs.md"
        echo ""

        sleep 3
        break
      fi

      # Update tracking
      LAST_COMPLETED=$completed
      LAST_TOTAL=$total
      iteration_count=$((iteration_count + 1))
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

  local stats=$(get_stats)
  local completed=$(echo "$stats" | cut -d':' -f1)
  local total=$(echo "$stats" | cut -d':' -f2)
  local proverb_count=$(get_proverb_count)

  echo ""
  echo -e "${CYAN}완료 현황:${NC}"
  show_progress_bar "$completed" "$total"

  echo ""
  echo -e "${CYAN}상세:${NC}"
  echo "  ✅ 완료된 과제: $completed개"
  echo "  ⏳ 대기 중인 과제: $((total - completed))개"
  echo "  📝 생성된 속담: $proverb_count개"

  echo ""
}

##############################################################################
# Entry Point
##############################################################################

main() {
  # Validate state file exists
  if [ ! -f "$STATE_FILE" ]; then
    print_error "State file not found: $STATE_FILE"
    print_info "Please run ./ralph-loop.sh first to initialize the state file"
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

#!/bin/bash

set -euo pipefail

MAX_ROUNDS=5
DRY_RUN=false
MISSION_FILE="mission.md"
CONFIG_FILE="opencode.json"
STATE_JSON=".opencode-state.json"

usage() {
  echo "Usage: $0 [--max-rounds N] [--dry-run]"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --max-rounds)
      MAX_ROUNDS="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
  esac
done

command -v opencode >/dev/null 2>&1 || {
  echo "opencode not found"
  exit 1
}

[ -f "$CONFIG_FILE" ] || {
  echo "Missing $CONFIG_FILE"
  exit 1
}

cat > "$STATE_JSON" <<EOF
{
  "start_time": $(date +%s),
  "max_rounds": $MAX_ROUNDS,
  "mission_file": "$MISSION_FILE",
  "config_file": "$CONFIG_FILE"
}
EOF

PROMPT=$(cat <<EOF
You are the manager for the practice-5-opencode-agent workshop.

Read ./opencode.json and ./mission.md, then coordinate the crawler,
scheduler, summarizer, and notifier agents. Use the mission file as the
shared progress log, keep the work bounded to $MAX_ROUNDS rounds, and finish
by appending ✅ ALL_ROUND_COMPLETED when complete.

Keep permissions tight, prefer parallel work where useful, and update the
mission file as you progress.
EOF
)

if [ "$DRY_RUN" = true ]; then
  echo "opencode run --agent manager -p \"$PROMPT\""
  exit 0
fi

opencode run --agent manager -p "$PROMPT"

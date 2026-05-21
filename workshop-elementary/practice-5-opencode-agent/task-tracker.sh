#!/bin/bash

set -euo pipefail

STATE_FILE="mission.md"
STATE_JSON=".opencode-state.json"

read_start_time() {
  if [ -f "$STATE_JSON" ]; then
    python - <<'PY'
import json
from pathlib import Path
p = Path('.opencode-state.json')
try:
    print(json.loads(p.read_text()).get('start_time', 0))
except Exception:
    print(0)
PY
  else
    echo 0
  fi
}

format_elapsed() {
  local start_time="$1"
  if [ "$start_time" -le 0 ]; then
    echo "00:00:00"
    return
  fi
  local now elapsed
  now=$(date +%s)
  elapsed=$((now - start_time))
  printf "%02d:%02d:%02d" $((elapsed / 3600)) $(((elapsed % 3600) / 60)) $((elapsed % 60))
}

show_once() {
  clear
  echo "OpenCode task tracker"
  echo "----------------------"
  echo "mission.md: $STATE_FILE"
  echo "state.json : $STATE_JSON"
  echo "elapsed    : $(format_elapsed "$(read_start_time)")"
  echo ""

  if [ -f "$STATE_FILE" ]; then
    if grep -q "✅ ALL_ROUND_COMPLETED" "$STATE_FILE"; then
      echo "status     : complete"
    else
      echo "status     : running"
    fi
    echo ""
    tail -n 12 "$STATE_FILE"
  else
    echo "status     : waiting (mission.md missing)"
  fi
}

if [ "${1:-}" = "--once" ]; then
  show_once
  exit 0
fi

while true; do
  show_once
  sleep 2
done

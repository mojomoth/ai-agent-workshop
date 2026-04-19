#!/usr/bin/env bash
set -u
MAX_ITERS=${MAX_ITERS:-10}
LOG=.ralph/log.md
mkdir -p .ralph

for i in $(seq 1 "$MAX_ITERS"); do
  echo "===== Ralph iteration $i / $(date -Iseconds) =====" | tee -a "$LOG"

  if grep -q "ALL DONE" STATUS.md 2>/dev/null; then
    echo "✅ ALL DONE" | tee -a "$LOG"; exit 0
  fi

  # 반복 전 상태 스냅샷
  BEFORE=$(git rev-parse HEAD)

  cat PROMPT.md | claude --dangerously-skip-permissions -p 2>&1 | tee -a "$LOG"

  AFTER=$(git rev-parse HEAD)
  if [ "$BEFORE" = "$AFTER" ]; then
    echo "⚠️  iteration $i: 커밋 없음. 3회 연속 커밋 없음이면 중단 필요." | tee -a "$LOG"
  fi

  # 센서 — 강제로 한 번 더 검증
  ruff check . >> "$LOG" 2>&1 || echo "⚠️  루프 외부 ruff 실패" | tee -a "$LOG"
  pytest -q   >> "$LOG" 2>&1 || echo "⚠️  루프 외부 pytest 실패" | tee -a "$LOG"
done

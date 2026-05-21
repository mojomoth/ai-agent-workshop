#!/usr/bin/env bash
set -u
MAX_ITERS=${MAX_ITERS:-10}
for i in $(seq 1 "$MAX_ITERS"); do
  echo "===== Ralph iteration $i ====="
  # 종료 조건: STATUS.md 에 ALL DONE
  if grep -q "ALL DONE" STATUS.md 2>/dev/null; then
    echo "✅ ALL DONE 감지. 루프 종료."
    exit 0
  fi
  # 한 사이클 실행 (비대화, 승인 없음)
  cat PROMPT.md | claude --dangerously-skip-permissions -p
  # 대안:
  # cat PROMPT.md | codex exec --ask-for-approval never
  # cat PROMPT.md | opencode run -
  echo "----- iteration $i done -----"
done
echo "⚠️  MAX_ITERS 도달. 수동 점검 필요."

#!/bin/bash
# ralph-loop.sh - Ralph 루프 예제 (Practice 3용)

set -e

echo "🔄 Ralph 루프 시작"
echo ""

# 설정
PRACTICE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../practice-3-ralph-harness" && pwd)"
MAX_ITERATIONS=${1:-30}  # 기본값 30, 커맨드라인에서 변경 가능
ITERATION=0
COMPLETION_SIGNAL="ALL DONE"

echo "Practice 디렉토리: $PRACTICE_DIR"
echo "최대 반복: $MAX_ITERATIONS"
echo "종료 신호: $COMPLETION_SIGNAL"
echo ""

# fix_plan.md 확인
if [ ! -f "$PRACTICE_DIR/fix_plan.md" ]; then
  echo "⚠️  fix_plan.md를 생성하는 중..."
  cp "$PRACTICE_DIR/fix_plan.md.template" "$PRACTICE_DIR/fix_plan.md"
  echo "✅ fix_plan.md 생성됨"
fi

if [ ! -f "$PRACTICE_DIR/PROMPT.md" ]; then
  echo "❌ PROMPT.md를 찾을 수 없습니다"
  exit 1
fi

echo ""

# Ralph 루프
while [ $ITERATION -lt $MAX_ITERATIONS ]; do
  ITERATION=$((ITERATION + 1))

  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "⏭️  라운드 $ITERATION / $MAX_ITERATIONS"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  # 현재 상태 출력
  echo "📋 현재 상태:"
  echo ""
  cat "$PRACTICE_DIR/fix_plan.md"
  echo ""

  # Claude 호출
  echo "🤖 Claude 실행 중..."
  echo ""

  # PROMPT.md + fix_plan.md 현재 상태를 함께 전달
  PROMPT_TEXT=$(cat "$PRACTICE_DIR/PROMPT.md")
  PLAN_TEXT=$(cat "$PRACTICE_DIR/fix_plan.md")

  FULL_PROMPT="$PROMPT_TEXT

## 현재 진행 상황:

\`\`\`
$PLAN_TEXT
\`\`\`

위 상황에서 다음 한 가지 기능을 구현하거나 버그를 수정하세요.
완료되면 fix_plan.md를 업데이트하세요."

  # Claude 호출 (실제 실행은 사용자가 수동으로 함)
  echo "다음 명령어를 복사해서 Claude에 붙여넣으세요:"
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "$FULL_PROMPT"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""

  # fix_plan.md 자동 갱신 시뮬레이션
  # (실제로는 사용자가 Claude 응답 후 fix_plan.md를 수동으로 업데이트)

  echo "✏️  fix_plan.md를 업데이트했나요? (y/n)"
  read -r response

  if [ "$response" != "y" ]; then
    echo "⏸️  중단됨"
    exit 0
  fi

  # 완료 신호 확인
  if grep -q "$COMPLETION_SIGNAL" "$PRACTICE_DIR/fix_plan.md"; then
    echo ""
    echo "🎉 완료 신호 감지됨!"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "최종 상태:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    cat "$PRACTICE_DIR/fix_plan.md"
    echo ""
    echo "✅ Ralph 루프 완료!"
    echo "   라운드: $ITERATION"
    echo "   총 비용: 약 \$(($ITERATION * 10)) (추정)"
    break
  fi

  # 최대 반복 도달 확인
  if [ $ITERATION -ge $MAX_ITERATIONS ]; then
    echo ""
    echo "⚠️  최대 반복($MAX_ITERATIONS)에 도달했습니다"
    echo "더 계속할까요? (y/n)"
    read -r response
    if [ "$response" != "y" ]; then
      echo "🛑 Ralph 루프 종료"
      break
    fi
  fi

  echo ""
  sleep 2
done

echo ""
echo "=== 루프 완료 ==="
echo "총 라운드: $ITERATION"
echo ""
echo "checklist.md를 확인하세요:"
echo "  cat $PRACTICE_DIR/checklist.md"
echo ""

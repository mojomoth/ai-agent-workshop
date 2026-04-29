# Ralph 루프 구현 가이드

## Ralph 패턴

```bash
while grep -q "진행 중" status.md; do
  claude -p "$(cat PROMPT.md)"
done
```

## 종료 신호

fix_plan.md에 "ALL DONE" 또는 "✅ ALL DONE" 출력되면 종료

## 최대 반복

--max-iterations 30으로 제한 (비용 관리)

## 각 라운드에서 하는 일

1. PROMPT.md + fix_plan.md 현재 상태 전달
2. 한 가지 기능 추가 또는 버그 수정
3. fix_plan.md 갱신
4. 완료되면 체크

## 주의사항

- localStorage는 sessionStorage가 아님
- 작은 커밋 권장
- 각 기능은 독립적으로 작동해야 함

# 4막: Codex 적대적 리뷰 ⭐

`/codex:review --adversarial src/dutch_pay.py` 결과.

이게 실습의 **클라이맥스**예요. 일반 리뷰가 놓친 결함들이 한꺼번에
드러나요.

---

## 사용한 명령

```
/codex:review --adversarial src/dutch_pay.py
```

## Codex 응답

(여기에 붙여넣기)

---

## 시연 후 메모

자기 리뷰(01)와 일반 리뷰(02)가 모두 못 잡은 결함:

- [ ] (적대적 리뷰만 잡은 이슈)

이 중 가장 인상적인 발견 하나:

> (한 줄 요약)

## 다음 단계

이 결과를 그대로 `/codex:rescue`에 넘겨서 Codex가 직접 고치게 합니다.

```
/codex:rescue src/dutch_pay.py의 적대적 리뷰에서 발견된 모든
이슈를 수정해줘. 기존 테스트는 깨지지 않게 유지하고 새 케이스용
테스트도 추가해.
```

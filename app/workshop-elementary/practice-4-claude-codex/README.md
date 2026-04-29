# 실습 4: Claude × Codex 검증 루프 (데모)

**목표**: 멀티모델 워크플로우 이해 (Claude 구현 → Codex 검증 → 자동 수정)

**소요 시간**: 5분  
**난이도**: ⭐⭐ (중급)  
**필수 도구**: Claude Code (+ Codex 선택)

---

## 📖 개요

Ralph 루프의 다음 단계: **다른 모델로 검증**

```
[Claude] 구현 → [Codex] 리뷰 → [Claude] 수정 → 반복
```

### 왜 검증이 필요한가?

- Claude는 "자기 코드는 좋다"고 생각 (Sycophancy)
- 다른 모델의 관점이 필요
- 보안/성능 이슈를 놓칠 수 있음

---

## 🔄 워크플로우

```bash
# 1. Claude가 구현
claude -p "auth 모듈 구현" > impl.log

# 2. Codex가 리뷰 (다른 관점!)
codex exec "$(cat impl.log) - 보안/성능 리뷰, 패치 제안" > review.md

# 3. Claude가 수정
claude -p "$(cat review.md) - 피드백 반영해서 수정"

# 4. Codex가 다시 리뷰 (신뢰성 향상)
```

---

## 🎯 이 실습에서 배우는 것

1. **멀티모델 설계**: 각 모델의 강점 활용
2. **검증 게이트**: 자동 품질 관리
3. **Sycophancy 줄이기**: 다른 관점의 중요성

---

## 📖 참고

| 개념 | 설명 |
|---|---|
| Sycophancy | AI가 자기 코드/결과를 과도하게 긍정하는 경향 |
| Review Gate | 자동 검증 단계로 품질 확보 |
| Cross-model | 여러 AI 모델을 협력시키는 패턴 |

---

**이 실습은 데모이므로 직접 실행하지 않습니다.**  
개념만 이해하고 다음 단계로 진행합니다.

→ [실습 5: OpenCode 멀티에이전트](../practice-5-opencode-agent/README.md)

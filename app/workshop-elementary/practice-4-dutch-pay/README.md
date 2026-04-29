# 🍕 더치페이 듀얼 — Claude × Codex 협업 실습 (30분)

**목표**: 친구들과 식당에서 더치페이하는 계산기를 만들면서,
같은 모델로는 못 잡는 버그를 다른 모델이 잡아내는 걸 체험한다.

---

## 왜 더치페이인가

누구나 식당에서 겪는 일이라 **버그가 났을 때 직관적으로 화가 나요**:

> "어? 우리 4명이 40,000원 시켰는데 왜 합치니까 40,001원이지?"
>
> "민수는 술 안 마셨는데 왜 똑같이 내야 해?"
>
> "팁 10% 라며? 근데 부가세 위에다? 부가세 빼고?"

코드 한 줄 한 줄이 "내 돈"과 직결돼서 **실수가 직접 느껴지는** 주제예요.
보안 같은 건 추상적이지만, 1원 사라지는 건 누구나 알아요.

---

## 개념: Sycophancy(자기 코드 좋게 보기) 극복

같은 AI가 코드를 짜고 자기가 리뷰하면 "괜찮네요" 하기 쉬워요.
다른 AI는 다른 시점으로 봐서 사각지대를 잡아내요.

```
❌ Claude만 사용:
   Claude가 짬 → Claude가 리뷰 → "잘 됐네요 ✓"

✅ Claude + Codex 조합:
   Claude가 짬 → Codex가 적대적 리뷰
   → "1/3 나누면 1원 사라져요"
   → "민수처럼 일부만 빠지는 케이스 처리 안 됐네요"
   → "음수 금액 들어오면 어떻게 되나요?"
```

OpenAI가 만든 공식 플러그인 `codex-plugin-cc`로
Claude Code 안에서 한 줄 명령으로 가능해요.

---

## 셋업 (5분)

### 사전 준비

- Claude Code 설치
- ChatGPT 구독 또는 OpenAI API 키 (Codex 인증용)
- Node.js 18.18+
- Python 3.10+

### Codex 플러그인 설치

Claude Code 안에서:

```bash
/plugin marketplace add openai/codex-plugin-cc
/plugin install codex@openai-codex
/codex:setup
```

`/codex:setup`이 codex CLI 설치까지 안내해줘요.

### 프로젝트 시작

```bash
cd dutch-pay
claude
```

---

## 실습 (25분) — 6막 구조

### 🎬 1막 — Claude에게 만들게 한다 (8분)

```
docs/SPEC.md 읽고 src/dutch_pay.py를 구현해줘.
tests/test_dutch_pay.py도 작성해서 통과시켜.
```

**관전 포인트**: 빠르게 짤 거예요. 테스트도 다 통과시킬 거고,
"잘 동작합니다 ✓" 하고 끝낼 가능성 큼.

### 🎬 2막 — 같은 Claude한테 리뷰시킨다 (3분)

```
방금 만든 dutch_pay.py를 다시 한 번 검토해줘.
혹시 놓친 케이스나 버그 있을까?
```

**관전 포인트**: 보통 "엣지 케이스 추가하면 좋겠네요" 정도.
자기 코드의 진짜 큰 결함은 못 잡아요. **이게 sycophancy**.

`reviews/01-claude-self-review.md`에 결과 저장.

### 🎬 3막 — Codex 일반 리뷰 (4분)

```
/codex:review src/dutch_pay.py
```

**관전 포인트**: 좀 더 객관적. 일부 이슈는 잡지만 전부는 아님.
`reviews/02-codex-review.md`에 저장.

### 🎬 4막 — Codex 적대적 리뷰 (5분) ⭐ 클라이맥스

```
/codex:review --adversarial src/dutch_pay.py
```

**관전 포인트** — 여기가 핵심:
일반 리뷰가 놓친 시나리오들이 쏟아짐:
- 1원 사라짐 / 더 생김 (반올림)
- 부동소수점 오류 (10원이 9.999999원)
- 0명으로 나누기
- 음수 금액
- 부가세/팁 적용 순서 모호함
- 한 명만 빠지는 케이스 미처리

`reviews/03-codex-adversarial.md`에 저장.

### 🎬 5막 — Codex에게 수정 위임 (4분)

```
/codex:rescue src/dutch_pay.py의 적대적 리뷰에서 발견된
모든 이슈를 수정해줘. 기존 테스트는 깨지지 않게 유지하고
새 케이스용 테스트도 추가해.
```

**관전 포인트**: 한 터미널에서 두 모델이 협업.
Codex가 background로 코드 고치는 동안 Claude 세션 유지.

### 🎬 6막 — 라이브로 깨뜨려보기 (1분)

```bash
python break_it.py
```

미리 준비된 7가지 시나리오 — 1막 코드는 망가지고,
5막 후 코드는 통과해야 함.

**가장 시각적인 임팩트**: "1원이 사라졌어요!" 같은 메시지를
청중이 직접 봄.

---

## 회고 질문

1. Claude의 자기 리뷰에서 놓친 이슈는 몇 개?
2. 일반 리뷰 vs 적대적 리뷰의 차이는?
3. 이 워크플로우를 어떤 종류의 코드에 쓰고 싶나요?

---

## 핵심 명령어 치트시트

| 명령 | 용도 |
|---|---|
| `/codex:setup` | 플러그인 초기 설정 |
| `/codex:review <file>` | 표준 리뷰 |
| `/codex:review --adversarial <file>` | "이걸 어떻게 깨뜨릴까" 적대적 리뷰 |
| `/codex:rescue <task>` | Codex에게 작업 위임 |

## 안전 메모

- `/codex:setup --enable-review-gate`는 매 답변마다 리뷰가 돌아서
  비용/사용량을 빨리 소진해요. 실습에선 켜지 마세요.
- 4막의 `--adversarial`이 이 실습의 핵심이에요. 빼먹으면 의미 없음.

# 🚀 Claude × Codex Quick Start (5분)

**목표**: 두 모델의 관점을 활용해 코드 품질을 높이기

---

## 개념: Sycophancy 극복

Claude는 **자기 코드는 좋다고 생각하는 경향**이 있습니다.

```
❌ Claude 혼자: "이 코드 좋네 ✓"
✅ Claude + Codex: "1원 사라지고, 0명 처리도 안 됐고, 음수도 통과해요"
```

**해결책**: 다른 모델(Codex)의 관점 추가

---

## 셋업 (한 번만)

Claude Code 안에서:

```bash
/plugin marketplace add openai/codex-plugin-cc
/plugin install codex@openai-codex
/codex:setup
```

`/codex:setup`이 codex CLI 설치/로그인 안내해줘요.

---

## 핵심 명령 3개

| 명령 | 언제 |
|---|---|
| `/codex:review <file>` | 일반 리뷰 |
| `/codex:review --adversarial <file>` | "이걸 어떻게 깨뜨릴까" 리뷰 ⭐ |
| `/codex:rescue <task>` | 작업을 Codex에 위임 |

---

## 30초 워크플로우

```
1. Claude에게 코드 작성 요청
2. /codex:review --adversarial <그 파일>     ← 사각지대 발견
3. /codex:rescue 위 이슈들 수정해줘          ← Codex가 고침
4. python break_it.py                       ← 라이브 검증
```

---

## 이 실습에서 할 일

식당 더치페이 계산기를 만들면서 **친구한테 1원이라도 잘못 송금되면
어떻게 되나** 시나리오로 위 워크플로우를 체험합니다.

`README.md`의 6막 시나리오를 따라가세요.
함정은 진행자만 미리 알고 있어요 (`docs/FACILITATOR_GUIDE.md`).

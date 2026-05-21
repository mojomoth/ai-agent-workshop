# Lab 2 — Ralph 루프 실습

> **학습 목표**: 큰 작업을 여러 사이클로 쪼개고, 같은 프롬프트를 반복 실행해 끝까지 진행하는 패턴을 체험한다.

## 핵심 개념

```
같은 PROMPT  ×  변하는 PLAN 상태  =  매 사이클마다 다른 행동
```

| 파일 | 역할 |
|------|------|
| `PROMPT.md` | 한 사이클의 행동 강령 (매번 동일하게 읽힘) |
| `PLAN.md`   | 남은 일 체크리스트. 에이전트가 직접 `[x]` 로 갱신 |
| `STATUS.md` | 종료 신호 — `ALL DONE` 적히면 루프 종료 |
| `ralph.sh`  | 루프 드라이버 — PROMPT 를 최대 `MAX_ITERS` 번 먹임 |

## Step 2-1. 작업 폴더 준비

```bash
cd app/workshop-beginner/p3/ralph
git init -q
git add . && git commit -q -m "init ralph"
```

## Step 2-2. (재실습 시) 상태 리셋

이미 한 번 돌아간 상태(`STATUS.md = ALL DONE`, `PLAN.md` 전부 `[x]`)이므로, 처음부터 돌려보려면 아래로 초기화하세요.

```bash
# STATUS.md 비우기
: > STATUS.md

# PLAN.md 의 [x] 를 [ ] 로 되돌리기
sed -i '' 's/\[x\]/[ ]/g' PLAN.md   # macOS
# sed -i    's/\[x\]/[ ]/g' PLAN.md   # Linux

# 산출물까지 초기화하려면
rm -f db.json todo.py test_todo.py
```

## Step 2-3. Ralph 루프 실행

```bash
./ralph.sh
```

내부적으로 매 사이클마다:

```bash
cat PROMPT.md | claude --dangerously-skip-permissions -p
```

비대화 모드로 PROMPT 를 먹입니다. **devcontainer 안이라 안전하지만, 호스트에서 직접 돌릴 때는 권한 플래그를 반드시 점검하세요.**

다른 에이전트로 돌리려면 `ralph.sh` 의 해당 줄만 교체하면 됩니다.

```bash
cat PROMPT.md | codex exec --ask-for-approval never
cat PROMPT.md | opencode run -
```

루프 안전장치는 두 개입니다.
- **`MAX_ITERS=10`** — 최대 10 사이클 후 강제 종료 (환경변수로 조절: `MAX_ITERS=20 ./ralph.sh`)
- **`STATUS.md` 의 `ALL DONE`** — 정상 종료 신호

## Step 2-4. 사이클 관찰

옆 터미널에서 실시간으로 PLAN/STATUS/커밋이 변하는 것을 지켜보세요.

```bash
watch -n 2 'echo "=== PLAN ==="; cat PLAN.md;
            echo; echo "=== STATUS ==="; cat STATUS.md 2>/dev/null;
            echo; echo "=== COMMITS ==="; git log --oneline'
```

기대 관찰:
- `PLAN.md` 의 체크박스가 **위에서 아래로 한 줄씩** `[x]` 로 바뀐다
- `git log` 에 의미 단위 커밋이 사이클당 1~2개씩 쌓인다
- 마지막 사이클 후 `STATUS.md` 에 `ALL DONE` 이 적히고 `ralph.sh` 가 종료된다

## Step 2-5. 검증

```bash
pytest -q             # 에이전트가 작성한 테스트가 통과하는지
git log --oneline     # 커밋이 의미 단위로 나뉘었는지
cat STATUS.md         # ALL DONE 인지
ls                    # todo.py / test_todo.py / db.json 이 만들어졌는지
```

## 회고 질문

- 한 사이클에 여러 태스크를 욕심내면 어떤 일이 생길까? (`PROMPT.md` 마지막 줄 참고)
- `MAX_ITERS` 안전장치가 없다면? 무한 루프 + 토큰 폭발 시나리오를 상상해보세요.
- `STATUS.md` 에 단순히 `ALL DONE` 만 쓰는 대신 **사이클별 진행 로그**를 남기게 하면 어떤 이점이 생길까?
- 같은 PROMPT 와 다른 PLAN 으로 완전히 다른 프로젝트를 만들 수 있을까?

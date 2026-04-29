# ASCII Zoo — Ralph + Harness 실습

20분 안에 **컨텍스트 유지(Ralph)**와 **가드레일(Harness)**을
체감하는 데모 프로젝트.

목표는 동물 10마리를 ASCII art로 그리는 것. Ralph가 한 마리씩
만들면서 루프를 돌고, Harness는 그 과정을 안전하게 묶어줘요.

---

## 한 눈에 보는 구조

```
ascii-zoo/
├── PROMPT.md                  # Ralph가 매 루프마다 다시 받는 작업 지시
├── ZOO.md                     # 루프 간 컨텍스트 유지용 진척 메모
├── animals/                   # 완성된 동물들이 쌓이는 곳
├── validate.py                # 가드레일: 크기/형식 검증
├── show_zoo.py                # 시각적 진척 표시
└── .claude/
    ├── settings.json          # 도구 권한 + hook 등록
    └── hooks/
        ├── check-zoo.sh       # Stop hook — Ralph 루프의 심장
        └── protect-animals.sh # PreToolUse hook — 완성품 보호
```

## 셋업 (1분)

```bash
cd ascii-zoo
python3 show_zoo.py     # 빈 동물원 확인
```

`.claude/settings.json`이 이미 들어있어서 Claude Code를 이 폴더에서
실행하면 자동으로 가드레일이 적용돼요.

## 실행 (Claude Code)

ralph-wiggum 플러그인을 쓰는 경우:

```bash
claude
> /plugin install ralph-wiggum@claude-plugins-official   # 한 번만
> /ralph-loop "$(cat PROMPT.md)" --max-iterations 15 \
              --completion-promise "ZOO_COMPLETE"
```

플러그인 없이 순수 bash 루프로도 같은 효과:

```bash
for i in {1..15}; do
  output=$(claude -p "$(cat PROMPT.md)" --dangerously-skip-permissions=false)
  echo "$output"
  if echo "$output" | grep -q "<promise>ZOO_COMPLETE</promise>"; then
    echo "✓ Done after $i iterations"
    break
  fi
done
```

> `settings.json`의 allow/deny 덕분에 위험한 권한 없이도 안전.

## 실행 (Codex)

`codex` CLI 쓰면 같은 패턴을 `AGENTS.md` 기반으로:

```bash
# AGENTS.md를 만들어서 PROMPT.md 내용 + 도구 제한 명시
cp PROMPT.md AGENTS.md
codex --sandbox workspace-write \
      --ask-for-approval never \
      "Follow AGENTS.md. Build the zoo one animal at a time."
```

bash 루프로 감싸면 Ralph 효과 동일.
hook은 Claude Code 전용이라 Codex에서는 `validate.py`를 매 루프
끝에 직접 돌리는 식으로 가드레일 흉내 가능.

---

## 시연 시나리오 (20분)

### 0–3분: 셋업 보여주기

- 빈 `show_zoo.py` 실행 — "여기서부터 시작해요"
- `PROMPT.md` 한 번 읽어주기
- `settings.json`의 deny 리스트 강조 — "위험한 명령은 처음부터 막혀있어요"

### 3–10분: Ralph 루프 시작 — 컨텍스트 유지 시연

- 루프 실행
- 매 1–2 루프마다 `show_zoo.py` 보여주며 동물 쌓이는 것 확인
- **반전 시연**: 5마리쯤 됐을 때 일부러 `Ctrl+C` 로 끊기
- 다시 실행 — Ralph가 `ZOO.md` 읽고 **6번째부터 이어서** 시작
- 메시지: "AI 메모리가 아니라 **파일이 메모리**예요"

### 10–15분: Harness 가드레일 발동 시연

세 개 중 하나는 자연스럽게 일어나고, 나머지는 유도 가능:

1. **크기 위반** (자주 일어남): Ralph가 멋부린 큰 용을 그리려 하면
   `validate.py`가 거부 → 다시 작게 그림
2. **수정 시도 차단** (유도): 사용자가 "고양이 다시 더 귀엽게 그려달라"
   고 요청 → `protect-animals.sh`가 차단 → "이미 완성된 건 못 건드려요"
3. **조기 종료 차단** (자주 일어남): 7–8마리에서 Claude가 슬쩍 종료 시도
   → `check-zoo.sh`가 stderr로 PROMPT 전체를 다시 먹임 → 재개

### 15–20분: 완성과 회고

- 10마리 채워지면 `<promise>ZOO_COMPLETE</promise>` 출력 → hook이 통과
- 최종 `show_zoo.py` — 박수 포인트
- 회고:
  - **Ralph = 시간**: 한 번에 못 해도 루프가 점진적으로 완성
  - **Harness = 신뢰**: 도구 권한 + hook으로 자율성을 안전하게 만듦
  - 둘은 짝이에요. 루프만 있으면 폭주, 가드레일만 있으면 한 번에 끝나야 함.

---

## 가드레일 한 페이지 요약

| 가드레일 | 위치 | 막는 것 |
|---|---|---|
| `allow`/`deny` | `settings.json` | rm, git, curl 같은 위험 명령 |
| `Edit(animals/**)` deny | `settings.json` | 완성된 동물 수정 |
| `validate.py` | 프로젝트 루트 | 크기 초과, 라벨 누락, 빈 파일 |
| `protect-animals.sh` | PreToolUse hook | 기존 파일 덮어쓰기 (deny 백업) |
| `check-zoo.sh` | Stop hook | 미완성 상태 조기 종료 |
| `--max-iterations 15` | CLI | 무한 루프 / 토큰 폭주 |

## 손볼 만한 곳

- `ZOO.md`의 TODO 목록을 바꾸면 다른 동물 시리즈로 변경 가능
- `MAX_HEIGHT` / `MAX_WIDTH` (`validate.py` 상단)로 난이도 조절
- 동물 대신 "곤충", "공룡", "음식" 같은 테마로 변형해도 그대로 작동

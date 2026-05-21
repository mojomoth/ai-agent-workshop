# 🆘 Troubleshooting Guide

워크숍 실행 중 발생하는 일반적인 문제들과 해결책

---

## 📍 Installation & Setup

### Issue: Claude CLI not found
**증상**: `command not found: claude`

**해결책**:
```bash
# macOS
brew install anthropic/claude/claude

# Linux/Windows (npm)
npm install -g @anthropic-ai/claude-code-cli

# 설치 확인
claude --version
```

### Issue: Python/Node not installed
**증상**: `command not found: python3` 또는 `node`

**해결책**:
```bash
# macOS
brew install python3 node

# Linux (Ubuntu/Debian)
sudo apt update
sudo apt install python3 python3-pip nodejs npm

# Windows: https://nodejs.org, https://www.python.org
```

### Issue: Permission denied on scripts
**증상**: `-bash: ./ralph-loop.sh: Permission denied`

**해결책**:
```bash
chmod +x scripts/*.sh
chmod +x practice-3-ralph-harness/*.sh

# 확인
ls -la scripts/ralph-loop.sh  # -rwx로 시작해야 함
```

---

## 🔴 Practice 3 (Ralph-Harness)

### Issue: ralph-loop.sh hangs indefinitely
**증상**: 루프가 30회 반복해도 끝나지 않음

**원인**: fix_plan.md에 "ALL DONE" 신호가 없음

**해결책**:
```bash
# 1. 현재 진행도 확인
tail -20 fix_plan.md

# 2. "ALL DONE" 신호가 있는지 확인
grep "ALL DONE" fix_plan.md

# 3. 없으면 PROMPT.md 개선
cat PROMPT.md

# 4. 더 명확한 체크리스트로 변경
# - 6개 항목 → 3개 항목으로 축소
# - 각 라운드마다 다른 작업 지시
```

**예제**:
```markdown
# PROMPT.md 수정

## 라운드 1: 기본 속담 5개만 생성
- 원문(한글)
- 한자 표기는 선택
- 의미 설명은 아직 X

## 라운드 2: 의미 설명 추가
- 라운드 1의 속담들을 가져와
- 2-3문장의 상세 설명 추가

...

매 라운드 끝에 fix_plan.md의 체크박스를 업데이트하세요.
모든 작업이 완료되면 fix_plan.md에 "ALL DONE"을 추가하세요.
```

### Issue: Claude generates English instead of Korean
**증상**: 영어로 속담 생성됨

**원인**: 프롬프트에 한글 강제 지시가 부족

**해결책**:
```markdown
# PROMPT.md에 표지판 추가 (맨 앞)

⚠️ **CRITICAL: 반드시 한글로 작성**

❌ 나쁜 예:
- Tiger dies and leaves its pelt
- 虎死留皮虎生留名 (한자만)

✅ 좋은 예:
- 호랑이는 죽어 가죽을 남기고 인간은 죽어 이름을 남긴다
- 흙이 없으면 풀이 자라지 않는다

규칙:
- 원문은 한글
- 한자 병기는 선택사항
- 변형도 모두 한글
- 예시도 한국 현실 기반
```

### Issue: Same task repeats in every round
**증상**: fix_plan.md에서 라운드 1만 반복됨

**원인**: PROMPT.md에 라운드별 작업이 명확하지 않음

**해결책**:
```bash
# 1. PROMPT.md 확인
head -50 PROMPT.md

# 2. 각 라운드가 다른 작업을 하도록 명시
# 현재 상태: fix_plan.md 읽음 → 체크된 항목 알 수 있음

# 3. PROMPT.md 수정 예시:
cat > PROMPT.md << 'EOF'
# 한글 속담 생성 (라운드별 다른 작업)

## 현재 진행도 (fix_plan.md)를 읽고 **아직 체크되지 않은 다음 항목만** 하세요.

- [x] 기본 속담 5개 생성 ← 완료됨
- [ ] 각 속담의 뜻 상세 작성 ← 이것을 지금 하세요!
- [ ] 속담 변형 2개씩 생성
...
EOF
```

### Issue: Cost exceeds budget
**증상**: 생각보다 많은 비용 소비

**해결책**:
```bash
# 1. Haiku로 변경 (10배 저렴)
./ralph-loop.sh --model haiku --max-iterations 10

# 2. max-iterations 줄이기
./ralph-loop.sh --model sonnet --max-iterations 15

# 3. 예상 비용 확인
# Haiku: 0.05 × 10 = $0.50
# Sonnet: 0.2 × 15 = $3.00
```

---

## 📊 File Issues

### Issue: proverbs.md not updating
**증상**: proverbs.md가 비어있거나 내용이 안 추가됨

**원인**: Ralph 루프가 프롬프트에 proverbs.md 내용을 포함하지 않음

**확인**:
```bash
# 1. fix_plan.md 확인
cat fix_plan.md

# 2. ralph-loop.sh 확인
grep "proverbs.md" ralph-loop.sh
# "cat $OUTPUT_FILE" 라인이 있어야 함

# 3. proverbs.md 확인
cat proverbs.md
```

### Issue: fix_plan.md doesn't update
**증상**: Claude가 fix_plan.md를 수정하지 않음

**원인**: 프롬프트에 명시적 지시 부족

**해결책**:
```markdown
# PROMPT.md에 추가

## 중요: 매 라운드 끝에 fix_plan.md 업데이트

완료한 작업의 체크박스를 [x]로 표시하세요:
```
- [x] 기본 속담 5개 생성
```

모든 작업이 완료되었으면:
```
✅ ALL DONE
```
을 fix_plan.md에 추가하세요.
```

---

## 🔌 Hook Issues

### Issue: Hooks not running
**증상**: PostToolUse 훅이 실행되지 않음

**원인**: hooks.json이 올바른 위치가 아니거나 형식이 잘못됨

**확인**:
```bash
# 1. hooks.json 위치
ls -la practice-3-ralph-harness/hooks.json

# 2. 형식 검증 (JSON 문법)
python3 -m json.tool practice-3-ralph-harness/hooks.json

# 3. Claude 설정에서 hooks 활성화
cat ~/.claude/settings.json | grep hooks
```

### Issue: Fix plan validation failed
**증상**: 훅이 "Progress not detected" 메시지 출력

**해결책**:
```bash
# 1. fix_plan.md에서 체크박스 형식 확인
grep -n "\[" fix_plan.md
# [ ]와 [x] 형식이어야 함

# 2. 체크박스가 실제로 업데이트되었는지 확인
head -20 fix_plan.md
tail -20 fix_plan.md

# 3. 필요시 fix_plan.md 수동 초기화
cp fix_plan.md.template fix_plan.md
```

---

## 🎯 Monitoring Issues

### Issue: task-tracker.sh not updating
**증상**: 진행도가 갱신되지 않음

**원인**: fix_plan.md 변경 감지 안 됨

**해결책**:
```bash
# 1. task-tracker.sh 실행 확인
./task-tracker.sh

# 2. 다른 터미널에서 ralph-loop.sh 실행 중 확인
# - Terminal 1: ./ralph-loop.sh
# - Terminal 2: ./task-tracker.sh

# 3. 수동 모니터링
watch -n 1 'grep -c "\[x\]" fix_plan.md'
```

---

## 🐛 Advanced Debugging

### Enable verbose logging
```bash
# ralph-loop.sh에서 디버그 출력 활성화
bash -x ralph-loop.sh

# 또는 수정
set -x  # ralph-loop.sh 맨 앞에 추가
```

### Check Claude execution
```bash
# 마지막 실행 로그 확인
cat fix_plan.md

# 마지막 생성된 속담 확인
tail -50 proverbs.md

# 상태 파일 확인
cat .ralph-state.json | python3 -m json.tool
```

### Reset workshop state
```bash
# 한 번 시작하면 중단하고 다시 시작하고 싶을 때:

# 1. 생성된 파일 삭제
rm -f proverbs.md .ralph-state.json

# 2. fix_plan.md 초기화
cp fix_plan.md.template fix_plan.md

# 3. 다시 실행
./ralph-loop.sh
```

---

## 💾 State Recovery

### What each file does
- **fix_plan.md**: 현재 진행도 (체크리스트)
- **proverbs.md**: 생성된 속담들 (누적)
- **.ralph-state.json**: 루프 메타데이터 (iteration, timestamp)

### Recover from crash
```bash
# 1. 현재 상태 확인
cat fix_plan.md       # 어디까지 했는가?
cat proverbs.md       # 무엇이 생성되었는가?

# 2. 진행도에 따라 재시작
# - 체크박스가 다 체크됨 → ALL DONE 추가하고 끝
# - 일부만 체크됨 → 그대로 다시 실행 (추가 라운드 시작)

./ralph-loop.sh
```

---

## 📞 Getting Help

### Check logs
```bash
# 마지막 100줄 확인
tail -100 fix_plan.md

# 현재 iteration 확인
grep "라운드" fix_plan.md | tail -1

# 생성된 항목 수 확인
grep -c "원문:" proverbs.md || echo "0 proverbs yet"
```

### Validate setup
```bash
# 워크숍 전체 검증
bash scripts/validate-workshop.sh

# 권한 확인
ls -la practice-3-ralph-harness/{ralph-loop,task-tracker}.sh

# 의존성 확인
claude --version && python3 --version && git --version
```

---

## 📋 Checklist for Common Issues

- [ ] Claude CLI 설치됨 (`claude --version`)
- [ ] 스크립트가 실행 가능함 (`ls -x ralph-loop.sh`)
- [ ] fix_plan.md가 존재함
- [ ] proverbs.md가 존재함
- [ ] PROMPT.md에 한글 강제 표지판 있음
- [ ] 라운드별 다른 작업이 PROMPT에 명시됨
- [ ] max-iterations < 30 (비용 제어)
- [ ] hooks.json이 올바른 형식임

---

**더 많은 도움이 필요한가요?**
- README.md: 전체 개요
- SETUP.md: 환경 설정
- practice-3-ralph-harness/CLAUDE.md: 아키텍처 설명

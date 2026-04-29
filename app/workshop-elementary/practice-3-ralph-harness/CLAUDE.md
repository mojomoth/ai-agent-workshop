# Practice 3: Ralph & Harness - 한글 속담 생성 컨텍스트

---

## 🎯 이번 실습의 핵심

### Ralph 패턴
```
같은 프롬프트를 반복 실행 → 매번 조금 나아짐 → 목표 달성
```

### Harness (말굴레)
```
┌─ Claude (생성 AI)
│  ↓ (지시받음)
├─ bash script (ralph-loop.sh)
│  ↓ (제어함)
└─ fix_plan.md (상태 추적)
```

이 3단계 구조를 이번 실습에서 완벽히 구축합니다.

---

## 📁 파일 구조 및 역할

### 필수 파일

```
practice-3-ralph-harness/
├── README.md              ← 실습 설명서
├── PROMPT.md              ← 속담 생성 프롬프트 (Claude가 읽음)
├── CLAUDE.md              ← 이 파일 (프로젝트 컨텍스트)
├── checklist.md           ← 완료 체크리스트
├── fix_plan.md            ← 진행도 추적 (Ralph가 읽고 쓰기)
├── hooks.json             ← Claude 훅 설정 (선택사항)
├── ralph-loop.sh          ← Ralph 루프 구현
└── task-tracker.sh        ← 진행도 모니터링 (선택사항)
```

### 런타임 파일 (실행 중 생성)

```
├── proverbs.md            ← 생성된 속담들 (누적)
└── .ralph-state.json      ← 루프 상태 정보 (자동 생성)
```

---

## 🔄 Ralph 루프 작동 원리

### 1단계: 루프 시작
```bash
./ralph-loop.sh
```

### 2단계: 각 반복마다
```bash
1. PROMPT.md + fix_plan.md 읽음
2. Claude에 지시 전달
3. Claude 실행
4. 결과 저장 (proverbs.md)
5. fix_plan.md 업데이트 확인
6. "ALL DONE" 있는지 체크
```

### 3단계: 완료 조건
```
if grep "ALL DONE" fix_plan.md; then
  루프 종료
else
  다음 라운드 진행
fi
```

### 4단계: 안전장치
```
MAX_ITERATIONS=30  # 최대 30회로 제한
비용 폭주 방지
```

---

## ⚡ Claude 훅 설정 (PostToolUse)

### 목적
Claude가 파일을 수정할 때마다 자동으로 진행도를 검증합니다.

### 설정 방법

#### Option 1: 프로젝트 레벨 hooks.json

파일: `practice-3-ralph-harness/.claude-hooks.json`

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "name": "validate-progress",
        "matcher": "Write|Edit",
        "command": "bash -c 'if grep -q \"\\[x\\]\" fix_plan.md; then echo \"✅ Progress detected\" && grep \"\\[x\\]\" fix_plan.md | wc -l && echo \" tasks completed\"; else echo \"⏳ No progress yet\"; fi'",
        "description": "Check progress after each file modification",
        "failureHandling": "warn"
      },
      {
        "name": "check-all-done",
        "matcher": "Write|Edit",
        "command": "bash -c 'if grep -q \"ALL DONE\" fix_plan.md; then echo \"🎉 ALL_DONE detected - Ralph loop will terminate\"; else echo \"⏳ Still working...\"; fi'",
        "description": "Warn when ALL_DONE signal is detected",
        "failureHandling": "warn"
      }
    ]
  }
}
```

#### Option 2: 전역 ~/.claude.json (선택사항)

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "when": "path contains 'practice-3'",
        "command": "grep -c '\\[x\\]' fix_plan.md || echo '0'",
        "description": "Track completed tasks in practice 3"
      }
    ]
  }
}
```

### 훅이 하는 일

1. **파일 수정 후** 자동 실행
2. **fix_plan.md 확인**: 체크된 항목 수 표시
3. **ALL DONE 감지**: 루프 종료 신호 안내

---

## 🛡️ 하네스 엔지니어링 체크리스트

### Layer 1: Claude (생성)
- [ ] PROMPT.md가 명확한가?
- [ ] 예시가 충분한가?
- [ ] 주의사항이 명시되어 있는가?

### Layer 2: Bash (제어)
- [ ] ralph-loop.sh가 fix_plan.md를 읽는가?
- [ ] 반복 횟수가 제한되어 있는가?
- [ ] "ALL DONE" 신호를 감지하는가?

### Layer 3: File System (상태)
- [ ] fix_plan.md가 체크리스트 형식인가?
- [ ] 매 라운드마다 업데이트 가능한가?
- [ ] proverbs.md에 결과가 누적되는가?

---

## 🚨 실패 패턴 및 표지판

### 패턴 1: Claude가 규칙을 잊음

**증상**: 영어로 속담 생성, 또는 한자만 사용

**해결책**: PROMPT.md에 표지판 추가
```markdown
⚠️ **중요: 속담은 반드시 한글로 작성**

✅ 올바른 예:
원문: 호랑이는 죽어 가죽을 남기고...

❌ 잘못된 예:
Tiger dies and leaves its hide
호호지피호인명지금 (한자만)
```

### 패턴 2: 같은 작업 반복

**증상**: fix_plan.md에 같은 라운드가 계속 반복

**해결책**: PROMPT.md에 라운드별 작업 분명히
```markdown
## 라운드 1: 기본 속담 5개 생성만 (의미 설명 X)
## 라운드 2: 의미 설명 추가만 (변형 X)
## 라운드 3: 변형 2개 생성만
```

### 패턴 3: "ALL DONE"을 절대 출력 안 함

**증상**: 30회 반복 후에도 완료되지 않음

**해결책**: 체크리스트 축소
```markdown
# 원래 (6개 항목)
- [ ] 속담 생성
- [ ] 뜻 설명
- [ ] 변형 생성
- [ ] 현대 예시
- [ ] 시적 개선
- [ ] 최종 검증

# 축소된 (3개 항목)
- [ ] 속담 5개 + 뜻 생성
- [ ] 변형 + 예시 생성
- [ ] 최종 검증
```

---

## 📊 진행도 추적 방법

### 실시간 모니터링

```bash
# 터미널 1: ralph-loop.sh 실행
./ralph-loop.sh

# 터미널 2: 진행도 모니터링
watch -n 2 'cat fix_plan.md'

# 또는 task-tracker.sh 사용
./task-tracker.sh
```

### 매뉴얼 확인

```bash
# 완료된 항목 수
grep -c "\[x\]" fix_plan.md

# 전체 항목 수
grep -c "\[ \]" fix_plan.md

# 완료율 계산
echo "scale=2; $(grep -c '\[x\]' fix_plan.md) * 100 / ($(grep -c '\[' fix_plan.md))" | bc

# "ALL DONE" 확인
grep "ALL DONE" fix_plan.md && echo "완료됨" || echo "진행 중"
```

---

## 💰 비용 최적화

### Sonnet 모델 (권장)
- 모델 비용: 라운드당 ~$0.2
- 속도: 30초~1분/라운드
- 총 비용 (30회): ~$6

```bash
# Sonnet으로 실행
CLAUDE_MODEL=sonnet ./ralph-loop.sh
```

### Haiku 모델 (초저비용)
- 모델 비용: 라운드당 ~$0.05
- 속도: 20초~30초/라운드
- 총 비용 (30회): ~$1.5

```bash
# Haiku로 실행
CLAUDE_MODEL=haiku ./ralph-loop.sh --max-iterations 15
```

### Opus 모델 (고품질)
- 모델 비용: 라운드당 ~$1
- 속도: 1-2분/라운드
- 총 비용 (30회): ~$30

---

## 🔗 다른 실습과의 관계

```
Practice 1: Plan Mode (설계)
    ↓
Practice 2: DESIGN.md (톤 일관성)
    ↓
Practice 3: Ralph Loop (자동화) ← 당신은 여기
    ↓
Practice 4: Claude × Codex (다중 모델 검증)
    ↓
Practice 5: OpenCode (다중 에이전트)
```

### Ralph (단일 모델 반복)
```
Claude → Claude → Claude → 완료
```

### 다음: Codex (이중 모델 검증)
```
Claude → Codex 검증 → Claude 개선 → 완료
```

---

## 📚 필수 개념 정리

| 개념 | 의미 | 이 실습에서 |
|---|---|---|
| **Ralph** | 반복 실행으로 점진적 개선 | 루프가 자동 반복 |
| **Harness** | AI를 제어하는 메타층 | bash + 파일 시스템 |
| **fix_plan.md** | 진행도 추적 파일 | 상태 관리의 중심 |
| **표지판** | 에러 반복 방지 코드 | PROMPT.md에 추가 |
| **종료 신호** | 루프를 멈추는 조건 | "ALL DONE" 텍스트 |
| **max-iterations** | 비용 제한 | 최대 30회 |

---

## 🎓 배울 수 있는 것

이 실습을 완료하면:

1. ✅ **자동화의 원리**를 이해
2. ✅ **상태 관리** (파일 기반)를 실제로 구현
3. ✅ **에러 반복 패턴**을 코드로 기억시키는 방법
4. ✅ **비용 제어**의 중요성 (max-iterations)
5. ✅ **점진적 개선**의 실제 가치

---

## 🆘 트러블슈팅

### 문제: ralph-loop.sh가 실행 안 됨
```bash
# 해결책: 실행 권한 추가
chmod +x ralph-loop.sh
```

### 문제: fix_plan.md를 Claude가 업데이트 안 함
```bash
# 해결책: PROMPT.md에 명시적 지시 추가
"매 라운드 끝에 반드시 fix_plan.md의 체크박스를 업데이트해주세요"
```

### 문제: "ALL DONE" 출력이 영원히 안 됨
```bash
# 해결책 1: 체크리스트 항목 줄이기 (6 → 3개)
# 해결책 2: max-iterations 줄이기 (30 → 15회)
# 해결책 3: PROMPT.md의 예시 더 구체화
```

### 문제: 비용이 너무 높음
```bash
# 해결책: 더 저렴한 모델 사용
CLAUDE_MODEL=haiku ./ralph-loop.sh --max-iterations 10
```

---

## ✅ 성공 표준

이 실습이 성공적으로 완료되었다면:

- [ ] proverbs.md에 5개의 완성된 속담이 있다
- [ ] 각 속담마다 뜻, 변형 2개, 현대 예시가 있다
- [ ] fix_plan.md에 "✅ ALL DONE"이 표시되었다
- [ ] ralph-loop.sh가 자동으로 멈췄다
- [ ] 총 비용이 예상 범위 내다 (Sonnet: ~$6)
- [ ] 속담의 품질이 라운드마다 개선되었다

---

**다음: [PROMPT.md](./PROMPT.md)를 읽고 실습을 시작하세요!**


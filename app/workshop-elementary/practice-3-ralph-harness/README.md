# 실습 3: Ralph & Harness - 한글 속담 생성 자동화

**목표**: bash 루프로 AI를 반복 실행해서 한글 속담 생성을 점진적으로 개선하는 자동화 패턴 학습

**소요 시간**: 25분  
**난이도**: ⭐⭐⭐ (중급~고급)  
**필수 도구**: Claude Code, Bash, (선택) Claude 훅 설정

---

## 📖 실습의 의미

### Ralph 패턴이란?

Ralph Wiggum (심슨 가족의 우둔하지만 끈질긴 캐릭터)처럼:
- 같은 프롬프트를 계속 반복 실행
- 매번 조금씩 개선
- 목표 도달까지 멈추지 않음

```
라운드 1: 기본 속담 생성
라운드 2: 의미 설명 추가
라운드 3: 현대 예시 작성
라운드 4: 시적 개선
라운드 5: 최종 검증 → ALL DONE
```

### Harness 개념

**Harness(말굴레)**: AI를 제어하는 메타 계층

```
┌─────────────────────────────────┐
│    Claude Code (AI Agent)        │  ← 속담 생성 작업
├─────────────────────────────────┤
│  Bash + Hooks (Harness Layer)   │  ← 반복, 진행 추적, 검증
├─────────────────────────────────┤
│   File System (Meta-Harness)    │  ← fix_plan.md, hooks.json
└─────────────────────────────────┘
```

이번 실습에서는 **3단계 하네스**를 모두 구축합니다.

---

## 🚀 실습 구조

### 한글 속담 생성 예제

```
🎯 최종 목표:
한글 속담의 변형과 현대 적용을 자동으로 생성

📋 작업 체크리스트:
1. [ ] 기본 속담 5개 생성 (한자어 원문)
2. [ ] 각 속담의 뜻 작성
3. [ ] 속담 변형 2개씩 생성
4. [ ] 현대 예시 추가
5. [ ] 시적 수준 향상
6. [ ] 최종 검증 및 정렬
✅ ALL DONE
```

### 작동 원리

#### Phase 1: 자동화 설정 (5분)
- `PROMPT.md` 작성: 속담 생성 프롬프트
- `fix_plan.md` 생성: 진행도 추적 템플릿
- `hooks.json` 생성: Claude 훅 설정

#### Phase 2: 하네스 구축 (5분)
- `ralph-loop.sh` 작성: 반복 실행 스크립트
- `task-tracker.sh` 작성: 진행도 모니터링
- 최대 반복 설정: `--max-iterations 30`

#### Phase 3: 실행 & 모니터링 (15분)
- 루프 시작: `./ralph-loop.sh`
- 각 라운드마다:
  - 속담 생성 진행도 확인
  - 타스크 완료 상태 체크
  - 에러 발생 시 프롬프트에 "표지판" 추가
- "ALL DONE" 출력 시 자동 종료

---

## 🔧 구축 단계별 가이드

### 1단계: PROMPT.md 작성 (3분)

한글 속담 생성 프롬프트를 작성합니다.

```markdown
# 한글 속담 생성 및 개선

## 목표
한글 속담을 생성하고, 의미를 설명하며, 현대 예시를 작성해줘.

## 규칙
1. 한 라운드에서 한 가지 작업에 집중
2. 각 완료 후 fix_plan.md 갱신
3. 모두 끝나면 "✅ ALL DONE" 표시

## 현재 상태
(fix_plan.md 내용이 자동으로 삽입됨)
```

### 2단계: fix_plan.md 템플릿 생성 (2분)

```markdown
# 속담 생성 진행도

## 체크리스트
- [ ] 기본 속담 5개 생성
- [ ] 각 속담의 뜻 작성
- [ ] 속담 변형 2개씩 생성
- [ ] 현대 예시 추가
- [ ] 시적 수준 향상
- [ ] 최종 검증

## 현재 생성된 속담
(생성된 내용이 여기에 누적됨)

## 상태
진행 중: 라운드 1 시작
```

### 3단계: hooks.json 생성 (선택사항)

Claude 훅을 설정하여 자동 검증을 추가합니다.

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "command": "grep -q 'ALL DONE' fix_plan.md && echo '✅ Progress checkpoint reached' || echo '⏳ Still working...'",
        "description": "Check progress after each edit"
      }
    ]
  }
}
```

### 4단계: ralph-loop.sh 작성 (3분)

```bash
#!/bin/bash

MAX_ITERATIONS=30
ITERATION=1
PROVERB_FILE="proverbs.md"

echo "🚀 한글 속담 생성 Ralph 루프 시작"
echo "최대 반복: $MAX_ITERATIONS 회"
echo ""

while [ $ITERATION -le $MAX_ITERATIONS ]; do
  echo "📍 라운드 $ITERATION/$MAX_ITERATIONS"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  
  # Claude에 프롬프트 + 현재 상태 전달
  claude -p "$(cat PROMPT.md)

## 현재 진행도:
$(cat fix_plan.md)

## 지금까지 생성된 내용:
$([ -f "$PROVERB_FILE" ] && cat "$PROVERB_FILE" || echo '(아직 없음)')"
  
  # 완료 신호 확인
  if grep -q "ALL DONE" fix_plan.md; then
    echo ""
    echo "🎉 완료! 모든 속담이 생성되었습니다."
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    break
  fi
  
  ITERATION=$((ITERATION + 1))
  sleep 2
done

if [ $ITERATION -gt $MAX_ITERATIONS ]; then
  echo "⚠️  최대 반복 횟수 도달"
  echo "진행도를 확인하세요: cat fix_plan.md"
fi
```

### 5단계: task-tracker.sh 작성 (2분)

```bash
#!/bin/bash

# 진행도 실시간 모니터링
watch_progress() {
  local file="fix_plan.md"
  local last_state=""
  
  while true; do
    if [ -f "$file" ]; then
      local current_state=$(grep "- \[" "$file" | wc -l)
      local completed=$(grep "- \[x\]" "$file" | wc -l)
      
      if [ "$current_state" != "$last_state" ]; then
        clear
        echo "📊 속담 생성 진행도"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo "완료: $completed/$current_state"
        echo ""
        cat "$file"
        last_state="$current_state"
      fi
    fi
    
    sleep 1
  done
}

watch_progress
```

---

## 🎯 실행 방법

### 기본 실행
```bash
chmod +x ralph-loop.sh
chmod +x task-tracker.sh

# 터미널 1: 메인 루프 실행
./ralph-loop.sh

# 터미널 2: 진행도 모니터링 (선택사항)
./task-tracker.sh
```

### 비용 최적화 실행
```bash
# Sonnet 모델로 실행하여 비용 절감
export CLAUDE_MODEL=sonnet
./ralph-loop.sh --max-iterations 15
```

---

## 🔑 핵심 개념 3가지

### 1️⃣ 명확한 종료 신호

Ralph 루프가 언제 멈춰야 하는지 명확해야 합니다.

```markdown
# fix_plan.md
- [x] 기본 속담 5개 생성
- [x] 각 속담의 뜻 작성
- [x] 속담 변형 2개씩 생성
- [x] 현대 예시 추가
- [x] 시적 수준 향상
- [x] 최종 검증
✅ ALL DONE  ← 이 신호로 루프 종료
```

### 2️⃣ 비용 관리

```bash
--max-iterations 30  # 최대 30회 반복
```

- Sonnet 모델: 라운드당 ~$0.2 × 30 = ~$6
- Opus 모델: 라운드당 ~$1 × 30 = ~$30

**권장**: 처음에는 10 라운드로 시작해서 결과 확인

### 3️⃣ 표지판 패턴 (에러 반복 방지)

Claude가 같은 실수를 반복하면, PROMPT.md에 "표지판"을 심습니다:

```markdown
# PROMPT.md에 추가

⚠️ **주의사항**
- 속담은 반드시 한글로 작성
- 한자어는 병기하되 가독성 우선
- 현대 예시는 2024년 기준의 상황 사용

✅ **좋은 예시**
원문: 호랑이는 죽어 가죽을 남기고 사람은 죽어 이름을 남긴다
뜻: 사람은 평생의 명성과 평판을 남겨야 한다
변형: 예술가는 죽어도 작품을 남긴다
현대 예시: 유명한 작가는 사후에도 그의 책으로 기억된다
```

다음 라운드부터 Claude가 자동으로 이 규칙을 발견하고 적용합니다.

---

## 📊 진행도 변화 예상

### Round 1
```
- [ ] 기본 속담 5개 생성
  ↓ Claude: "5개의 속담을 생성했습니다"
- [x] 기본 속담 5개 생성
```

### Round 2
```
- [x] 기본 속담 5개 생성
- [ ] 각 속담의 뜻 작성
  ↓ Claude: "각 속담에 뜻을 추가했습니다"
- [x] 각 속담의 뜻 작성
```

### Round 3-5
```
점진적 진행... (동일 패턴)
```

### Final
```
- [x] 기본 속담 5개 생성
- [x] 각 속담의 뜻 작성
- [x] 속담 변형 2개씩 생성
- [x] 현대 예시 추가
- [x] 시적 수준 향상
- [x] 최종 검증

✅ ALL DONE
```

---

## ⏱️ 시간 분배

| 단계 | 시간 | 설명 |
|---|---|---|
| 개념 이해 | 3분 | Ralph와 Harness 이해 |
| PROMPT.md 작성 | 2분 | 속담 생성 프롬프트 |
| fix_plan.md 생성 | 1분 | 체크리스트 템플릿 |
| 스크립트 작성 | 4분 | ralph-loop.sh, task-tracker.sh |
| 실행 및 모니터링 | 15분 | 루프 실행 및 진행도 추적 |
| **합계** | **25분** |  |

---

## 🎓 배우는 것

✅ **Ralph 패턴의 원리**
- 반복이 자동화의 핵심
- 명확한 종료 신호의 중요성

✅ **Harness 개념**
- bash 스크립트가 AI 실행을 제어
- 파일 기반 상태 관리
- 훅을 통한 자동화

✅ **점진적 개선**
- 한 번에 완벽한 결과를 기대하지 않음
- 각 라운드마다 작은 진전이 큰 결과로
- 실패 패턴을 코드로 "기억"시키기

✅ **자동화의 실제 가치**
- 반복 작업 제거
- 비용 제어 (max-iterations)
- 진행도 추적의 자동화

---

## 💡 실습 팁

### Tip 1: 작은 체크리스트부터
처음부터 6개 모두 할 필요 없음. 3개부터 시작하세요:
```markdown
- [ ] 기본 속담 5개 생성
- [ ] 의미 설명 추가
- [ ] 현대 예시 작성
✅ ALL DONE
```

### Tip 2: 프롬프트 개선 프로세스
1. Round 1-2에서 동작 확인
2. Round 3에서 프롬프트 보완 (표지판 추가)
3. Round 4-5에서 품질 향상

### Tip 3: 비용 추적
```bash
# 비용 계산
ROUNDS=$(grep "라운드" ralph-loop.sh | grep -o "[0-9]*")
COST_PER_ROUND=0.2  # Sonnet 기준
echo "예상 비용: $((ROUNDS * COST_PER_ROUND))" 
```

---

## 🔗 다음 단계

→ [실습 4: Claude × Codex 검증 루프](../practice-4-claude-codex/README.md)

Ralph는 "같은 모델 반복 실행"이라면, 다음은 "다른 모델로 검증"하는 패턴입니다.

---

## 📋 완성도 체크

실습을 마쳤다면 다음을 확인하세요:

- [ ] PROMPT.md를 작성했다
- [ ] fix_plan.md 템플릿을 생성했다
- [ ] ralph-loop.sh를 작성했다
- [ ] task-tracker.sh를 작성했다
- [ ] hooks.json을 설정했다 (선택사항)
- [ ] 실행 권한을 줬다 (`chmod +x`)
- [ ] 루프를 실행했다
- [ ] 진행도가 점진적으로 개선된다
- [ ] "ALL DONE" 메시지가 출력됐다
- [ ] proverbs.md에 최종 결과물이 저장됐다

---

**Ready to start? 시작 준비가 되셨으면 [PROMPT.md](./PROMPT.md)를 열고 진행하세요!** 🚀

# 🚀 Quick Start Guide (5분)

**목표**: 워크숍의 가장 중요한 부분(Practice 3: Ralph 루프)을 빠르게 경험하기

---

## Step 1: 환경 확인 (1분)

```bash
# 필수 도구 확인
claude --version      # Claude Code CLI
node --version        # Node.js
python3 --version     # Python
```

모두 설치되어 있다면 계속 진행하세요.

---

## Step 2: Practice 3 시작 (4분)

### 2-1. 디렉토리 이동

```bash
cd app/workshop-elementary/practice-3-ralph-harness
```

### 2-2. 파일 확인

```bash
ls -la
# 다음 파일들이 있는지 확인:
# - README.md (실습 설명)
# - PROMPT.md (Claude가 읽을 프롬프트)
# - CLAUDE.md (컨텍스트)
# - ralph-loop.sh (자동화 스크립트)
# - checklist.md (완료 목록)
```

### 2-3. Ralph 루프 시작

```bash
# 옵션 1: 기본 실행 (Sonnet, 30회 반복)
./ralph-loop.sh

# 옵션 2: Haiku로 저비용 실행
./ralph-loop.sh --model haiku --max-iterations 10

# 옵션 3: 커스텀 설정
./ralph-loop.sh --model sonnet --max-iterations 20
```

### 2-4. 진행도 모니터링 (다른 터미널)

```bash
# 터미널 2에서:
./task-tracker.sh

# 또는 수동으로:
watch -n 1 'tail -20 fix_plan.md'
```

---

## What You'll See

### 첫 번째 라운드 (1-2분)

```
📍 라운드 1/30
Progress: 0/6
━━━━━━━━━━━━━━━━━━━━━━
ℹ️  Executing Claude (sonnet)...

[Claude가 한글 속담 5개 생성]

⏳ 다음 라운드로 진행 중...
```

### 진행 중 (계속 반복)

```
📍 라운드 2/30
Progress: 1/6
━━━━━━━━━━━━━━━━━━━━━━
ℹ️  Executing Claude (sonnet)...

[Claude가 속담의 뜻을 상세히 설명]

📊 Progress: 1/6 tasks (16%)
```

### 완료 (6-8라운드 후)

```
📍 라운드 6/30
Progress: 6/6
━━━━━━━━━━━━━━━━━━━━━━
✅ ALL DONE signal detected!

🎉 작업 완료!

최종 완료율: 6/6 (100%)
```

---

## Result

실행이 완료되면:

### proverbs.md

```markdown
# 한글 속담 생성 결과

## 속담 1: 호랑이는 죽어 가죽을 남기고...

원문: 호랑이는 죽어 가죽을 남기고 인간은 죽어 이름을 남긴다
뜻: 모든 존재는 죽음 이후에도 무언가를 남긴다는 의미

변형 1: 사람은 죽어 이름을 남긴다
변형 2: 죽음 후에도 명성은 영원하다

현대 예시: 위대한 발명가 에디슨은 죽었지만...

...
```

### fix_plan.md

```markdown
# 속담 생성 진행도

## 체크리스트

- [x] 기본 속담 5개 생성
- [x] 각 속담의 뜻 상세 작성
- [x] 속담 변형 2개씩 생성
- [x] 현대 예시 추가
- [x] 시적 수준 향상
- [x] 최종 검증 및 정렬

✅ ALL DONE
```

---

## Cost Estimation

| 모델   | 라운드당 | 30회 반복 | 실제    |
| ------ | -------- | --------- | ------- |
| Haiku  | $0.05    | $1.50     | ~$0.80  |
| Sonnet | $0.2     | $6        | ~$3-4   |
| Opus   | $1       | $30       | ~$15-20 |

**권장**: Sonnet (30회 반복, ~$4-5 소비)

---

## Troubleshooting

### 문제 1: ralph-loop.sh 실행 안 됨

```bash
# 해결책
chmod +x ralph-loop.sh
./ralph-loop.sh
```

### 문제 2: Claude가 계속 영어로 작성

```
# fix_plan.md에 아래 라인 추가
⚠️ **중요: 속담은 반드시 한글로 작성. 변형도 한글.**
```

### 문제 3: 30회 다 돌아도 "ALL DONE" 안 나옴

```bash
# 해결책 1: 체크리스트 항목 줄이기
# PROMPT.md 수정: 6개 → 3개 항목

# 해결책 2: 더 저렴한 모델로
./ralph-loop.sh --model haiku --max-iterations 10
```

---

## 다음 단계

### Practice 3 심화

```bash
# Ralph 루프 사용자 정의
cat PROMPT.md    # 프롬프트 수정해보기
cat CLAUDE.md    # 아키텍처 이해하기
```

### 전체 워크숍 (60분)

```bash
# 현재 위치: practice-3-ralph-harness (완료)

# 다른 실습 진행:
cd ../practice-1-pokemon-card && cat README.md   # 포켓몬 카드 (20분)
cd ../practice-2-design-md && cat README.md      # DESIGN.md (10분)

# 마지막: 데모 감상
cd ../practice-5-opencode-agent
cat README.md                                     # OpenCode 멀티에이전트 (5분)
```

---

## 학습 목표 달성

이 Quick Start 후에는 다음을 이해합니다:

- ✅ **Ralph 패턴**: 같은 프롬프트 반복 → 점진적 개선
- ✅ **Harness 개념**: bash로 AI를 제어하는 메타층
- ✅ **상태 관리**: 파일 기반 진행도 추적
- ✅ **비용 제어**: max-iterations로 안전하게 반복
- ✅ **표지판 패턴**: 에러를 프롬프트에 "기억"시키기

---

## 추가 리소스

### 이 실습 관련
- 📖 [Practice 3: Ralph & Harness 전체 가이드](./practice-3-ralph-harness/README.md)
- ✅ [완료 체크리스트](./practice-3-ralph-harness/checklist.md)
- 💰 [비용 추정 & 최적화](./practice-3-ralph-harness/PROMPT.md)

### 다른 실습 가이드
- 🎴 [Practice 1: 포켓몬 카드 (20분)](./practice-1-pokemon-card/README.md)
- 🎨 [Practice 2: DESIGN.md (10분)](./practice-2-design-md/README.md)
- 🤖 [Practice 5: OpenCode 멀티에이전트 (5분, 데모)](./practice-5-opencode-agent/README.md)

### 전체 워크숍
- 📖 [전체 README](./README.md)
- 🔧 [상세 설정 가이드](./SETUP.md)
- 📋 [문제 해결 가이드](./TROUBLESHOOTING.md)

---

**축하합니다! 🎉 Ralph와 Harness의 기본을 이해하셨습니다!**

다음은 [전체 워크숍 (60분)](./README.md)에서 다른 실습들을 시작해보세요.

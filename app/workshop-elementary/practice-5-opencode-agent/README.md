# Practice 5: OpenCode 멀티에이전트 크롤러

**목표**: 5명의 AI 에이전트가 협력해서 뉴스 크롤링 → 요약 → 슬랙 발송을 자동화하는 멀티에이전트 시스템

**시간**: 5분 (주로 데모 시연)  
**난이도**: ⭐⭐⭐ (고급)

---

## 학습 목표

이 실습을 마치면 다음을 이해합니다:

- ✅ **멀티에이전트 아키텍처**: 5명의 에이전트가 각자 역할 수행
- ✅ **역할 분담**: Crawler, Summarizer, Notifier, Validator, Scheduler
- ✅ **상태 관리**: `mission.md`로 전체 진행도 추적
- ✅ **OpenCode 기본**: 오픈소스 모델로 비용 절감
- ✅ **무한 루프 설계**: 안전한 5라운드 제한

---

## 구조

### 핵심 파일

| 파일 | 용도 |
|------|------|
| `opencode.json` | OpenCode 프로젝트 설정 (에이전트 정의, 역할, 프롬프트) |
| `opencode-loop.sh` | 멀티에이전트 루프 실행 스크립트 |
| `mission.md` | 전체 진행도 및 상태 추적 |
| `task-tracker.sh` | 실시간 진행 모니터링 스크립트 |
| `schedule.json` | 라운드별 스케줄 상태 |
| `.claude/settings.json` | Claude Code 로컬 설정 (mission.md 자동 업데이트 후킹) |

### 에이전트 역할 (5명)

```
┌─────────────────┐
│ 1. Scheduler    │  (언제, 어디서 시작할지)
└────────┬────────┘
         │
    ┌────▼────┐
    │ 2. Crawler  │  (뉴스 수집)
    └────┬────┘
         │
    ┌────▼──────────┐
    │ 3. Summarizer │  (내용 요약)
    └────┬──────────┘
         │
    ┌────▼────────┐
    │ 4. Validator │  (검증 & 중복제거)
    └────┬────────┘
         │
    ┌────▼────────┐
    │ 5. Notifier │  (Slack 발송)
    └─────────────┘
```

---

## 실행 방법

### 1단계: 설정 확인

```bash
cd practice-5-opencode-agent

# OpenCode 설정 파일 확인
cat opencode.json

# 미션 초기 상태 확인
cat mission.md
```

### 2단계: 드라이런 (선택)

```bash
# 실제 발송 없이 프로세스만 테스트
./opencode-loop.sh --dry-run
```

### 3단계: 실행

```bash
# 실제로 멀티에이전트 루프 시작
./opencode-loop.sh

# 또는 백그라운드에서 실행
./opencode-loop.sh &
```

### 4단계: 모니터링 (다른 터미널)

```bash
# 실시간 진행도 추적
./task-tracker.sh

# 또는 수동으로
watch -n 2 'cat mission.md | tail -20'
```

---

## 무엇을 보게 될까?

### Round 1 (20초)

```
📍 Round 1/5
🔄 Scheduler: Planning...
🔄 Crawler: Fetching AI news...
⏳ Waiting for crawler...
```

### Round 2-4 (진행 중)

```
📍 Round 2/5
✅ Crawler: Collected 5 articles
🔄 Summarizer: Processing...
🔄 Validator: Checking duplicates...
📊 Progress: 10/15 articles
```

### Round 5 (완료)

```
📍 Round 5/5
✅ Crawler: Collected 15 articles total
✅ Summarizer: 15 summaries
✅ Validator: 12 unique (3 filtered)
✅ Notifier: Sent to Slack
✅ ALL ROUNDS COMPLETED

📈 Final Stats:
   Total Articles: 15
   Unique: 12
   Duration: 2min 30sec
   Last sent: 14:05 KST
```

---

## 결과물

### mission.md 최종 상태

```markdown
# AI 뉴스 크롤러 Mission

목표: AI 뉴스 수집 → 요약 → Slack 발송

...

## 최종 결과
| 지표 | 값 |
|---|---|
| 총 라운드 | 5/5 |
| 총 뉴스 | 15 |
| 총 시간 | 2분 30초 |
| 중복 제거 | 3 |
| 에러 발생 | 0 |
| 슬랙 발송 | 12 |
| 마지막 발송 | 14:05 KST |

## 종료 신호
✅ ALL_ROUND_COMPLETED
```

---

## 핵심 개념

### 1. 멀티에이전트 협력 (Multi-Agent Orchestration)

```
에이전트들이 순차적으로 작업을 넘기며 협력:
Crawler → Summarizer → Validator → Notifier
```

### 2. 상태 기반 진행도 추적

```
mission.md가 "공유 메모리" 역할:
- 각 에이전트가 상태 업데이트
- 다음 에이전트가 이전 상태를 읽음
- 전체 진행도를 한 파일에서 추적
```

### 3. 안전한 무한 루프 설계

```bash
Max Rounds: 5  # 무한 루프 방지
Timeout: 5min per round  # 행(hang) 방지
Error Recovery: 자동 재시도
```

---

## Troubleshooting

### 문제 1: OpenCode CLI가 설치되지 않음

```bash
# OpenCode 설치 (공식)
curl https://opencode.ai/install | bash

# 확인
opencode --version
```

### 문제 2: Slack 발송 실패

```bash
# SLACK_WEBHOOK_URL 확인
echo $SLACK_WEBHOOK_URL

# .env 파일에 추가
export SLACK_WEBHOOK_URL="https://hooks.slack.com/..."
```

### 문제 3: 5라운드가 끝나도 "ALL_ROUND_COMPLETED" 없음

```bash
# mission.md 직접 확인
tail -20 mission.md

# 수동 종료
pkill opencode-loop
```

---

## 다음 단계

- 🎓 **본 실습**: 멀티에이전트의 기본 구조 이해
- 📈 **고급**: OpenCode를 프로덕션 시스템으로 확장
  - 실제 API (HackerNews, Medium 등) 연결
  - 데이터베이스에 저장
  - 웹 대시보드 추가

---

## 참고

- 📖 [OpenCode 공식 가이드](https://opencode.ai/docs)
- 🔧 [opencode.json 스키마](./opencode.json)
- 📊 [mission.md 형식](./mission.md)

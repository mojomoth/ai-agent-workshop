# 🚀 OpenCode 멀티에이전트 Quick Start (5분)

**목표**: 에이전트 역할 분담으로 빠른 자동화 실현하기

---

## 개념: Ralph → OpenCode

Ralph와의 차이:

```
Ralph (Practice 3)
- 같은 프롬프트 반복
- 순차 실행: 5라운드 = 5배 시간
- 한 모델 집중

OpenCode
- 역할 분담
- 병렬 실행: 3배 빠름
- 여러 모델 분산 (비용 절감)
```

---

## 예제: 뉴스 크롤러 파이프라인

```
[Manager] 지시
   ↓
[Crawler] HackerNews + Reddit + Arxiv 동시 수집
[Summarizer] 텍스트 요약 (병렬)
[Notifier] Slack 발송 (병렬)
   ↓
1분 만에 완료 (순차면 3분 필요)
```

---

## Step 1: 에이전트 역할 정의 (2분)

**`mission.md`에 작업 정의:**

```markdown
# 뉴스 수집 자동화

## Round 1

### Task 1: Crawler (병렬 3개)
- HackerNews top 5 가져오기
- Reddit r/programming top 5 가져오기
- Arxiv latest 3 가져오기

### Task 2: Summarizer
- 위 13개 항목을 한국어 200자로 요약
- 감정 분석 (긍정/중립/부정)

### Task 3: Notifier
- 요약본을 Slack #ai-news 채널에 발송
- 포맷: [출처] 제목\n요약\n감정

Status: Pending
```

---

## Step 2: 에이전트 구성 설정 (1분)

**`opencode-config.json` 작성:**

```json
{
  "manager": {
    "model": "opencode-go/glm-5.1",
    "role": "총괄 지휘 및 결과 검증"
  },
  "workers": [
    {
      "name": "crawler",
      "model": "opencode-go/kimi-k2.5",
      "count": 3,
      "permissions": ["read:external_apis"],
      "timeout": 60
    },
    {
      "name": "summarizer",
      "model": "opencode-go/mimo-v2.5",
      "count": 1,
      "permissions": ["read:local"],
      "timeout": 30
    },
    {
      "name": "notifier",
      "model": "opencode-go/glm-5",
      "count": 1,
      "permissions": ["write:slack"],
      "timeout": 30
    }
  ]
}
```

---

## Step 3: Manager에 지시 (1분)

Manager 에이전트에 제시:

```
이 mission.md를 읽고 실행해주세요:
[mission.md 전체 내용]

현재 설정:
[opencode-config.json 전체 내용]

다음을 해주세요:
1. Crawler 3개를 동시에 실행해서 데이터 수집
2. Summarizer에 결과 전달 (병렬 처리)
3. Notifier에 요약본 전달 (Slack 발송)
4. mission.md의 "Status"를 "Complete"로 업데이트
5. 모든 라운드가 완료되면 mission.md에 "✅ ALL_ROUND_COMPLETED" 추가
```

---

## Step 4: 진행도 모니터링 (1분)

터미널에서:

```bash
# mission.md 진행도 확인
watch -n 2 'tail -20 mission.md'

# 또는 Slack에서 메시지 확인
# #ai-news 채널에 요약본 도착
```

---

## 결과 예상

### mission.md (자동 업데이트됨)
```markdown
Round: 1/3
Status: Complete
  Crawler: 13 items fetched
  Summarizer: 13 summaries done (avg 195 chars)
  Notifier: message sent to #ai-news

Round: 2/3
Status: Complete
  ...

Round: 3/3
Status: Complete
  ...

✅ ALL_ROUND_COMPLETED
```

### Slack 채널
```
[HackerNews] AI가 바꾸는 검색의 미래
Claude와 ChatGPT의 경쟁으로...

[Reddit] 2026년 AI 트렌드 예측
올해는 멀티모달 AI와...

[Arxiv] Transformer 새로운 최적화 기법
기존 대비 30% 빠른...
```

---

## 핵심 개념

### 1. 역할 분담 = 병렬화
```
순차:    Crawler (1분) → Summarizer (20초) → Notifier (10초) = 1분 30초
병렬:    max(1분, 20초, 10초) = 1분
→ 1.5배 빠름
```

### 2. 권한 분리 (보안)
```
Crawler:   읽기만 (외부 API)
Summarizer: 읽기만 (로컬 텍스트)
Notifier:  쓰기만 (Slack API)
→ 한 에이전트가 다른 API 건드리지 못함
```

### 3. 비용 최적화
```
Manager (비쌈):   0.5번/라운드 (지시만)
Workers (쌈):     여러 번/라운드 (일은 많지만 쌈)
→ 전체 비용 낮음
```

---

## 언제 사용할까?

### ✅ OpenCode가 좋을 때
- 독립적인 작업들 여러 개 (병렬)
- 오래 걸리는 작업들 (수집, 처리, 발송)
- 역할이 명확함 (크롤, 정리, 발송)
- 프로덕션 자동화

### ❌ Ralph가 좋을 때
- 순차적 개선 (작업이 쌓임)
- 단순 반복
- 실험/프로토타입

---

## 비용 vs 속도

| 구성 | 시간 | 비용 |
|---|---|---|
| Ralph (순차 5회) | 5분 | $5 |
| OpenCode (병렬) | 1-2분 | $3 |
| 수동 (CLI 5번) | 15분 | $0 |

---

## 완료 체크리스트

- [ ] mission.md 작성
- [ ] opencode-config.json 구성
- [ ] Manager에 지시
- [ ] Crawler 3개 동시 실행 확인
- [ ] Summarizer에서 요약본 생성
- [ ] Notifier에서 Slack 발송
- [ ] mission.md에 "ALL_ROUND_COMPLETED" 확인

**축하합니다! 🎉 멀티에이전트 오케스트레이션 이해!**

---

## 다음 단계

### Ralph + OpenCode 결합
Practice 3 (Ralph) + Practice 5 (OpenCode)를 결합하면:

```
Ralph 루프 (점진적 개선)
  ↓
  매 라운드마다 OpenCode 호출
  ↓
  Manager → [Crawler, Summarizer, Notifier] 병렬
  ↓
  결과 통합 + 다음 라운드
```

**이것이 최강의 자동화 패턴입니다.**

---

## 참고

- OpenCode 공식: [OpenCode 문서]
- Manager-Worker 패턴: https://en.wikipedia.org/wiki/Master%E2%80%93worker_model
- 병렬 처리: https://en.wikipedia.org/wiki/Parallel_computing

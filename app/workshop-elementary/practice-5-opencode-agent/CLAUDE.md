# OpenCode 멀티에이전트 구현 가이드

## 아키텍처 기본

OpenCode는 **한 명의 Manager + 여러 Worker** 구조입니다.

```
┌─────────────┐
│   Manager   │  ← 총괄 지휘
│  (비싼 모델)  │
└──────┬──────┘
       │
    작업 할당
       │
    ┌──┴──┬────┬────┐
    ↓     ↓    ↓    ↓
  Crawler Scheduler Summarizer Notifier
  (싼 모델들, 병렬 실행)
```

## 에이전트 역할 정의

### 1. Manager (GLM-5.1)
**가장 비싼 모델** → 최소 호출

```yaml
name: manager
model: opencode-go/glm-5.1
role: |
  - 전체 워크플로우 지휘
  - 다른 에이전트에게 작업 할당
  - 결과 검증 및 통합
  - 다음 라운드 의사결정
permissions:
  - read: all
  - write: mission.md (진행도만)
```

### 2. Crawler (Kimi-K2.5)
**특화**: 데이터 수집, 웹 스크래핑

```yaml
name: crawler
model: opencode-go/kimi-k2.5
role: |
  - HackerNews/Reddit/Arxiv에서 뉴스 수집
  - JSON 형식으로 정리
  - 중복 제거 (7일 내)
permissions:
  - read: external_apis  # API 읽기만
  - write: false         # 쓰기 금지
```

### 3. Scheduler (Qwen-3.5)
**특화**: 스케줄링, 타이밍 관리

```yaml
name: scheduler
model: opencode-go/qwen3.5-plus
role: |
  - 다음 크롤 시간 결정
  - 레이트 리미팅 관리
  - 작업 큐 상태 추적
permissions:
  - read: all
  - write: mission.md, schedule.json
```

### 4. Summarizer (Mimo-V2.5)
**특화**: 텍스트 처리, 요약

```yaml
name: summarizer
model: opencode-go/mimo-v2.5-pro
role: |
  - 크롤한 텍스트를 한국어 200자로 요약
  - SEO 해시태그 생성
  - 감정 분석 (선택)
permissions:
  - read: all
  - write: false  # 네트워크 금지
  - network: false
```

### 5. Notifier (GLM-5)
**특화**: 메시지 발송

```yaml
name: notifier
model: opencode-go/glm-5
role: |
  - 요약본을 Slack에 발송
  - 메시지 포맷팅
  - 실패 시 재시도
permissions:
  - read: all
  - write: true  # Slack API만
  - endpoints:
      allowed:
        - "https://hooks.slack.com/..."
      denied:
        - "*"
```

## 병렬 실행 패턴

```python
# Manager가 이렇게 지시
jobs = [
  {
    "agent": "crawler",
    "task": "fetch HackerNews top 5",
    "parallel": true
  },
  {
    "agent": "crawler",
    "task": "fetch Reddit r/MachineLearning top 5",
    "parallel": true
  },
  {
    "agent": "crawler",
    "task": "fetch Arxiv latest 3",
    "parallel": true
  }
]

# OpenCode가 이 3개를 동시 실행
# 결과를 모아서 Summarizer에 전달
```

## 권한 분리 (PoLP - Principle of Least Privilege)

**핵심 규칙**: 각 에이전트는 **필요한 것만** 접근

```json
{
  "crawler": {
    "write": false,
    "comment": "읽기만 = 실수로 DB 지울 수 없음"
  },
  "notifier": {
    "endpoints_allowed": ["slack://..."],
    "endpoints_denied": ["*"],
    "comment": "Slack만 = 다른 API 건드리지 않음"
  },
  "summarizer": {
    "network": false,
    "comment": "로컬 텍스트만 = 외부 API 호출 금지"
  }
}
```

## Mission-Based 루프 vs Ralph

| 비교 | Ralph | OpenCode |
|---|---|---|
| 방식 | 같은 프롬프트 반복 | 에이전트 역할 분담 |
| 실행 | 순차 (한 번에 1개) | 병렬 (동시 여러 개) |
| 속도 | 느림 (5 라운드 = 5배 시간) | 빠름 (3배 빠름) |
| 비용 | 저 (한 모델 집중) | 조절 가능 (싼 모델 분산) |
| 이해 | 쉬움 (while 루프) | 어려움 (역할 정의) |
| 언제 쓸까 | 점진적 개선 | 대규모 반복 자동화 |

## 종료 신호

Ralph: `ALL DONE` ← 간단

OpenCode: `mission.md`에 `✅ ALL_ROUND_COMPLETED` ← 더 구조화

```yaml
# mission.md (자동 업데이트됨)
Round: 1/5
Status: Complete
  Crawler: 8 items fetched
  Summarizer: 8 summaries done
  Notifier: message sent to #ai-news

Round: 2/5
Status: Complete
...

Round: 5/5
Status: Complete

✅ ALL_ROUND_COMPLETED
```

Manager가 이 신호를 감지하면 자동 종료.

## 비용 최적화 전략

**1. 비싼 모델은 의사결정만**
```
Manager (GLM-5.1) = 0.5번/라운드 (지시 한 번)
```

**2. 싼 모델은 작은 일들**
```
Crawler (Kimi) = 3번/라운드 (HN, Reddit, Arxiv)
Summarizer (Mimo) = 1번/라운드 (8개 요약)
Notifier (GLM-5) = 1번/라운드 (메시지 한 개)
```

**3. 병렬 실행 = 시간 단축**
```
순차: Crawler (1분) + Summarizer (20초) + Notifier (10초) = 1분 30초
병렬: max(1분, 20초, 10초) = 1분
```

## 주의사항

### 메모리 누수
```
# ❌ 나쁜 예
agents = []
for i in range(100):
  agents.append(spawn_agent())  # 메모리 꼬임

# ✅ 좋은 예
manager.spawn_task_batch(
  tasks=[...],
  max_concurrent=5,  # 동시 5개만
  cleanup_on_complete=True
)
```

### 타임아웃
```
# Crawler는 느릴 수 있음
crawler.timeout = 60  # 60초로 넉넉하게

# Summarizer는 빨라야 함
summarizer.timeout = 10

# Notifier는 중요하니 길게
notifier.timeout = 30 + retry(3)
```

## 실전 예제

```bash
# 설정 파일
cat opencode-config.json
{
  "manager": { "model": "opencode-go/glm-5.1" },
  "workers": [
    { "name": "crawler", "model": "opencode-go/kimi-k2.5", "count": 1 },
    { "name": "summarizer", "model": "opencode-go/mimo-v2.5-pro", "count": 1 },
    { "name": "notifier", "model": "opencode-go/glm-5", "count": 1 }
  ]
}

# 실행
opencode run \
  --config opencode-config.json \
  --mission mission.md \
  --agent manager \
  --loop-until "ALL_ROUND_COMPLETED"
```

## Next: Hybrid Pattern

Ralph + OpenCode를 결합:

```
Ralph 루프 (5회)
  ↓
  매 라운드마다 OpenCode 호출
  ↓
  Manager → [Crawler, Summarizer, Notifier] 병렬
  ↓
  결과 반영
```

이게 프로덕션급 자동화입니다.

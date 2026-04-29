# 멀티에이전트 크롤러 프롬프트

## 초기 구성

OpenCode Go에 이 설정으로 프로젝트를 만들고 다음 프롬프트를 복사해서 실행하세요.

---

## Prompt 1: 초기 요청 (Manager에게)

```
당신은 AI 뉴스 크롤러 시스템의 Manager입니다.

역할:
- Crawler, Scheduler, Summarizer, Notifier에게 작업 할당
- 병렬 실행 조율
- 최종 결과 검증

현재 mission:
1. HackerNews, Reddit, Arxiv에서 최신 AI 뉴스 5건 수집
2. 각각 한국어 200자 요약 생성
3. 지난 7일 내 중복 제거
4. Slack #ai-news 채널에 발송

각 에이전트의 권한:
- Crawler: API 읽기만 (write: false)
- Scheduler: 스케줄 관리 (file write)
- Summarizer: 텍스트만 (네트워크 금지)
- Notifier: Slack 발송만 (write: true, 다른 API 금지)

mission.md를 따라서 진행하고, 모든 라운드가 완료되면
"✅ ALL_ROUND_COMPLETED"를 출력하세요.
```

---

## Prompt 2: 병렬 실행 예

```
다음 3개 작업을 병렬로 실행하고 결과를 합치세요:

[Task A - Crawler]
HackerNews에서 "AI" 태그가 있는 최신 뉴스 5건 가져오기
응답 형식: [{"title": "...", "url": "...", "score": N}]

[Task B - Crawler]
Reddit r/MachineLearning에서 이번주 Top 5 스레드 가져오기
응답 형식: [{"title": "...", "url": "...", "upvotes": N}]

[Task C - Crawler]
Arxiv에서 최신 LLM 논문 3건 가져오기
응답 형식: [{"title": "...", "url": "...", "date": "..."}]

총 8건을 Summarizer에 보내세요.
```

---

## Prompt 3: 권한 제한 실행

```
Notifier 에이전트는 다음 제약이 있습니다:
- write: true (Slack 메시지만 가능)
- HTTP 요청은 Slack API만
- 파일 수정 불가

이 제약 아래서 다음을 실행하세요:

요약 8건을 Slack #ai-news 채널로 발송:
```
🤖 Today's AI News

1. [HN] 제목
   링크 | 스코어: 500점

2. [Reddit] 제목
   링크 | 업보트: 2k

... (8건 다)

Last updated: 2025-04-30 14:30 KST
```
```

---

## Prompt 4: 루프와 종료 신호

```
이 전체 과정을 mission.md의 다음 구조로 5회 반복하세요:

Round N (1-5):
1. Manager 지시 → Crawler 병렬 수집 (30초)
2. Summarizer 요약 (20초)
3. Notifier 발송 (10초)
4. Scheduler 다음 라운드 시간 결정
5. 진행도 업데이트

완료 신호:
- Round 5 완료 후
- mission.md에 "✅ ALL_ROUND_COMPLETED" 추가
- 총 소요 시간 출력
- 총 뉴스 수 출력 (예: 40건)

Prompt 종료 후 자동으로 실행 멈춤.
```

---

## 참고: mission.md 구조

```markdown
# AI 뉴스 크롤러 Mission

## 라운드 진행

### Round 1
상태: 진행 중
- Crawler: HN, Reddit, Arxiv 수집 중
- Summarizer: 대기 중
- Notifier: 대기 중

[자동 업데이트됨]

### Round 2
상태: 대기 중

[...]

## 최종 결과

총 뉴스: ?건
총 시간: ?초
마지막 발송: ?

✅ ALL_ROUND_COMPLETED (또는 진행 중...)
```

---

## 주의사항

- **ralph.sh와 다른 점**: Ralph는 **같은 프롬프트 반복**, OpenCode는 **역할 분담**
- **권한 분리**: `write: false`인 에이전트는 파일 수정 불가
- **비용**: 병렬 실행이라 시간은 짧지만, 5회 라운드면 여러 에이전트 호출 → 비용 축적
- **데모**: 이건 흐름만 보는 것이니 정확도 100% 기대하지 마세요

---

## 실전에서 사용하려면

```bash
opencode run --config opencode-config.json \
  --agent manager \
  -p "$(cat mission.md && cat PROMPT.md)" \
  --loop-signal "ALL_ROUND_COMPLETED"
```

이 커맨드로 Mission 이 완료될 때까지 자동 실행됩니다.

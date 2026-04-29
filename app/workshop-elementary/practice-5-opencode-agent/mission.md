# AI 뉴스 크롤러 Mission

**목표**: 최신 AI 뉴스 5건 수집 → 요약 → 슬랙 발송 (멀티에이전트 병렬)

**시작**: 2026-04-30 14:00 KST
**라운드**: 1/5

---

## 라운드 진행

### Round 1
**상태**: 대기 중

#### Crawler (병렬 3개 작업)
- [ ] HackerNews "AI" 태그 Top 5 수집
  - 예상 시간: 15초
  - 상태: 대기 중

- [ ] Reddit r/MachineLearning Top 5 수집
  - 예상 시간: 15초
  - 상태: 대기 중

- [ ] Arxiv "LLM" 최신 3건 수집
  - 예상 시간: 10초
  - 상태: 대기 중

#### Summarizer
- [ ] 8개 기사 → 한국어 200자 요약
  - 상태: 대기 중 (Crawler 완료 후 시작)
  - 예상 시간: 20초

#### Notifier
- [ ] Slack #ai-news에 결과 발송
  - 상태: 대기 중 (Summarizer 완료 후 시작)
  - 예상 시간: 5초

#### 결과
```
Round 1 대기 중:
- 총 뉴스: ? (진행 중)
- 총 시간: ?
- 발송 상태: 대기 중
- 중복 제거됨: ?
```

---

### Round 2
**상태**: 대기 중

예상 시작: 2026-04-30 14:01 KST

#### Crawler (병렬 3개 작업)
- [ ] HackerNews 신규 5개 수집
- [ ] Reddit 신규 5개 수집
- [ ] Arxiv 신규 3개 수집

#### Summarizer
- [ ] 8개 기사 요약

#### Notifier
- [ ] Slack 발송

#### 결과
```
Round 2 대기 중:
- 총 뉴스: ?
- 중복 제거됨: ?
```

---

### Round 3
**상태**: 대기 중

---

### Round 4
**상태**: 대기 중

---

### Round 5
**상태**: 대기 중

마지막 라운드. 완료 후 모든 프로세스 종료.

---

## 최종 결과 (자동 업데이트됨)

| 지표 | 값 |
|---|---|
| 총 라운드 | 0/5 |
| 총 뉴스 | 0 |
| 총 시간 | - |
| 중복 제거 | 0 |
| 에러 발생 | 0 |
| 슬랙 발송 | 0 |
| 마지막 발송 | - |

---

## Scheduler 메모

```
다음 크롤 예약 시간 (자동 결정):
- Round 1: 14:00
- Round 2: 14:01
- Round 3: 14:02
- Round 4: 14:03
- Round 5: 14:04

(10초 간격으로 빠르게 반복)
```

---

## Manager 로그

```
[준비 중] opencode-loop.sh 실행 대기 중
```

---

## Harness State

```
Script: opencode-loop.sh
Status: Ready
Model: claude-sonnet-4-6 (manager), claude-haiku-4-5-20251001 (workers)
Max Rounds: 5
Config: opencode-config.json
```

---

## 종료 신호

모든 5 라운드가 완료되면 아래 한 줄을 추가하세요:

```
✅ ALL_ROUND_COMPLETED
```

이 신호를 감지하면 opencode-loop.sh가 자동 종료합니다.

---

## 참고: Ralph와의 차이점

| 구성 | Ralph | OpenCode |
|---|---|---|
| Round 1 | 50초 | 50초 |
| Round 2 | 50초 | 50초 |
| Round 3 | 50초 | 50초 |
| Round 4 | 50초 | 50초 |
| Round 5 | 50초 | 50초 |
| **총 시간** | **4분 10초** | **4분 10초** (병렬이지만 루프의 병렬은 안 되므로) |
| **진정한 병렬** | × | ✅ (각 라운드 내에서 Crawler 3개 동시) |

OpenCode의 강점은 **큰 규모 + 분담**일 때 더 보입니다.

예: 100개의 문서를 요약해야 한다면?
- Ralph: 1개씩 → 100번 호출 → 비용 높음
- OpenCode: 10개 배치 × 10 에이전트 동시 → 10배 빠르고, 싼 모델 사용 → 비용 10배 낮음

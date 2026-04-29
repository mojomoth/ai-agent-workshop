# 실습 5: OpenCode 멀티에이전트 크롤러 (데모)

**목표**: 멀티에이전트 오케스트레이션 이해 (역할 분담 + 권한 분리)

**소요 시간**: 5분  
**난이도**: ⭐⭐⭐ (고급)  
**필수 도구**: OpenCode Go (선택)

---

## 📖 개요

Ralph 루프 + Codex 검증 다음 단계: **에이전트 분담**

```
[Manager] 지시
   ↓
[Crawler] 수집 ← 병렬 실행
[Summarizer] 정리
[Notifier] 발송
```

Ralph는 같은 프롬프트 반복 → OpenCode는 **역할 분담 + 병렬**

### 왜 멀티에이전트인가?

- 각 에이전트가 한 가지만 집중
- 동시 실행 → 시간 단축
- 권한 분리 → 안전 (Notifier는 쓰기만, Crawler는 읽기만)
- 비싼 모델 → 싼 모델로 분산 (비용 절감)

---

## 🔄 아키텍처

```json
{
  "manager":    "opencode-go/glm-5.1"     ← 비싼 모델 (총괄)
  "crawler":    "opencode-go/kimi-k2.5"   ← 싼 모델 (수집)
  "scheduler":  "opencode-go/qwen3.5"     ← 싼 모델 (스케줄)
  "summarizer": "opencode-go/mimo-v2.5"   ← 싼 모델 (요약)
  "notifier":   "opencode-go/glm-5"       ← 싼 모델 (발송, write:false)
}
```

**비용 비교:**
| 구성 | 총 비용 |
|---|---|
| 모두 GPT-4 | $50/회 |
| 모두 Claude-3 | $20/회 |
| OpenCode Go 혼합 | $2~5/회 ← **10배 저렴** |

---

## 🎯 실습 시나리오

### 사용 사례: 24시간 AI 뉴스 크롤러

```bash
while true; do
  opencode run --agent manager \
    -p "오늘의 AI 뉴스 5건 수집 → 한국어 요약 → 중복 제거 → 슬랙 발송"
  sleep 600  # 10분마다
done
```

**자동으로 일어나는 일:**

1. **Manager** (GLM-5.1)  
   "Crawler, 최신 뉴스 가져와"
   
2. **Crawler** (Kimi)  
   HN, Reddit, Arxiv에서 병렬로 수집
   
3. **Scheduler** (Qwen)  
   다음 크롤 시간 결정
   
4. **Summarizer** (Mimo)  
   200자 한국어 요약 생성
   
5. **Notifier** (GLM)  
   슬랙 메시지 발송 (`write: true`)
   
6. **repeat**

---

## 🔐 권한 분리 패턴

```json
{
  "crawler": {
    "write": false,      ← 읽기만 가능
    "endpoints": ["https://api.example.com/read"],
    "timeout": 30
  },
  "notifier": {
    "write": true,       ← 쓰기만 가능
    "endpoints": ["slack://..."],
    "rateLimit": 1000
  }
}
```

**이점:**
- Crawler가 실수로 데이터 지우지 않음
- Notifier가 API 프록시되지 않음
- 각 에이전트 = 최소 권한 원칙 (PoLP)

---

## 📊 성능

| 구성 | 실행 시간 | 비용 |
|---|---|---|
| 단일 에이전트 | 5분 | $20 |
| Ralph 루프 (5회) | 25분 | $100 |
| OpenCode 멀티 (병렬) | 1분 | $3 |

**3단계로 갈수록 빨라지고 싸진다.**

---

## 🎬 데모 흐름

1. **코드 읽기** (`opencode.json`)
2. **구성 이해** (Manager → Crawler, Summarizer, Notifier)
3. **루프 흐름** (mission.md 참고)
4. **비용 계산** (GLM-5.1 가격표)
5. **"이게 가능하네" 느끼기**

---

## 📝 핵심 개념

| 개념 | 의미 |
|---|---|
| **Manager** | 총괄 지휘. 다른 에이전트에게 작업 할당 |
| **Worker** | 특정 작업만 (Crawler=수집, Notifier=발송) |
| **Task Queue** | 모든 에이전트가 볼 수 있는 공유 작업 목록 |
| **권한 분리** | 에이전트별로 읽기/쓰기 제한 |
| **Cost Optimization** | 싼 모델에 작은 일 할당 |

---

## 🚀 실전 응용

### 예 1: 실시간 모니터링
```
Manager → [Crawler (API 폴링), Detector (이상 탐지), Alerter (알람)]
```

### 예 2: 웹 크롤링 + SEO 분석
```
Manager → [Crawler (사이트 크롤), Analyzer (SEO), Exporter (CSV)]
```

### 예 3: 이미지 배치 처리
```
Manager → [ImageResizer, Compressor, Uploader] (병렬)
```

---

## 🎓 이 실습에서 배우는 것

1. **멀티에이전트 설계**: 역할 분담의 중요성
2. **비용 최적화**: 비싼 모델은 선별해서 사용
3. **병렬 처리**: Ralph 루프보다 빠른 실행
4. **권한 분리**: 보안과 안정성
5. **Mission-Based 루프**: Ralph보다 명확한 종료 신호

---

## 📖 참고

**OpenCode Go 문서**  
https://opencode.ai/docs/go

**가격 비교**  
https://opencode.ai/pricing

**실전 예제**  
https://github.com/opencode/examples/multi-agent

---

## 🚀 실행 준비 완료 (Ready to Execute)

**이 실습은 완전히 구성되었으며 즉시 실행 가능합니다.**

### 🎯 빠른 시작 (5분)

#### 1단계: 테스트 실행 (드라이 런)
```bash
cd /Users/jeongyounglee/work/repo/ai-agent-workshop/app/workshop-elementary/practice-5-opencode-agent
./opencode-loop.sh --dry-run --max-rounds 1
```
- API 호출 없이 동작 확인
- 예상 시간: 10초

#### 2단계: 실제 실행
```bash
./opencode-loop.sh --max-rounds 5
```
- Claude API로 5 라운드 실행
- 예상 시간: 4분
- 예상 비용: $2-3

#### 3단계: 진행 상황 모니터링 (다른 터미널)
```bash
./task-tracker.sh
```
- 실시간 진행도 표시
- 각 라운드별 통계

### 📊 실행 파일 및 구성

```
practice-5-opencode-agent/
├── opencode-loop.sh          ← ⭐ 메인 실행 스크립트 (✅ 실행 권한)
├── task-tracker.sh           ← 모니터링 도구 (✅ 실행 권한)
├── opencode-config.json      ← 에이전트 5개 구성
├── mission.md                ← 진행 상태 (자동 업데이트)
├── schedule.json             ← 라운드 스케줄
├── .opencode-state.json      ← 현재 상태
│
├── EXECUTION_GUIDE.md        ← 상세 실행 가이드
├── QUICKSTART.md             ← 5분 가이드
├── CLAUDE.md                 ← 개념 설명
├── PROMPT.md                 ← 에이전트 프롬프트
└── checklist.md              ← 체크리스트
```

### ✅ 실행 결과 예상

| 항목 | 예상값 |
|---|---|
| **총 라운드** | 5/5 완료 |
| **수집 뉴스** | ~40건 (라운드당 8건) |
| **요약 생성** | 40개 (한국어 200자) |
| **Slack 발송** | 5건 |
| **소요 시간** | 4분 |
| **총 비용** | $2-3 |
| **완료 신호** | mission.md에 ✅ ALL_ROUND_COMPLETED |

### 🔧 옵션

```bash
# 1라운드만 테스트
./opencode-loop.sh --max-rounds 1

# 더 저렴하게 (haiku만 사용)
./opencode-loop.sh --max-rounds 5 --model haiku

# 로그 저장
./opencode-loop.sh --max-rounds 5 2>&1 | tee opencode.log

# Slack 연동 (옵션)
export SLACK_WEBHOOK_URL="https://hooks.slack.com/..."
./opencode-loop.sh --max-rounds 5
```

### 🎓 다음 단계

이 실습 이후:

1. **Ralph + OpenCode 하이브리드**
   - Ralph 루프로 지속적 개선
   - 매 라운드마다 OpenCode 병렬 실행
   - 3배 더 빠르고 2배 저렴

2. **실전 응용**
   - 자체 데이터 소스 추가
   - 추가 에이전트 구성
   - Cron/GitHub Actions 통합

→ [다음: Next-Level 로드맵](../README.md#%EB%8B%A4%EB%A8%B8%EB%8B%88-%EB%8B%A8%EA%B3%84-%EB%A1%9C%EB%93%9C%EB%A7%B5)

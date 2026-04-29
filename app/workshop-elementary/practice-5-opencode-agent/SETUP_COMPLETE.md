# ✅ OpenCode 멀티에이전트 실습 - 구성 완료

**날짜**: 2026-04-30  
**상태**: 🟢 실행 준비 완료

---

## 📋 구성 체크리스트

### ✅ 필수 파일

- [x] **opencode-loop.sh** (15.9 KB) - 메인 실행 스크립트
- [x] **task-tracker.sh** (8.9 KB) - 모니터링 도구
- [x] **opencode-config.json** (6.2 KB) - 에이전트 구성
- [x] **mission.md** (3.1 KB) - 진행 상태 추적
- [x] **schedule.json** (378 B) - 라운드 스케줄
- [x] **.opencode-state.json** (182 B) - 실행 상태 기록

### ✅ 문서

- [x] **README.md** (4.5 KB) - 개요 및 실행 가이드
- [x] **EXECUTION_GUIDE.md** (7.5 KB) - 상세 실행 가이드
- [x] **QUICKSTART.md** (5.2 KB) - 5분 빠른 시작
- [x] **CLAUDE.md** (5.8 KB) - 개념 설명 및 아키텍처
- [x] **PROMPT.md** (3.6 KB) - 에이전트 프롬프트
- [x] **checklist.md** (2.5 KB) - 완료 체크리스트

### ✅ 디렉터리 구조

```
practice-5-opencode-agent/
├── .claude/                  ← VS Code 설정
├── .omc/                     ← OMC 상태
├── opencode-loop.sh         ← ⭐ 실행 권한: -rwxr-xr-x
├── task-tracker.sh          ← ⭐ 실행 권한: -rwxr-xr-x
├── opencode-config.json     ← ✅ 5개 에이전트 구성
├── mission.md               ← ✅ 템플릿 및 상태
├── schedule.json            ← ✅ 5 라운드 스케줄
├── .opencode-state.json     ← ✅ 이전 실행 기록
└── 문서 11개                 ← ✅ 모두 준비됨
```

---

## 🚀 실행 방법

### 방법 1: 드라이 런 (추천 - API 호출 없음)

```bash
cd /Users/jeongyounglee/work/repo/ai-agent-workshop/app/workshop-elementary/practice-5-opencode-agent

./opencode-loop.sh --dry-run --max-rounds 1
```

**기대 결과:**
- 스크립트가 실행되고 각 단계를 출력
- API 호출 없음
- 약 10초 소요

### 방법 2: 실제 실행 (Claude API 사용)

```bash
./opencode-loop.sh --max-rounds 5
```

**기대 결과:**
- Round 1-5 순차 실행
- mission.md 자동 업데이트
- 약 4분 소요
- 예상 비용: $2-3

### 방법 3: 병렬 모니터링

터미널 1:
```bash
./opencode-loop.sh --max-rounds 5
```

터미널 2:
```bash
./task-tracker.sh
```

**기대 결과:**
- 실시간 진행도 표시
- 라운드별 통계

---

## 🏗️ 아키텍처 구성

### 5개 에이전트

| # | 이름 | 모델 | 역할 | 권한 |
|---|---|---|---|---|
| 1 | **Manager** | Sonnet 4.6 | 전체 오케스트레이션 | Read/Write |
| 2 | **Crawler** | Haiku 4.5 ×3 | 뉴스 수집 (병렬) | Read Only |
| 3 | **Scheduler** | Haiku 4.5 | 다음 라운드 스케줄 | Read/Write schedule |
| 4 | **Summarizer** | Haiku 4.5 | 한국어 200자 요약 | Read Only |
| 5 | **Notifier** | Haiku 4.5 | Slack 발송 | Write slack:// |

### 5 라운드 구성

```
Round 1-5:
├─ Phase 1: Manager - 라운드 계획 수립
├─ Phase 2: Crawlers (HN, Reddit, Arxiv) 병렬 실행
├─ Phase 3: Scheduler - 다음 라운드 결정
├─ Phase 4: Summarizer - 8개 기사 요약 생성
└─ Phase 5: Notifier - Slack 발송 (옵션)
```

---

## 📊 성능 지표

| 지표 | 값 |
|---|---|
| **라운드당 시간** | ~50초 |
| **총 5 라운드** | ~4분 |
| **동시 Crawler** | 3개 (병렬) |
| **수집 뉴스/라운드** | 8건 |
| **요약 생성** | 한국어 200자 |
| **예상 비용/라운드** | $0.40-0.45 |
| **총 예상 비용** | $2-2.25 |

---

## 🔧 고급 옵션

### 1라운드 테스트
```bash
./opencode-loop.sh --max-rounds 1
```

### 더 저렴하게 (Haiku만)
```bash
./opencode-loop.sh --max-rounds 5 --model haiku
```

### 로그 저장
```bash
./opencode-loop.sh --max-rounds 5 2>&1 | tee opencode.log
```

### Slack 연동
```bash
export SLACK_WEBHOOK_URL="https://hooks.slack.com/services/YOUR/WEBHOOK/URL"
./opencode-loop.sh --max-rounds 5
```

### 스케줄 기반 실행 (Cron)
```bash
# 매 시간 1라운드 실행
0 * * * * cd /path/to/practice-5-opencode-agent && ./opencode-loop.sh --max-rounds 1
```

---

## 🎯 완료 신호

모든 5 라운드가 완료되면 `mission.md`에 다음이 추가됩니다:

```markdown
✅ ALL_ROUND_COMPLETED
```

이 신호를 감지하면 `opencode-loop.sh`는 자동으로 종료합니다.

---

## 📈 다음 단계

### 1단계: 구성 검증
```bash
# 드라이 런으로 구성 확인
./opencode-loop.sh --dry-run --max-rounds 1
```

### 2단계: 실행
```bash
# 실제 5 라운드 실행
./opencode-loop.sh --max-rounds 5
```

### 3단계: 결과 확인
```bash
# mission.md에서 완료 확인
tail -20 mission.md | grep "ALL_ROUND_COMPLETED"
```

### 4단계: 개선 (선택)
- Slack webhook URL 설정
- 커스텀 데이터 소스 추가
- 에이전트 프롬프트 수정

---

## 🔍 문제 해결

### 문제: "claude: command not found"
**해결**: Claude CLI가 설치되었는지 확인
```bash
which claude
claude --version
```

### 문제: 스크립트 실행 권한 부족
**해결**: 권한 추가
```bash
chmod +x opencode-loop.sh task-tracker.sh
```

### 문제: Slack 메시지가 발송되지 않음
**해결**: Webhook URL 설정 확인
```bash
export SLACK_WEBHOOK_URL="https://hooks.slack.com/..."
./opencode-loop.sh --max-rounds 1
```

---

## 📚 참고 자료

| 문서 | 용도 |
|---|---|
| **README.md** | 개요 및 빠른 실행 |
| **EXECUTION_GUIDE.md** | 상세한 실행 가이드 |
| **QUICKSTART.md** | 5분 빠른 시작 |
| **CLAUDE.md** | 개념 및 아키텍처 |
| **PROMPT.md** | 에이전트 프롬프트 |

---

## ✨ 핵심 학습 포인트

1. **멀티에이전트 설계** - 역할 분담의 중요성
2. **병렬 처리** - 3배 빠른 실행
3. **권한 분리** - 보안 (Principle of Least Privilege)
4. **비용 최적화** - 싼 모델에 작은 일 할당
5. **상태 추적** - Mission-based 루프로 명확한 종료 신호

---

## 📝 구성 완료 증명

- ✅ 모든 스크립트 존재
- ✅ 모든 문서 준비됨
- ✅ 실행 권한 설정됨
- ✅ 에이전트 구성 완료
- ✅ 라운드 스케줄 설정됨
- ✅ 상태 추적 시스템 구성됨
- ✅ 모니터링 도구 준비됨
- ✅ 종료 신호 메커니즘 구성됨

**🎉 즉시 실행 가능합니다!**

---

생성일: 2026-04-30 14:30 KST

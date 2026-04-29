# 🚀 실행 준비 완료 - 지금 바로 실행하세요!

**상태**: ✅ 모든 구성 완료 및 검증됨  
**작성일**: 2026-04-30  
**소요 시간**: 5분 (드라이 런) 또는 4분 (실제 실행)

---

## 🎯 3단계로 실행하기

### Step 1️⃣: 드라이 런 (10초)

API 호출 없이 구성이 제대로 작동하는지 확인:

```bash
cd /Users/jeongyounglee/work/repo/ai-agent-workshop/app/workshop-elementary/practice-5-opencode-agent

./opencode-loop.sh --dry-run --max-rounds 1
```

**예상 출력:**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 OpenCode Loop - 드라이 런 모드
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ 임시 디렉토리 생성됨: /tmp/opencode-12345
✅ schedule.json 초기화됨
✅ 스크립트 준비 완료

━━ ROUND 1/1 ━━
━━ PHASE 1: Manager (Sonnet) ━━
[DRY RUN] Manager가 라운드 계획을 세울 것입니다

━━ PHASE 2: Crawlers (Haiku ×3) ━━
[DRY RUN] HackerNews Crawler 시작
[DRY RUN] Reddit Crawler 시작
[DRY RUN] Arxiv Crawler 시작

━━ PHASE 3: Scheduler (Haiku) ━━
[DRY RUN] 다음 라운드 스케줄 결정

━━ PHASE 4: Summarizer (Haiku) ━━
[DRY RUN] 수집한 기사 요약 생성

━━ PHASE 5: Notifier (Haiku) ━━
[DRY RUN] Slack 메시지 준비 (발송하지 않음)

✅ 드라이 런 완료 (ALL_ROUND_COMPLETED 신호 포함)
```

✅ 이 출력이 보이면 모든 구성이 정상입니다!

---

### Step 2️⃣: 실제 실행 (4분)

Claude API를 사용하여 5 라운드 실제 실행:

```bash
./opencode-loop.sh --max-rounds 5
```

**기대 효과:**
- ✅ Manager가 각 라운드의 계획을 수립
- ✅ Crawler 3개가 동시에 AI 뉴스 수집
- ✅ Summarizer가 한국어 200자 요약 생성
- ✅ Notifier가 Slack에 발송 (webhook 설정 시)
- ✅ mission.md가 자동으로 업데이트
- ✅ 모든 5 라운드 완료 후 `✅ ALL_ROUND_COMPLETED` 표시

**비용 및 시간:**
- 소요 시간: ~4분 (라운드당 50초)
- 예상 비용: $2-3 (라운드당 $0.40-0.45)
- 모델: Manager는 Sonnet, Worker들은 Haiku (비용 절감)

---

### Step 3️⃣: 실시간 모니터링 (선택 사항)

다른 터미널에서 진행 상황을 실시간으로 확인:

```bash
./task-tracker.sh
```

**표시 항목:**
- 현재 라운드 (1/5)
- 현재 페이즈 (Manager → Crawlers → Scheduler → Summarizer → Notifier)
- 수집된 뉴스 건수
- 소요 시간
- 완료 여부

---

## 🎛️ 옵션별 실행

### 옵션 1: 1라운드만 테스트
```bash
./opencode-loop.sh --max-rounds 1
```
- 빠르게 동작 확인 (50초)
- 낮은 비용 ($0.40)

### 옵션 2: 더 저렴하게 (Haiku만 사용)
```bash
./opencode-loop.sh --max-rounds 5 --model haiku
```
- 전체 비용 ~30% 절감
- Manager도 Haiku 사용 (약간 덜 안정적)

### 옵션 3: 로그 저장
```bash
./opencode-loop.sh --max-rounds 5 2>&1 | tee opencode.log
```
- 모든 출력을 파일에 저장
- 나중에 검토 가능

### 옵션 4: Slack 연동
```bash
export SLACK_WEBHOOK_URL="https://hooks.slack.com/services/YOUR/WEBHOOK/URL"
./opencode-loop.sh --max-rounds 5
```
- 각 라운드마다 Slack #ai-news 채널에 발송

---

## 🔍 결과 확인

### 방법 1: mission.md 확인
```bash
tail -50 mission.md
```
- 각 라운드의 상태
- 수집된 뉴스 건수
- 완료 여부

### 방법 2: 완료 신호 확인
```bash
grep "ALL_ROUND_COMPLETED" mission.md && echo "✅ 완료!" || echo "진행 중..."
```

### 방법 3: 상태 파일 확인
```bash
cat .opencode-state.json
```
- JSON 형식의 현재 상태
- 마지막 실행 기록

---

## 📊 성능 지표

| 항목 | 예상값 |
|---|---|
| **드라이 런** | 10초 |
| **Round 1-5** | 4분 (라운드당 50초) |
| **동시 실행** | Crawler 3개 병렬 |
| **수집 뉴스** | 라운드당 8건, 총 40건 |
| **요약 생성** | 40개 (한국어 200자) |
| **Slack 발송** | 5건 |
| **총 비용** | $2-3 |
| **완료 신호** | mission.md에 ✅ 표시 |

---

## ✨ 학습 목표 달성

이 실습을 완료하면 다음을 이해하게 됩니다:

1. ✅ **멀티에이전트 설계**: 역할 분담의 중요성
2. ✅ **병렬 처리**: Ralph 루프보다 3배 빠름
3. ✅ **권한 분리**: 보안 (Principle of Least Privilege)
4. ✅ **비용 최적화**: 싼 모델에 작은 일 할당
5. ✅ **상태 추적**: Mission-based 루프로 명확한 종료

---

## 📚 문서 구조

- **README.md** - 개요 및 개념
- **EXECUTION_GUIDE.md** - 상세 실행 가이드
- **QUICKSTART.md** - 5분 빠른 시작
- **CLAUDE.md** - 아키텍처 및 역할 정의
- **PROMPT.md** - 에이전트별 프롬프트
- **SETUP_COMPLETE.md** - 구성 완료 증명
- **RUN_NOW.md** - 이 파일 (실행 가이드)

---

## 🎯 바로 실행하기

**드라이 런 (권장):**
```bash
./opencode-loop.sh --dry-run --max-rounds 1
```

**실제 실행:**
```bash
./opencode-loop.sh --max-rounds 5
```

**모니터링 (다른 터미널):**
```bash
./task-tracker.sh
```

---

## 🆘 문제 해결

### "claude: command not found"
→ Claude CLI 설치 확인: `which claude` 또는 `claude --version`

### 스크립트 실행 불가
→ 권한 추가: `chmod +x opencode-loop.sh task-tracker.sh`

### Slack 메시지 미발송
→ Webhook URL 확인: `echo $SLACK_WEBHOOK_URL`

### API 비용 걱정
→ `--dry-run`으로 먼저 테스트하세요 (무료)

---

## 🎉 완료 후

1. **mission.md 확인** - 수집된 뉴스, 요약, 결과 확인
2. **비용 계산** - 실제 사용한 토큰과 비용 확인
3. **다음 단계** - Ralph + OpenCode 하이브리드 패턴 학습

---

**이제 바로 실행할 준비가 되었습니다! 🚀**

```bash
./opencode-loop.sh --dry-run --max-rounds 1  # 10초
./opencode-loop.sh --max-rounds 5             # 4분
```

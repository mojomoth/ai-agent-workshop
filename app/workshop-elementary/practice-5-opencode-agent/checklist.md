# Practice 5 체크리스트

## 세팅
- [ ] OpenCode Go 설치 확인 (`opencode --version`)
- [ ] opencode-config.json 파일 생성
- [ ] CLAUDE.md 읽음

## 멀티에이전트 이해
- [ ] Manager와 Worker의 역할 차이 이해
- [ ] 병렬 실행 개념 이해 (5개 작업 동시 vs 순차)
- [ ] 권한 분리 (write: false) 개념 이해

## 구성 검증
- [ ] opencode-config.json이 유효한 JSON
- [ ] 5개 에이전트 정의됨 (Manager, Crawler, Scheduler, Summarizer, Notifier)
- [ ] 각 에이전트의 model 필드 기입됨
- [ ] 각 에이전트의 permissions 필드 기입됨

## 실행 (데모)
- [ ] `opencode run --config opencode-config.json --agent manager` 실행 시도
- [ ] Manager가 다른 에이전트에게 작업 할당하는지 확인
- [ ] Crawler 병렬 실행 로그 확인 (HN, Reddit, Arxiv 동시)
- [ ] Summarizer가 Crawler 완료 후 시작하는지 확인
- [ ] Notifier가 Summarizer 완료 후 Slack 발송하는지 확인

## 병렬 성능 확인
- [ ] 총 실행 시간 측정 (예상: 1분 미만)
- [ ] 순차 실행이면 ~1분 30초, 병렬이면 ~50초
- [ ] mission.md에 "Round 1 Complete" 기록됨

## 라운드 반복 (선택)
- [ ] 5 라운드 모두 완료 시도 (긴 데모이므로 1-2 라운드면 충분)
- [ ] mission.md가 자동 업데이트되는지 확인

## 권한 분리 검증
- [ ] Crawler: write: false 설정되어 있음 → 읽기만 가능
- [ ] Notifier: endpoints_allowed에 Slack만 있음
- [ ] Summarizer: network: false 설정 → 로컬 텍스트만 처리

## 종료 신호
- [ ] 5 라운드 완료 후 mission.md에 "✅ ALL_ROUND_COMPLETED" 추가
- [ ] OpenCode가 이 신호를 감지하고 종료

## 학습 확인
- [ ] "병렬 실행이 뭔지" 설명할 수 있다
- [ ] "권한 분리가 왜 중요한지" 설명 가능
- [ ] "언제 Ralph 대신 OpenCode를 쓸지" 알겠다 (대규모 반복)
- [ ] "비싼 모델 vs 싼 모델 분담" 개념 이해

## 비용 계산
- [ ] 1 라운드 예상 비용 계산
  - Manager 호출: 1회 × $0.002 = ?
  - Crawler 3개: 3회 × $0.0005 = ?
  - Summarizer: 1회 × $0.0003 = ?
  - Notifier: 1회 × $0.0002 = ?
  - **총 라운드**: ~$0.002
  - **5 라운드**: ~$0.01

## 통과 기준
- ✅ opencode-config.json 생성 완료
- ✅ Manager → Crawler 병렬 작업 할당 확인
- ✅ mission.md 자동 업데이트 확인
- ✅ 멀티에이전트 개념 이해

**이건 데모니까 완벽할 필요 없습니다.**  
개념 이해 + 간단한 실행 확인이면 충분합니다.

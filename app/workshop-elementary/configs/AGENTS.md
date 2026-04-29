# Workshop Elementary - Agent Rules

AI 에이전트 사용 규칙 및 최적화 가이드

## Practice별 권장 에이전트

### Practice 1: Pokemon Card Builder

**권장**:
- **Planner** (시작, Plan Mode)
- **Executor** (구현, Normal Mode)

**패턴**:
```
[Shift+Tab] → Planner (설계만)
[Shift+Tab] → Executor (파일 생성 및 구현)
```

**주의**:
- Plan Mode에서는 Planner만 활용
- 코드 생성은 반드시 Normal Mode에서 Executor 호출

### Practice 2: DESIGN.md Application

**권간**:
- **Vision** (Apple Vision Pro 스크린샷 분석, 선택사항)
- **Designer** (DESIGN.md 토큰 생성)
- **Executor** (CSS 적용)

**패턴**:
```
1. Vision으로 스크린샷 분석 (선택)
2. Designer에게 DESIGN.md 생성 요청
3. Executor가 Pokemon 카드에 적용
```

**주의**:
- Designer는 색/간격/타이포만 정의
- CSS Variable 네이밍은 일관되게
- 토큰 외 색/값을 절대 삽입하지 말 것

### Practice 3: Ralph Harness Loop

**권장**:
- **Ralph** (자동 루프)
- **Architect** (막혔을 때 디버깅)

**패턴**:
```
bash ralph-loop.sh

[자동 반복]
  Claude → 한 기능 추가
  fix_plan.md 갱신
  [다시 반복]

[막히면]
  Architect 호출 → 근본 원인 파악
```

**주의**:
- `--max-iterations 30`으로 비용 제한
- 같은 에러 반복 → 표지판 심기
- fix_plan.md가 완료 신호

### Practice 4: Claude × Codex Loop

**권장**:
- **Claude** (구현)
- **Codex** (검증, MCP 또는 plugin)
- **Security-Reviewer** (보안 검증)

**패턴**:
```
1. Claude: 코드 작성
2. Codex: 리뷰 (보안/성능/에러처리)
3. Claude: 피드백 반영
4. Codex: 재검증
```

**주의**:
- Codex는 선택 도구 (필수 아님)
- 보안 코드는 반드시 검증 거치기
- 루프는 최대 3회까지만

### Practice 5: OpenCode Multi-Agent

**권장**:
- **Manager** (Manager Agent, OpenCode 내)
- **Crawler** (Worker, OpenCode 내)
- **Summarizer** (Worker, OpenCode 내)
- **Notifier** (Worker, OpenCode 내)

**패턴**:
```
opencode run --config opencode-config.json --agent manager

[OpenCode 내부에서 병렬 실행]
  Manager → [Crawler, Summarizer, Notifier]
  
[자동 반복]
  Round 1/5 → Round 2/5 → ... → Round 5/5
  
[종료]
  mission.md에 "✅ ALL_ROUND_COMPLETED" 감지
```

**주의**:
- opencode-config.json 필수
- 각 에이전트 권한 분리 필수 (write: false)
- 병렬 실행이므로 순서 의존 금지

## 에이전트별 사용 시기

### Planner
**사용**: 복잡한 설계가 필요할 때
**언제**: Practice 1 시작, Practice 3 막혔을 때
```
/plan <large feature description>
```

### Architect
**사용**: 시스템 설계, 디버깅
**언제**: 설계 선택이 여러 개일 때, 에러 원인 분석
```
claude → ... → architect (검증)
```

### Executor / Executor-High
**사용**: 실제 코드 작성
**언제**: 모든 코드 변경 시
```
Normal Mode에서 모든 코드 수정 위임
```

### Designer / Designer-High
**사용**: UI/스타일 작업
**언제**: Practice 2 전체, CSS 대규모 변경 시
```
Designer → CSS/디자인 토큰
```

### Security-Reviewer
**사용**: 보안 검증
**언제**: 인증, API, 결제 관련 코드
```
코드 작성 후 반드시 호출
```

### TDD-Guide
**사용**: 테스트 주도 개발
**언제**: 새 기능 추가 시
```
테스트 → 구현 → 테스트 통과
```

### Code-Reviewer
**사용**: 코드 품질 검증
**언제**: 코드 완성 후
```
Executor 완료 → Code-Reviewer → 수정
```

## 모델 선택 전략

| 작업 | 모델 | 이유 |
|---|---|---|
| 설계 | Opus | 깊은 추론 필요 |
| 구현 | Sonnet | 빠르고 정확 |
| 간단 조회 | Haiku | 비용 절감 |
| 검증 | Opus | 신뢰성 필요 |

## 병렬 vs 순차 실행

### 병렬이 좋은 경우
- 2+ 독립적 작업
- 각 작업 > 30초
- 서로 의존성 없음

예:
```
병렬: [Vision 이미지 분석] + [Designer DESIGN.md 생성]
```

### 순차가 좋은 경우
- A → B → C 의존성
- 각 작업 < 10초
- 결과를 받아야 다음 진행

예:
```
순차: [Executor 구현] → [Security-Reviewer 검증] → [Code-Reviewer 최종]
```

## 에러 처리 플로우

```
에러 발생
   ↓
Architect에게 근본 원인 물어보기
   ↓
   ├─ 코드 버그 → Executor 수정
   ├─ 보안 문제 → Security-Reviewer 체크
   ├─ 타입 에러 → Build-Fixer 또는 TSC
   └─ 설계 문제 → Planner 재설계
   ↓
다시 실행
```

## Practice 3 (Ralph)에서 표지판 심기

Claude가 같은 실수 반복:

❌ **나쁜 방법** (매번 프롬프트로 설명)
```
"localStorage를 사용하세요 (sessionStorage 아니게)"
→ 다음 라운드 또 같은 실수
```

✅ **좋은 방법** (코드베이스에 심기)
```javascript
// NOTE: localStorage 사용 (sessionStorage 아님)
// 사용자 선호도는 영구적으로 저장되어야 함
const savePreference = (key, value) => {
  localStorage.setItem(key, value);  // ← 정답
};
```

그러면 Claude가 다음 라운드에 자동 발견.

## 비용 최적화

### Practice 1-2: 최소화
- Planner 1회, Executor 1-2회
- 총 5-10K 토큰

### Practice 3 (Ralph): 제한
```bash
--max-iterations 30  # 비용 상한선 정하기
```

### Practice 4 (Codex): 선택
- 중요한 코드만 검증
- 모든 라운드 검증 X

### Practice 5 (OpenCode): 최적화
- Manager는 비싼 모델 (GLM-5.1)
- Worker는 싼 모델 (Kimi, Qwen, Mimo)
- 총 비용 1/10 절감

## 주의: 에이전트 권한

**이 워크숍에서는:**
- 모든 에이전트가 `app/workshop-elementary/` 내에서만 작업
- 다른 폴더 수정 금지
- 각자 practice 폴더만 담당

**Practice 3 ralph loop에서:**
- 같은 폴더 (practice-3-ralph-harness) 내에서만 반복
- 다른 practice 코드 건드리지 말 것
- fix_plan.md는 반드시 같은 폴더에서만

## 자주 하는 실수

### 1. Plan Mode에서 코드 작성
❌ Plan Mode에서 코드까지 받으면 안 됨
✅ 설계만 받고, Normal Mode에서 Executor 호출

### 2. DESIGN.md 토큰 무시
❌ DESIGN.md 밖의 색/값을 임의로 추가
✅ 부족하면 DESIGN.md 먼저 갱신

### 3. Ralph 루프 무한 반복
❌ --max-iterations 없이 실행
✅ 반드시 상한선 정하기: `--max-iterations 30`

### 4. 다른 practice 폴더 수정
❌ Practice 1 중에 Practice 2 수정
✅ 각자 해당 폴더만 작업

### 5. 에이전트 과다 호출
❌ 모든 작업을 모든 에이전트에게 물어봄
✅ 필요한 에이전트만 선별해서 호출

## 성공 체크리스트

완료 전에 확인:

- [ ] 모든 practice에 CLAUDE.md 읽음
- [ ] Practice 1은 반드시 Plan Mode 거침
- [ ] Practice 2는 DESIGN.md 토큰 일관성 확인
- [ ] Practice 3은 --max-iterations 설정
- [ ] 각자 해당 폴더만 작업 (다른 폴더 X)
- [ ] checklist.md 모두 체크
- [ ] 총 비용 $0.26 내 (또는 계획한 범위)

## 다음 스텝

완료 후:

1. **내 프로젝트에 적용**
   - 내 프로젝트에도 CLAUDE.md 추가
   - DESIGN.md 작성
   - Ralph 루프 구성

2. **MCP 연동**
   - GitHub MCP
   - Figma MCP
   - 커스텀 MCP

3. **프로덕션화**
   - CI/CD 통합
   - 자동 검증
   - 비용 최적화

좋은 실습 되세요! 🚀

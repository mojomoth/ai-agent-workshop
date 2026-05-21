# Workshop Elementary - Project Context

## 목표

이 워크숍은 **Claude Code / Codex / OpenCode**를 순차적으로 학습하는 5가지 실습입니다.
각 실습은 점진적으로 복잡도를 높여 멀티에이전트 자동화까지 도달합니다.

```
Practice 1 (20분) ← Plan + Build (기본)
   ↓
Practice 2 (10분) ← DESIGN.md (톤 일관성)
   ↓
Practice 3 (20분) ← Ralph Loop (자동화 기본)
   ↓
Practice 4 (5분) ← Codex 검증 (데모)
   ↓
Practice 5 (5분) ← OpenCode 멀티에이전트 (데모)
```

## 전체 구조

```
app/workshop-elementary/
├── README.md                    ← 시작 가이드 (60분 개요)
├── SETUP.md                     ← 환경 설정
├── configs/
│   ├── CLAUDE.md               ← 프로젝트 컨텍스트 (이 파일)
│   ├── AGENTS.md               ← 에이전트 규칙
│   ├── DESIGN.md               ← 디자인 토큰 기본
│   └── opencode-config.json    ← OpenCode 설정
├── scripts/
│   ├── setup.sh                ← 전체 환경 셋업
│   ├── ralph-loop.sh           ← Ralph 루프 실행
│   ├── codex-setup.sh          ← Codex 설정
│   └── opencode-setup.sh       ← OpenCode 설정
└── practice-{1..5}/
    ├── README.md
    ├── PROMPT.md
    ├── CLAUDE.md
    └── checklist.md
```

## 각 실습의 역할

### Practice 1: Pokemon Card (20분)
**주제**: Plan Mode + Build + CSS 효과

- PokeAPI 데이터 조회
- 홀로그램 카드 효과 (CSS mix-blend-mode)
- Glassmorphism 컨테이너

**배우는 것**:
- Plan Mode로 먼저 설계받기
- CLAUDE.md로 컨텍스트 제공하기
- 외부 API 통합하기

### Practice 2: DESIGN.md (10분)
**주제**: 디자인 토큰 시스템

- Apple Vision Pro 톤 분석
- CSS Variable로 토큰화
- 일관된 톤 유지

**배우는 것**:
- "AI made-it" 티 제거하기
- 토큰 기반 설계의 중요성
- 같은 페이지를 다른 톤으로 표현

### Practice 3: Ralph Loop (20분)
**주제**: 자동화 기본 패턴

- Bash while 루프
- 같은 프롬프트 반복 실행
- 진행도 추적 (fix_plan.md)
- 명확한 종료 신호

**배우는 것**:
- 반복 자동화의 개념
- 토큰/비용 추적
- "표지판" 패턴 (에러 반복 시 코드베이스에 힌트 심기)

### Practice 4: Claude × Codex (5분, 데모)
**주제**: 멀티모델 검증

- Claude 구현 → Codex 리뷰 → Claude 수정 → 반복
- Sycophancy 문제 해결
- Review Gate 패턴

**배우는 것**:
- 다른 모델의 관점 가치
- 자동 검증 루프
- 보안/성능 이슈 조기 발견

### Practice 5: OpenCode (5분, 데모)
**주제**: 멀티에이전트 오케스트레이션

- Manager + Worker 역할 분담
- 병렬 실행으로 속도 단축
- 권한 분리 (write: false)
- 비용 최적화

**배우는 것**:
- 대규모 자동화 패턴
- 에이전트 역할 설계
- 비용 절감 전략

## 실습 규칙

### 모든 실습에서

1. **CLAUDE.md 우선**
   - 각 practice 폴더의 CLAUDE.md를 먼저 읽기
   - 컨텍스트가 코드보다 중요

2. **Plan Mode 활용**
   - Practice 1은 반드시 Plan Mode로 시작
   - 설계 → 구현 두 단계 분리

3. **체크리스트 확인**
   - checklist.md로 진행도 추적
   - 각 단계마다 확인 표시

4. **비용 의식**
   - Practice 3 이상에서 API 호출 비용 추적
   - --max-iterations로 반복 제한

### 금지 사항

- ❌ PROMPT.md 수정하면서 실습 진행 (템플릿이니까)
- ❌ 코드베이스 없이 막힌 에러 반복 (표지판 심기)
- ❌ 각 practice 폴더 밖에서 코드 수정

## 토큰/비용 예상

| Practice | 모드 | 예상 토큰 | 예상 비용 |
|---|---|---|---|
| 1 | Plan + Build | 2K + 4K | $0.03 |
| 2 | Build | 3K | $0.01 |
| 3 (Ralph) | 반복 (15회) | 50K | $0.15 |
| 4 (Codex) | 검증 (3회) | 20K | $0.05 |
| 5 (OpenCode) | 병렬 (5회) | 15K | $0.02 |
| **총합** | | **~94K** | **~$0.26** |

비용은 프롬프트 길이와 모델에 따라 다릅니다.

## 다음 단계 로드맵

### Week 1: 기초 다지기
- ✅ 이 워크숍 (5가지 실습)
- 모든 프로젝트에 CLAUDE.md 추가
- 모든 프로젝트에 DESIGN.md 추가

### Week 2: MCP 연동
- GitHub MCP 추가
- Figma MCP 추가
- 로컬 MCP 1개 직접 작성

### Week 3+: 프로덕션 패턴
- Ralph 루프를 CI/CD에 통합
- Codex 검증을 PR 체크에 통합
- OpenCode로 대규모 배치 작업 자동화

## 핵심 철학

> **"AI랑 일하는 건 주니어랑 일하는 것과 같다."**

좋은 컨벤션 문서 (CLAUDE.md, DESIGN.md) + 명확한 기준 (checklist.md) + 끈질긴 반복 (Ralph 루프) = 일이 굴러간다.

## 주요 개념 정리

| 개념 | 의미 | 사용처 |
|---|---|---|
| **CLAUDE.md** | 프로젝트 컨텍스트 | 모든 실습 |
| **DESIGN.md** | 토큰 시스템 | Practice 2+ |
| **Ralph Loop** | 반복 자동화 (같은 프롬프트) | Practice 3 |
| **Codex 검증** | 다른 모델로 리뷰 | Practice 4 |
| **OpenCode** | 멀티에이전트 (역할 분담) | Practice 5 |
| **Plan Mode** | 설계 우선 | 모든 큰 작업 |
| **표지판** | 에러 반복 시 코드에 힌트 심기 | 자동화 중 |

## 문제 해결

### "Claude가 같은 실수를 반복해"
→ 코드베이스에 "표지판" 추가
예: `// BUG: localStorage가 아니라 sessionStorage 사용 금지`

### "비용이 너무 높아"
→ `--max-iterations`로 제한하거나 OpenCode Go로 싼 모델 사용

### "Plan Mode 진입이 안 돼"
→ `[Shift+Tab]` 키보드 단축키 확인 또는 `/plan` 커맨드 명시

### "DESIGN.md 적용이 안 돼"
→ CLAUDE.md에 "DESIGN.md를 단일 진실의 소스로 본다" 한 줄 추가

## 참고 자료

**공식 문서**
- Claude Code: https://claude.com/claude-code
- OpenCode: https://opencode.ai
- PokeAPI: https://pokeapi.co

**레퍼런스**
- Pokemon CSS: https://github.com/simeydotme/pokemon-cards-css
- Glassmorphism: https://glass3d.dev
- Ralph Pattern: Geoffrey Huntley의 "Deterministically bad" 논문

## 피드백

각 practice 폴더의 README.md 맨 아래 피드백 받는 곳이 있습니다.
실습하면서 발견한 에러나 개선 사항을 공유해주세요!

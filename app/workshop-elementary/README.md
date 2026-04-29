# 🛠️ AI 에이전트 워크숍 - 실습형 가이드

**Claude Code · Codex · OpenCode** 세 가지 AI 에이전트를 동시에 다루는 60분 집중 워크숍입니다.

## 📋 실습 5종 한눈에

| # | 주제 | 시간 | 난이도 | 산출물 |
|---|---|---|---|---|
| 1 | 포켓몬 카드 만들기 (PokeAPI + 홀로 효과) | 20분 | ⭐ | 동적 웹 페이지 |
| 2 | DESIGN.md로 디자인 훔치기 | 10분 | ⭐ | 디자인 토큰 시스템 |
| 3 | Ralph & Harness 기본 구축 | 20분 | ⭐⭐ | 자동 반복 루프 |
| 4 | Claude × Codex 검증 (데모) | 5분 | ⭐⭐ | 멀티모델 워크플로우 |
| 5 | OpenCode 멀티에이전트 크롤러 (데모) | 5분 | ⭐⭐⭐ | 멀티에이전트 시스템 |

> **1~3 직접 따라하기 / 4~5 시연으로 감 잡기**

---

## 🎯 학습 목표

이 워크숍을 마치면 다음을 할 수 있습니다:

- ✅ **CLAUDE.md** 작성해서 AI한테 컨텍스트 주기
- ✅ **DESIGN.md** 작성해서 일관된 스타일 유지하기
- ✅ **Ralph 루프** 직접 짜서 자동 반복 실행하기
- ✅ **멀티모델 워크플로우** 설계 (Claude → Codex → OpenCode)
- ✅ **멀티에이전트 시스템** 아키텍처 이해하기

핵심 원리 3가지:
1. **컨텍스트가 코드보다 먼저다** (CLAUDE.md)
2. **모델은 역할별로 나눠 쓴다** (구현 vs 검증)
3. **루프가 새로운 작업 단위다** (Ralph = while true)

---

## 📦 준비 사항

### 체크리스트
```bash
# 설치 확인
claude --version      # Claude Code CLI
codex --version       # (선택) Codex 설치 여부
opencode --version    # (선택) OpenCode 설치 여부

# 새 작업 폴더 하나
mkdir vibe-day && cd vibe-day
```

### 필요한 것
- Claude Code CLI 설치 (필수)
- 인터넷 연결
- 텍스트 에디터 (VS Code 권장)
- 호기심 한 줌 ☕

### 예상 비용
- Claude 기준: **$1~3** (전체 실습)
- Codex/OpenCode: 추가 선택사항

---

## 🚀 시작하기

### 1단계: 환경 설정 (5분)

```bash
cd /path/to/ai-agent-workshop/app/workshop-elementary
bash scripts/setup.sh
```

이것이 다음을 자동으로 합니다:
- Node.js 환경 확인
- pip 패키지 설치
- git 저장소 초기화
- 기본 CLAUDE.md 생성

### 2단계: 첫 번째 실습 시작 (20분)

```bash
cd practice-1-pokemon-card
cat README.md              # 실습 개요 읽기
cat PROMPT.md              # 시작 프롬프트 확인
```

PROMPT.md의 내용을 Claude Code에 복사해서 붙이고 실행하면 됩니다.

### 3단계: 다음 실습으로 진행 (계속)

```bash
cd ../practice-2-design-md
# 같은 방식으로 진행...
```

---

## 📚 각 실습 상세

### 실습 1: 포켓몬 카드 만들기 (20분)

**목표**: PokeAPI 데이터 → 홀로그램 카드 이펙트 → 글래스모피즘 컨테이너

**배울 것**:
- CLAUDE.md로 컨텍스트 설정하기
- Plan 모드로 설계와 구현 분리하기
- 외부 레퍼런스(URL, 코드)를 효과적으로 제시하기

**시간 분배**:
- 설정 및 이해: 5분
- Claude와 대화: 10분
- 결과 확인 및 개선: 5분

→ [실습 1 상세](./practice-1-pokemon-card/README.md)

---

### 실습 2: DESIGN.md로 디자인 훔치기 (10분)

**목표**: 참조 페이지(예: Apple Vision Pro)의 디자인 톤을 DESIGN.md로 추출하고 적용

**배울 것**:
- 디자인 토큰 시스템 만들기
- CSS 변수로 일관성 유지하기
- AI한테 토큰만 주고 자유도 제한하기

**시간 분배**:
- DESIGN.md 생성: 5분
- 적용 및 검증: 5분

→ [실습 2 상세](./practice-2-design-md/README.md)

---

### 실습 3: Ralph & Harness 기본 구축 (20분)

**목표**: bash 루프로 같은 프롬프트를 반복 실행해서 점진적 개선 자동화

**배울 것**:
- Ralph 패턴의 원리와 구현
- 종료 조건과 최대 반복수 설정
- Bash로 간단한 하네스 짜기

**시간 분배**:
- 원리 이해: 3분
- ralph.sh 작성: 5분
- 실행 및 모니터링: 12분

→ [실습 3 상세](./practice-3-ralph-harness/README.md)

---

### 실습 4: Claude × Codex 검증 루프 (5분, 데모)

**목표**: Claude 구현 → Codex 리뷰 → Claude 수정 (자동 루프)

**배울 것**:
- 멀티모델 워크플로우 설계
- 검증 게이트(Review Gate) 개념
- Sycophancy 줄이기

→ [실습 4 상세](./practice-4-claude-codex/README.md)

---

### 실습 5: OpenCode 멀티에이전트 크롤러 (5분, 데모)

**목표**: 5명의 에이전트가 협력해서 뉴스 크롤링 → 요약 → 발송 자동화

**배울 것**:
- 역할별 에이전트 분담
- 싼 오픈 모델로 비용 절감
- 무한 루프의 안전한 설계

→ [실습 5 상세](./practice-5-opencode-agent/README.md)

---

## 🔄 전체 진행 흐름

```
0:00 ~ 0:05  |  환경 설정 + 개요 설명
0:05 ~ 0:25  |  [실습 1] 포켓몬 카드 (직접 실행)
0:25 ~ 0:35  |  [실습 2] DESIGN.md (직접 실행)
0:35 ~ 0:55  |  [실습 3] Ralph & Harness (직접 실행)
0:55 ~ 1:00  |  [실습 4-5] 데모 (시연)
```

---

## 💡 핵심 패턴 3가지

### 1️⃣ CLAUDE.md: 컨텍스트가 코드보다 먼저다

```markdown
# Project Name

## API Reference
- URL: ...
- Parameters: ...

## Visual Reference
- Colors: ...
- Typography: ...

## Rules
- Rule 1: ...
- Rule 2: ...
```

**효과**: AI가 추측하지 않고 정해진 틀 안에서만 놀게 된다.

### 2️⃣ DESIGN.md: 토큰으로 일관성 유지

```css
:root {
  --color-primary: #007AFF;
  --spacing-base: 1rem;
  --font-family-display: "SF Pro Display";
}
```

**효과**: 매번 다른 스타일을 만드는 대신 일관된 톤 유지.

### 3️⃣ Ralph 루프: 반복이 거대한 작업 단위

```bash
while true; do
  claude -p "$(cat PROMPT.md)"
  grep -q "DONE" .status && break
done
```

**효과**: "더 해줘"를 자동화해서 점진적 완성 달성.

---

## 📖 참고 자료

### Claude Code
- [공식 가이드](https://code.claude.com/docs)
- [베스트 프랙티스](https://code.claude.com/docs/en/best-practices)

### 외부 레퍼런스
- PokeAPI: https://pokeapi.co
- 홀로 카드 효과: https://github.com/simeydotme/pokemon-cards-css
- 글래스 디자인: https://glass3d.dev

### Ralph & Harness
- Geoffrey Huntley: "Ralph is a Bash loop"
- 사례: 포켓몬 카드에 기능 추가 반복

---

## ❓ FAQ

**Q: 실습을 한 번에 다 해야 하나요?**  
A: 아니요. 1~3은 필수, 4~5는 감 잡기 용도입니다. 시간이 부족하면 데모만 봐도 됩니다.

**Q: Codex/OpenCode가 없어도 되나요?**  
A: 네. 실습 1~3은 Claude Code만으로 가능합니다. 4~5는 시연이므로 봐도 됩니다.

**Q: 비용이 얼마나 드나요?**  
A: Claude 기준 $1~3 정도. 각 실습마다 2~5번 정도의 API 호출입니다.

**Q: 오류가 나면 어떻게 하나요?**  
A: 각 실습 폴더의 `checklist.md`를 참고해서 문제 구간을 찾고, README를 다시 읽으세요.

**Q: 이후에 뭘 배우면 좋나요?**  
A: "입문 다음 단계" 섹션을 참고하세요.

---

## 🎓 입문 다음 단계 로드맵

| 단계 | 할 일 | 기간 |
|---|---|---|
| **Lv 1** | 모든 프로젝트에 CLAUDE.md 추가 | 이번 주 |
| **Lv 2** | DESIGN.md로 톤 통일 | 다음 주 |
| **Lv 3** | MCP 1~2개 붙이기 (Figma, GitHub) | 그 다음 |
| **Lv 4** | bash Ralph 직접 짜보기 | 그 다음 |
| **Lv 5** | OpenCode Go로 비용 절감 | 그 다음 |
| **Lv 6** | Codex 검증 루프 / 멀티에이전트 | 그 다음 |

> 한 번에 다 하지 마세요. **한 단계씩.**

---

## 🎯 최종 테이크어웨이

> **"AI랑 일하는 건 주니어랑 일하는 것과 같다."**
>
> 좋은 컨벤션 문서 + 명확한 기준 + 끈질긴 반복  
> 이 셋이 있으면 결국 일이 굴러갑니다.

**시작**: `CLAUDE.md` + `DESIGN.md` + `Ralph 루프` 부터.

---

## 📝 라이센스 & 저작권

이 워크숍 자료는 [AI Agent Workshop](https://github.com/your-username/ai-agent-workshop) 리포지토리의 일부입니다.

자유롭게 복사, 수정, 배포하세요. (학습용 이상)

---

**마지막 업데이트**: 2026-04-30  
**작성자**: AI Agent Workshop Contributors  
**버전**: 1.0.0

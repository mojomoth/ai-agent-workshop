# 실습 2: DESIGN.md로 디자인 훔치기

**목표**: 참조 페이지의 디자인 톤을 DESIGN.md로 추출하고, 이를 기반으로 기존 포켓몬 카드를 리디자인

**소요 시간**: 10분  
**난이도**: ⭐ (입문)  
**필수 도구**: Claude Code

---

## 📖 개요

이 실습에서는:

1. **Apple Vision Pro** 같은 참조 페이지에서 디자인 톤을 분석
2. **DESIGN.md** 파일로 색상, 타이포, 간격을 정의
3. **CSS Variables**로 AI에게 제약을 주기
4. 기존 포켓몬 카드 페이지를 새로운 톤으로 전환

---

## 🎯 핵심 개념

### "AI 만든 티"를 없애는 방법

```
❌ 나쁜 방법: "애플스럽게 다시 만들어줘"
→ 매번 다른 색상, 다른 간격, 일관성 없음

✅ 좋은 방법: DESIGN.md 토큰을 정의하고 "토큰만 써줘"
→ 일관성 있고, 디자인된 것처럼 보임
```

### DESIGN.md의 역할

```md
# Design System

## Colors
--color-primary: #007AFF (시스템 블루)
--color-surface: #F2F2F7 (밝은 배경)
--color-text: #000 (검정 텍스트)

## Typography
--font-display: "SF Pro Display"
--font-size-hero: 3.5rem

## Spacing
--space-sm: 0.5rem
--space-md: 1rem
--space-lg: 2rem
```

AI는 이 토큰만 사용해야 하고, 없는 값을 임의로 만들 수 없습니다.

---

## 🚀 실습 순서

### Step 1: DESIGN.md 생성 (5분)

PROMPT.md에서 Claude에게 요청:

```
> https://www.apple.com/vision-pro 페이지 톤을
DESIGN.md 형식으로 정리해줘.
색/타이포/간격/그림자/모션 포함.
```

Claude가 다음 같은 DESIGN.md를 만듭니다:

```md
# Apple Vision Pro Design System

## Color Palette
--color-bg-dark: #000000
--color-bg-light: #F5F5F7
--color-accent: #FF9500
--color-text-primary: #FFFFFF
--color-text-secondary: rgba(255, 255, 255, 0.7)

## Typography
--font-family: -apple-system, BlinkMacSystemFont, "Segoe UI"
--font-size-hero: clamp(2.5rem, 8vw, 5rem)
--font-size-heading: 2rem
--font-size-body: 1rem

## Spacing
--space-hero: clamp(4rem, 8vw, 10rem)
--space-section: clamp(2rem, 5vw, 6rem)
--space-component: 1.5rem

## Effects
--shadow-depth: 0 20px 40px rgba(0, 0, 0, 0.3)
--blur-glass: 20px
```

### Step 2: 포켓몬 카드에 적용 (5분)

```
> practice-1 폴더의 파일들을 DESIGN.md 톤으로 다시 그려줘.

규칙:
1. var(--token-name) 형식으로 CSS 변수만 사용
2. 토큰에 없는 색/간격을 절대 만들지 마
3. 부족하면 DESIGN.md 갱신을 먼저 제안
4. 변경 전후 차이를 요약해줘
```

Claude가 제공한 DESIGN.md 토큰만 사용해서 CSS와 HTML을 수정합니다.

### Step 3: 결과 비교 (테스트)

생성된 파일들을 브라우저에서 확인:
- 색상이 Apple 톤과 유사한가?
- 간격이 일관성 있는가?
- 타이포가 깔끔한가?

---

## 📚 DESIGN.md 구조

### 필수 섹션

```md
# Design System (프로젝트명)

## Color Palette
--color-*: value

## Typography
--font-family: value
--font-size-*: value
--line-height: value

## Spacing
--space-*: value

## Effects
--shadow-*: value
--blur-*: value
--radius-*: value

## Animation
--duration-*: value
--easing-*: cubic-bezier(...)
```

### 예제

```md
# Pokémon Card Redesign

## Colors (Apple Vision Pro Inspired)
--color-bg-primary: #000000
--color-bg-secondary: #1C1C1E
--color-text-primary: #FFFFFF
--color-text-secondary: rgba(255, 255, 255, 0.6)
--color-accent-orange: #FF9500

## Typography
--font-family-system: -apple-system, "SF Pro Display"
--font-size-hero: 3rem
--font-size-card-title: 1.25rem
--font-size-body: 0.875rem

## Spacing
--space-xs: 0.25rem
--space-sm: 0.5rem
--space-md: 1rem
--space-lg: 2rem
--space-hero: 4rem

## Effects
--shadow-card: 0 8px 24px rgba(0, 0, 0, 0.4)
--shadow-hover: 0 12px 32px rgba(255, 149, 0, 0.3)
--blur-glass: 16px
--radius-card: 12px
--radius-badge: 6px

## Animation
--duration-fast: 150ms
--duration-normal: 300ms
--easing-out-cubic: cubic-bezier(0.33, 1, 0.68, 1)
```

---

## 💡 핵심 팁

### Tip 1: 토큰 설정은 치밀하게

```css
/* ❌ 나쁜 예 */
color: #FF9500;  /* 임의의 값 */

/* ✅ 좋은 예 */
color: var(--color-accent-orange);  /* 토큰 사용 */
```

### Tip 2: 부족한 토큰은 먼저 DESIGN.md에 추가

Claude가 구현 중에 "이 색상이 없는데요"라고 하면:
→ DESIGN.md에 먼저 추가 후 구현

### Tip 3: 한국어 코멘트 + 영어 토큰명

```md
# 카드 색상 (Card Colors)
--card-bg: #1C1C1E        # 어두운 배경
--card-border: rgba(...) # 은은한 테두리
```

AI가 의도를 이해하기 쉬워집니다.

---

## 🔄 워크플로우

```
1. 참조 페이지 분석 (Apple, Figma 디자인 등)
   ↓
2. DESIGN.md 생성 (색상, 타이포, 간격)
   ↓
3. Claude에게 DESIGN.md 적용 요청
   ↓
4. CSS Variables로 모든 값 대체
   ↓
5. 브라우저 확인 & 미세 조정
   ↓
6. 다음 프로젝트에 재사용
```

---

## 📖 참고 자료

| 자료 | 설명 |
|---|---|
| [Apple Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/) | 시스템 색상, 타이포 기준 |
| [glass3d.dev](https://glass3d.dev) | 글래스 효과 토큰 생성기 |
| [Figma Design System](https://www.figma.com/) | 디자인 토큰 정의 도구 |
| [CSS Variables](https://developer.mozilla.org/en-US/docs/Web/CSS/--*) | CSS 토큰 문법 |

---

## ⏱️ 시간 분배

| 단계 | 시간 |
|---|---|
| DESIGN.md 생성 요청 | 2분 |
| Claude 응답 대기 | 2분 |
| DESIGN.md 검토 | 1분 |
| CSS 적용 요청 | 2분 |
| 결과 확인 | 2분 |
| **합계** | **10분** |

---

## 🎯 완성도 체크

- [ ] DESIGN.md가 생성됐다
- [ ] 색상 토큰이 최소 5개 이상 있다
- [ ] 타이포 토큰이 있다
- [ ] 간격 토큰이 있다
- [ ] 포켓몬 카드 페이지가 새로운 톤으로 변환됐다
- [ ] CSS에서 `var(--token)` 형식만 사용된다
- [ ] 硬编码된 색상이 없다

---

## 📝 배운 점

이 실습을 마치면:

✅ **토큰의 위력** 이해  
- 토큰이 없으면 AI가 매번 다른 값을 만든다
- 토큰이 있으면 일관성이 생긴다

✅ **AI의 제약 활용** 학습  
- "자유도를 무한히 주지 마"
- 토큰 안에서만 놀게 하기

✅ **DESIGN.md 작성법** 체득  
- 어떻게 정의하느냐가 결과를 좌우한다
- 치밀한 토큰 = 좋은 디자인

---

## ➡️ 다음 단계

→ [실습 3: Ralph & Harness 기본 구축](../practice-3-ralph-harness/README.md)

이제 자동 반복 루프를 만들어서 점진적 개선을 자동화합니다.

---

**준비가 되셨으면 PROMPT.md를 열고 시작하세요!** 🎨

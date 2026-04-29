# Design System - Workshop Elementary

최소한의 디자인 토큰으로 일관된 톤을 유지하는 기본 시스템

## 색상 (Colors)

### Primary (포켓몬 카드 용)
```
--color-surface-light: #f8f9fa    /* 밝은 배경 */
--color-surface-dark: #1a1a1a     /* 어두운 배경 */
--color-text-primary: #0f0f0f     /* 주 텍스트 */
--color-text-secondary: #666666   /* 보조 텍스트 */

--color-accent-blue: #3b82f6      /* 파이썬, 물 타입 */
--color-accent-red: #ef4444       /* 불, 드래곤 타입 */
--color-accent-green: #10b981     /* 풀 타입 */
--color-accent-yellow: #fbbf24    /* 전기 타입 */
--color-accent-purple: #a855f7    /* 에스퍼 타입 */
```

### Glassmorphism (투명도)
```
--glass-bg: rgba(255, 255, 255, 0.08)
--glass-border: rgba(255, 255, 255, 0.12)
--glass-shadow: 0 4px 30px rgba(0, 0, 0, 0.25)
--glass-backdrop: blur(16px)
```

## 타이포그래피 (Typography)

### 글꼴
```
--font-display: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto
--font-body: 'Inter', -apple-system, sans-serif
--font-mono: 'Monaco', 'Courier New', monospace
```

### 크기
```
--text-xs: 0.75rem    /* 12px */
--text-sm: 0.875rem   /* 14px */
--text-base: 1rem     /* 16px - 기본 */
--text-lg: 1.125rem   /* 18px */
--text-xl: 1.25rem    /* 20px */
--text-2xl: 1.5rem    /* 24px */

--text-hero: clamp(2rem, 1rem + 5vw, 4rem)  /* 반응형 */
```

### 굵기
```
--weight-normal: 400
--weight-medium: 500
--weight-semibold: 600
--weight-bold: 700
```

## 간격 (Spacing)

### 기본 단위 (8px 기반)
```
--space-xs: 0.5rem    /* 4px */
--space-sm: 0.75rem   /* 6px */
--space-1: 1rem       /* 8px */
--space-2: 1.5rem     /* 12px */
--space-3: 2rem       /* 16px - 표준 */
--space-4: 2.5rem     /* 20px */
--space-5: 3rem       /* 24px */
--space-6: 4rem       /* 32px */

--space-section: clamp(3rem, 2rem + 5vw, 8rem)  /* 섹션 간격 */
```

## 모서리 (Border Radius)

```
--radius-sm: 4px
--radius-md: 8px
--radius-lg: 12px
--radius-xl: 16px
--radius-2xl: 24px    /* 카드 기본값 */
--radius-full: 9999px /* 원형 */
```

## 그림자 (Shadows)

### 깊이
```
--shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05)
--shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1)
--shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1)
--shadow-xl: 0 20px 25px -5px rgba(0, 0, 0, 0.1)
--shadow-2xl: 0 25px 50px -12px rgba(0, 0, 0, 0.25)
```

### 홀로그래픽 효과 (Practice 1)
```
--shadow-holo: 
  0 0 20px rgba(255, 255, 255, 0.3),
  inset 0 0 20px rgba(0, 0, 0, 0.2)
```

## 애니메이션 (Animation)

### 타이밍
```
--duration-fast: 150ms
--duration-normal: 300ms
--duration-slow: 500ms
--duration-slower: 800ms

--ease-in: cubic-bezier(0.4, 0, 1, 1)
--ease-out: cubic-bezier(0, 0, 0.2, 1)
--ease-in-out: cubic-bezier(0.4, 0, 0.2, 1)
--ease-bounce: cubic-bezier(0.68, -0.55, 0.265, 1.55)
```

## Blend Modes (카드 효과)

Practice 1 포켓몬 카드 홀로 효과:

```
--blend-holo: color-dodge        /* 밝은 부분 강조 */
--blend-shadow: multiply         /* 어두운 부분 강화 */
--blend-glass: soft-light        /* 부드러운 효과 */
```

사용 예:
```css
.card__holo {
  background-blend-mode: var(--blend-holo);
  mix-blend-mode: var(--blend-holo);
  filter: brightness(1.1) contrast(2.5);
}
```

## CSS 적용 예시

### 기본 구조
```html
<style>
  :root {
    --color-surface-light: #f8f9fa;
    --text-base: 1rem;
    --space-3: 2rem;
    --radius-2xl: 24px;
  }

  body {
    background-color: var(--color-surface-light);
    font-family: var(--font-body);
    font-size: var(--text-base);
  }

  .card {
    padding: var(--space-3);
    border-radius: var(--radius-2xl);
    box-shadow: var(--shadow-lg);
    background: var(--glass-bg);
    backdrop-filter: var(--glass-backdrop);
  }

  .hero {
    font-size: var(--text-hero);
    font-weight: var(--weight-bold);
    margin-bottom: var(--space-section);
  }
</style>
```

## 토큰 명명 규칙

```
--{category}-{scale}-{modifier}

category: color, text, space, radius, shadow, duration, ease
scale: xs, sm, base/1, lg, xl, 2xl (보통)
modifier: 선택사항 (light, dark, holo 등)

예:
--color-accent-blue       ← 색상
--text-2xl               ← 텍스트 크기
--space-3                ← 간격
--radius-2xl             ← 모서리
--shadow-lg              ← 그림자
--duration-normal        ← 애니메이션
```

## 다크모드 추가 (선택)

```css
@media (prefers-color-scheme: dark) {
  :root {
    --color-surface-light: #1a1a1a;
    --color-surface-dark: #f8f9fa;
    --color-text-primary: #f0f0f0;
    --color-text-secondary: #a0a0a0;
    --glass-bg: rgba(30, 30, 30, 0.08);
    --glass-border: rgba(255, 255, 255, 0.08);
  }
}
```

## 반응형 설정

```css
/* 모바일 우선 */
:root {
  --text-hero: 2rem;
  --space-section: 3rem;
}

/* 태블릿 */
@media (min-width: 768px) {
  :root {
    --text-hero: 3rem;
    --space-section: 5rem;
  }
}

/* 데스크톱 */
@media (min-width: 1024px) {
  :root {
    --text-hero: 4rem;
    --space-section: 8rem;
  }
}
```

## Practice별 확장

### Practice 1: 포켓몬 카드
추가 토큰:
```
--type-normal: #a8a878
--type-fighting: #c03028
--type-flying: #a890f0
... (18가지 타입별 색상)
```

### Practice 2: Vision Pro 스타일
기본 토큰 유지하고 색상만 변경:
```
--color-accent-blue: #0071e3    /* Apple 블루 */
--color-accent-gray: #86868b    /* Apple 그레이 */
--radius-2xl: 20px              /* Apple 라운드 */
```

### Practice 3-5: 공유
모든 practice이 같은 토큰 사용 가능

## 검증 체크리스트

토큰을 적용할 때 확인:

- [ ] 모든 색상은 `--color-*` 변수 사용
- [ ] 모든 간격은 `--space-*` 변수 사용
- [ ] 모든 텍스트 크기는 `--text-*` 변수 사용
- [ ] 하드코딩된 px 값 없음
- [ ] 토큰 외 색/값 추가 X
- [ ] 브라우저 개발자도구에서 CSS 변수 확인 가능

## 참고

이 DESIGN.md는 **최소 토큰 시스템**입니다.
더 자세한 디자인 시스템은 Practice 2에서 작성합니다.

> DESIGN.md의 목적:
> "AI가 토큰 밖의 색/값을 임의로 만드는 것" 방지
> = 일관된 톤 유지

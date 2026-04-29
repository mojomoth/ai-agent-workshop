# 🆘 DESIGN.md Troubleshooting

DESIGN.md 작성 및 적용 중 발생하는 문제들과 해결책

---

## 📍 DESIGN.md 작성

### Issue: 색상 값이 일관성 없음
**증상**: DESIGN.md에 "밝은 파랑", "#5699FF", "#007AFF" 등 같은 색이 여러 이름으로 존재

**원인**: 색상 정리 없이 아무렇게나 추가

**해결책**:
```markdown
# 나쁜 예
--color-primary: #007AFF
--color-accent: #0051D5
--color-blue: #5699FF

# 좋은 예
--color-primary: #007AFF
--color-primary-dark: #0051D5
--color-primary-light: #E5F0FF
--color-secondary: #5AC8FA
--color-secondary-dark: #007AFF (중복 제거!)
```

**확인**: 색상당 정확히 1개의 토큰만 있어야 함

### Issue: 폰트 이름을 잘못 작성
**증상**: CSS에서 폰트가 적용 안 됨 (Arial 같은 기본 폰트로 폴백)

**원인**: 폰트 이름 오타 또는 존재하지 않는 폰트

**해결책**:
```markdown
# 정확한 폰트명 확인
# 참조 페이지 F12 → font-family 확인

# 올바른 형식
--font-family: "SF Pro Display", -apple-system, "Segoe UI", sans-serif;
# ↑ 따옴표 필수
# ↑ 폴백 폰트 반드시 포함
```

**실제 확인**:
```bash
# 브라우저에서 폰트 사용 가능한지 확인
# F12 → Elements → 텍스트 요소 선택
# Styles 탭에서 font-family 행 확인
# 체크 표시 있으면 적용됨, 없으면 폴백 사용 중
```

### Issue: 간격 값이 불규칙
**증상**: DESIGN.md에 "8px", "12px", "16px", "20px", "24px" 등 규칙 없는 값들

**원인**: 토큰화되지 않은 값 나열

**해결책**:
```markdown
# 나쁜 예
8, 12, 16, 20, 24, 28, 32 (불규칙)

# 좋은 예 (0.5rem 배수)
--space-xs: 0.5rem   (8px)
--space-sm: 1rem     (16px)
--space-md: 1.5rem   (24px)
--space-lg: 2rem     (32px)
--space-xl: 3rem     (48px)

# 또는 4px 배수
--space-xs: 4px
--space-sm: 8px
--space-md: 16px
--space-lg: 24px
--space-xl: 32px
--space-2xl: 48px
```

---

## 🎨 CSS 적용

### Issue: var(--*) 토큰이 적용 안 됨
**증상**: CSS에 `var(--color-primary)` 있지만 색상 안 바뀜

**원인**: 
1. `:root`에 변수가 정의 안 됨
2. 변수명 오타
3. 값이 비어있음

**확인**:
```css
/* style.css 맨 위에 있는가? */
:root {
  --color-primary: #007AFF;
}

/* F12 Console에서 직접 확인 */
getComputedStyle(document.documentElement).getPropertyValue('--color-primary')
```

**해결책**:
```css
/* 맨 앞에 :root 선언 */
:root {
  --color-primary: #007AFF;
  --color-text: #000000;
  --space-md: 1rem;
  /* ... 모든 토큰 */
}

/* 사용할 때 정확한 이름 */
.button {
  background: var(--color-primary);  /* 올바름 */
  background: var(--colorPrimary);   /* 오타! */
  background: #007AFF;               /* 토큰 사용 안 함 */
}
```

### Issue: 호버(hover) 상태에서 색상이 변하지 않음
**증상**: 마우스 올려도 버튼이 어두워지지 않음

**원인**: hover 상태용 토큰이 정의 안 됨

**해결책**:
```markdown
# DESIGN.md에 추가
--color-primary-hover: #0051D5
--color-primary-active: #003a99
```

```css
/* style.css에서 사용 */
.button {
  background: var(--color-primary);
}

.button:hover {
  background: var(--color-primary-hover);
}

.button:active {
  background: var(--color-primary-active);
}
```

### Issue: Dark mode에서 색상이 이상함
**증상**: Dark mode 전환하면 텍스트가 검은색으로 보여서 안 보임

**원인**: Dark mode 토큰이 별도로 정의 안 됨

**해결책**:
```css
/* Light mode (기본값) */
:root {
  --color-bg: #FFFFFF;
  --color-text: #000000;
}

/* Dark mode */
@media (prefers-color-scheme: dark) {
  :root {
    --color-bg: #1C1C1E;
    --color-text: #FFFFFF;
  }
}

/* 또는 explicit dark mode class */
.dark {
  --color-bg: #1C1C1E;
  --color-text: #FFFFFF;
}
```

---

## 📊 참조 페이지 분석

### Issue: "어떤 색상을 추출해야 할지 모르겠음"
**증상**: 참조 페이지에 너무 많은 색상이 있음

**해결책**: 주요 5-7가지만 추출
```
1. 배경색 (주로 흰색, 검정, 또는 밝은 회색)
2. 텍스트 주색 (검정 또는 흰색)
3. 텍스트 보조색 (회색)
4. 강조색 (보통 1-2가지만)
5. 테두리 색 (보통 회색)
```

### Issue: 참조 페이지의 색상을 정확히 모름
**증상**: 비슷하지만 정확히 같지 않은 색

**해결책**:
```bash
# macOS ColorSync Utility
open /System/Library/ColorSync/Profiles

# 또는 온라인 도구
https://chir.ag/projects/ntc.js/  # 색상 이름 찾기
https://www.w3schools.com/colors/colors_picker.asp  # 색상 선택기
```

**정확한 추출 방법**:
```bash
# 스크린샷 찍고 색상 추출 도구 사용
# macOS: DigitalColor Meter, Pastel
# Chrome: Color Picker Chrome Extension
```

---

## 📋 토큰 일관성

### Issue: 일부 스타일은 토큰을 쓰고, 일부는 하드코딩
**증상**: 
```css
.card {
  padding: var(--space-md);  /* 토큰 */
  margin: 24px;              /* 하드코딩 */
  background: var(--color-surface);  /* 토큰 */
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);  /* 하드코딩 */
}
```

**규칙**: 모든 값이 DESIGN.md의 토큰이어야 함

**해결책**:
```markdown
# DESIGN.md에 추가
--shadow-card: 0 4px 12px rgba(0,0,0,0.15);
--space-card-padding: 1rem;
```

```css
.card {
  padding: var(--space-card-padding);
  margin: var(--space-md);
  background: var(--color-surface);
  box-shadow: var(--shadow-card);  /* 이제 모두 토큰 */
}
```

### Issue: "토큰이 너무 많아서 복잡함"
**증상**: DESIGN.md에 토큰이 100개 이상

**규칙**: 최소 20-30개, 최대 50개 정도

**해결책**: 필요한 것만 추출
```markdown
# 최소한 필요한 것
- 5-6개 기본 색상
- 3-4개 텍스트 크기
- 5-6개 간격
- 2-3개 그림자
- 2-3개 둥근 모서리

총 20-30개 정도면 충분
```

---

## 🔍 검증

### Issue: Claude가 토큰을 무시하고 하드코딩 함
**증상**: DESIGN.md를 제시했는데 CSS에 `#FF0000` 같은 직접 값이 있음

**원인**: 프롬프트에서 "토큰만 써줘" 명시 안 함

**해결책**:
```markdown
# PROMPT.md에 추가
## 중요: 디자인 토큰만 사용

아래 DESIGN.md에서 정의한 토큰만 사용해주세요.
토큰에 없는 색상, 간격, 효과는 만들지 마세요.
필요한 값이 있으면 먼저 DESIGN.md에 추가한 후 사용하세요.

[DESIGN.md 전체 내용]

### 올바른 예
background: var(--color-primary);
padding: var(--space-md);

### 나쁜 예 (금지!)
background: #007AFF;
padding: 16px;
```

---

## 📱 반응형 토큰

### Issue: 모바일에서 텍스트가 너무 크거나 작음
**증상**: Desktop에서는 좋은데 모바일에서 읽기 어려움

**해결책**: 반응형 토큰 정의
```css
:root {
  /* Desktop */
  --font-size-hero: 3.5rem;
  --font-size-heading: 2rem;
  --space-section: 3rem;
}

@media (max-width: 768px) {
  :root {
    /* Mobile */
    --font-size-hero: 1.75rem;
    --font-size-heading: 1.25rem;
    --space-section: 1.5rem;
  }
}
```

---

## 🎯 검증 체크리스트

DESIGN.md 완성 후 확인하세요:

- [ ] 색상 토큰이 최대 5-7개
- [ ] 모든 색상이 유일함 (중복 없음)
- [ ] 폰트명에 따옴표 있음
- [ ] 간격이 규칙적 (4px 배수 또는 0.5rem 배수)
- [ ] 모든 토큰이 CSS에서 `var(--*)`로 사용됨
- [ ] 하드코딩된 값 없음
- [ ] 모바일 반응형 토큰 있음 (선택사항)

---

## 📞 더 많은 도움

### 리소스
- Tailwind Design System: https://tailwindcss.com/docs
- Material Design Tokens: https://material.io/design/material-theming/overview.html
- CSS Variables MDN: https://developer.mozilla.org/en-US/docs/Web/CSS/--*
- Color Accessibility: https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum.html

### 색상 대비율 검증
일부 색상 조합이 접근성을 위반하지 않는지 확인:
```
https://webaim.org/resources/contrastchecker/
```

검증 기준: WCAG AA 이상 (명도 대비율 4.5:1 이상 권장)

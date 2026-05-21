# 🚀 DESIGN.md Quick Start (10분)

**목표**: 디자인 토큰으로 포켓몬 카드를 리디자인하기

---

## Step 1: 참조 페이지 선택 (2분)

원하는 디자인 톤을 고르세요:

### 옵션 1: Apple Vision Pro (권장)
- **URL**: https://www.apple.com/vision-pro/
- 특징: 밝은 배경, 큰 타이포, 간결한 색상 (흰색, 검정, 블루)

### 옵션 2: Stripe
- **URL**: https://stripe.com/
- 특징: 그래디언트, 대담한 색상, 현대적 간격

### 옵션 3: Vercel
- **URL**: https://vercel.com/
- 특징: 다크 배경, 밝은 텍스트, 활기찬 강조색

---

## Step 2: DESIGN.md 작성 (3분)

**`DESIGN.md`를 다음 형식으로 작성:**

```markdown
# Design System - [선택한 페이지]

## 색상 (Colors)

### Primary
- Primary: #007AFF (강조색)
- Primary Light: #E5F0FF (약한 강조)
- Primary Dark: #0051D5 (어두운 강조)

### Neutral
- Background: #FFFFFF (배경)
- Surface: #F2F2F7 (카드 배경)
- Text Primary: #000000 (주 텍스트)
- Text Secondary: #666666 (보조 텍스트)
- Border: #E5E5EA (테두리)

## 타이포그래피 (Typography)

### Fonts
- Font Family: "SF Pro Display", -apple-system, sans-serif
- Font Fallback: "Segoe UI", Roboto, sans-serif

### Sizes
- Hero: 3.5rem (56px)
- Title: 2.5rem (40px)
- Heading: 1.5rem (24px)
- Body: 1rem (16px)
- Caption: 0.875rem (14px)

### Weights
- Regular: 400
- Medium: 500
- Semibold: 600
- Bold: 700

## 간격 (Spacing)

- XS: 0.25rem (4px)
- SM: 0.5rem (8px)
- MD: 1rem (16px)
- LG: 1.5rem (24px)
- XL: 2rem (32px)
- 2XL: 3rem (48px)

## 효과 (Effects)

### Shadows
- Subtle: 0 1px 3px rgba(0,0,0,0.12)
- Card: 0 4px 12px rgba(0,0,0,0.15)
- Hover: 0 8px 24px rgba(0,0,0,0.2)

### Border Radius
- Small: 4px
- Medium: 8px
- Large: 16px
- Full: 9999px

## 애니메이션 (Animation) [선택]

- Duration Fast: 150ms
- Duration Normal: 300ms
- Duration Slow: 500ms
- Easing: cubic-bezier(0.4, 0, 0.2, 1)
```

---

## Step 3: Claude에게 프롬프트 제시 (3분)

`PROMPT.md`를 Claude Code에 붙여넣고 DESIGN.md 내용도 함께 제시:

```
[PROMPT.md 내용]

# 추가 컨텍스트

DESIGN.md에 정의된 토큰만 사용해주세요:

[DESIGN.md 내용 전체를 여기 붙여넣기]
```

---

## Step 4: 결과 확인 (2분)

Claude가 생성한 `style.css`에:

- ✅ `--color-*` 토큰 사용
- ✅ `--space-*` 토큰 사용
- ✅ `--shadow-*` 토큰 사용
- ✅ 참조 페이지와 유사한 톤

---

## 예상 결과

### Before (일관성 없음)
```
색상: 분홍, 파랑, 초록 섞임
간격: 랜덤 (24px, 33px, 16px 뒤죽박죽)
폰트: Arial, Helvetica 섞임
```

### After (일관성 있음)
```
색상: 통일 (Primary, Neutral만 사용)
간격: 체계적 (8, 16, 24, 32px만 사용)
폰트: SF Pro Display 일관
→ "디자인된 것처럼" 보임
```

---

## 팁

### Tip 1: 참조 페이지에서 색상 추출
```
1. 참조 페이지 열기
2. F12 → Elements 탭
3. 요소 선택 → Styles 보기
4. background-color, color 값 복사
```

### Tip 2: 브라우저 DevTools로 색상 측정
```
1. 마우스 오른쪽 클릭 → 검사 (Inspect)
2. Styles 탭에서 색상 값 확인
3. 색상 선택기 클릭해서 RGB ↔ HEX 변환
```

### Tip 3: 폰트 확인
```
F12 → Elements → 텍스트 요소 선택
Styles 탭 → font-family 확인
```

---

## 다음 단계

### 개선 (선택)
- [ ] Dark mode DESIGN.md 작성 (--color-dark 버전)
- [ ] 애니메이션 토큰 추가
- [ ] 컴포넌트별 토큰 세분화
- [ ] 디자인 검증 (색상 대비율 체크)

### 학습 내용
- ✅ 디자인 토큰의 개념과 중요성
- ✅ CSS Variables로 일관성 유지
- ✅ 참조 페이지 분석 능력
- ✅ AI 스타일 제약 (제약이 품질을 높인다)

---

## 완료 체크리스트

- [ ] 참조 페이지 선택
- [ ] DESIGN.md 작성 (최소 5개 섹션)
- [ ] Claude에 PROMPT.md + DESIGN.md 제시
- [ ] 생성된 CSS에서 var(--*) 토큰 사용 확인
- [ ] 브라우저에서 참조 페이지와 비교
- [ ] 색상, 간격, 폰트 일관성 확인

**축하합니다! 🎉 디자인 시스템으로 AI 제약하기 완성!**

---

## 참고 리소스

- Apple Design System: https://developer.apple.com/design/
- Google Material Design: https://material.io/design
- Tailwind CSS Variables: https://tailwindcss.com/docs/customizing-colors
- CSS Variables (MDN): https://developer.mozilla.org/en-US/docs/Web/CSS/--*

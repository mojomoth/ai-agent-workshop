# DESIGN.md 작성 가이드

## 목표
참조 페이지의 디자인을 DESIGN.md 토큰으로 정의하여, AI가 일관된 스타일을 유지하도록 제약하기.

## 디자인 요소 추출

### 1. Color Palette
- 배경색 (밝음/어두움)
- 텍스트색 (주/보조)
- 강조색
- 테두리색

### 2. Typography
- 폰트 패밀리
- 크기 (hero/heading/body)
- 굵기 (weight)
- 라인 높이

### 3. Spacing
- XS / SM / MD / LG / XL
- 섹션 간격
- 컴포넌트 간격

### 4. Effects
- 그림자 (depth별)
- 둥근 모서리
- 블러 (글래스 효과)
- 테두리 두께

### 5. Animation (선택)
- 지속시간 (fast/normal/slow)
- Easing function

## CSS Variables 명명 규칙

```css
--[category]-[component]-[state]: value

--color-primary-hover: #...
--space-section-top: 2rem
--shadow-card-hover: 0 8px 16px rgba(...)
```

## 토큰 활용 규칙

1. CSS에서는 var(--token)만 사용
2. 토큰에 없는 값은 만들지 않기
3. 새로운 값이 필요하면 DESIGN.md에 먼저 추가

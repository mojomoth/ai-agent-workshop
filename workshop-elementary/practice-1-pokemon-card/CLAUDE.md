# Pokémon Card Viewer - 프로젝트 컨텍스트

## 프로젝트 개요

PokeAPI에서 1~151번의 포켓몬 데이터를 가져와서 홀로그래픽 카드 이펙트와 글래스모피즘이 적용된 그리드 페이지를 만듭니다.

---

## API 레퍼런스

### PokeAPI
- **Base URL**: https://pokeapi.co/api/v2
- **Endpoint**: `/pokemon/{id-or-name}`
- **Example**: https://pokeapi.co/api/v2/pokemon/1

### 필요한 필드

```json
{
  "id": 1,
  "name": "bulbasaur",
  "sprites": {
    "other": {
      "official-artwork": {
        "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/pokemon/other/official-artwork/1.png"
      }
    }
  },
  "types": [
    {
      "type": {
        "name": "grass"
      }
    },
    {
      "type": {
        "name": "poison"
      }
    }
  ],
  "height": 7,        // 1/10 미터 단위
  "weight": 69        // 1/10 kg 단위
}
```

### 활용 팁

- 포켓몬 이미지: `sprites.other.official-artwork.front_default` (항상 사용)
- 타입: `types[].type.name`을 배지로 표현
- 높이/체중: 정수를 10으로 나눠서 실제 값으로 변환

---

## 비주얼 레퍼런스

### 1. 홀로그래픽 카드 효과
**Source**: https://github.com/simeydotme/pokemon-cards-css

핵심 CSS 원칙:
```css
/* 3D 관점 */
perspective: 1000px;

/* 회전 효과 */
transform: rotateX(var(--ry)) rotateY(var(--rx));

/* 홀로 그래디언트 */
background: radial-gradient(circle at var(--mx) var(--my),
  rgba(255, 255, 255, 0.85),
  rgba(0, 0, 0, 0.7));

/* 블렌드 모드 (color-dodge 사용 필수) */
mix-blend-mode: color-dodge;

/* 필터로 명도 조정 */
filter: brightness(1.1) contrast(2.5) saturate(1.4);
```

### 2. 글래스모피즘 컨테이너
**Source**: https://glass3d.dev

기본 CSS:
```css
background: rgba(255, 255, 255, 0.08);
backdrop-filter: blur(16px) saturate(1.2);
border: 1px solid rgba(255, 255, 255, 0.12);
box-shadow: 0 4px 30px rgba(0, 0, 0, 0.25);
border-radius: 24px;
```

---

## 파일 구조 (권장)

```
practice-1/
├── index.html          # 마크업 + 기본 스타일 (head)
├── style.css           # 모든 스타일 정의
├── main.js             # 모든 로직
└── (생성될 파일들)
    └── pokemon-data.json (캐시 선택사항)
```

---

## 구현 규칙

### JavaScript
- `async/await`로 fetch 사용
- 에러 처리 필수 (try/catch)
- 포켓몬 1~151만 로드 (데이터량 제한)
- 성능: 이미지 lazy-loading 검토

### CSS
- CSS Variables (`--color-*`, `--shadow-*` 등) 사용
- Mobile 첫 설계 (media query 필수)
- `mix-blend-mode: color-dodge` 필수 (홀로 효과)
- `backdrop-filter: blur` 필수 (글래스 효과)

### HTML
- Semantic HTML5 (div 남용 금지)
- `<article>` 또는 `<section>` 사용해서 각 카드 표현
- `role="img"` 또는 `alt=""` 속성 필수

---

## 마우스 인터랙션

```javascript
// 마우스 위치 추적
document.addEventListener('mousemove', (e) => {
  const card = e.target.closest('.card');
  if (!card) return;
  
  // 마우스 좌표를 카드 기준 0~1로 정규화
  const rect = card.getBoundingClientRect();
  const x = (e.clientX - rect.left) / rect.width;
  const y = (e.clientY - rect.top) / rect.height;
  
  // CSS Variables로 전달
  card.style.setProperty('--mx', `${x * 100}%`);
  card.style.setProperty('--my', `${y * 100}%`);
  card.style.setProperty('--rx', `${(y - 0.5) * 20}deg`);
  card.style.setProperty('--ry', `${(x - 0.5) * 20}deg`);
});
```

---

## 성능 최적화

### 필수
- 이미지 크기 최소화 (공식 아트는 이미 최적화됨)
- CSS 애니메이션: `will-change: transform`
- 불필요한 리플로우 방지

### 선택사항
- IndexedDB로 포켓몬 데이터 캐시
- Service Worker (오프라인)
- 가상 스크롤링 (151개 항목이므로 필요 없음)

---

## 브라우저 지원

| 브라우저 | 최소 버전 | 필수 기능 |
|---|---|---|
| Chrome | 95+ | backdrop-filter, CSS custom props |
| Firefox | 103+ | backdrop-filter |
| Safari | 14+ | 모두 지원 |
| Edge | 95+ | 모두 지원 |

---

## 색상 가이드

### 타입별 배지 색상 (Pokemon 공식)

```css
.type-normal { background: #A8A878; }
.type-fighting { background: #C03028; }
.type-flying { background: #A890F0; }
.type-poison { background: #A040A0; }
.type-ground { background: #E0C068; }
.type-rock { background: #B8A038; }
.type-bug { background: #A8B820; }
.type-ghost { background: #705898; }
.type-steel { background: #B8B8D0; }
.type-fire { background: #F08030; }
.type-water { background: #6890F0; }
.type-grass { background: #78C850; }
.type-electric { background: #F8D030; }
.type-psychic { background: #F85888; }
.type-ice { background: #98D8D8; }
.type-dragon { background: #7038F8; }
.type-dark { background: #705848; }
.type-fairy { background: #EE99AC; }
```

---

## 완성도 체크리스트

- [ ] 1~151번 포켓몬 로드됨
- [ ] 이미지가 공식 아트로 표시됨
- [ ] 타입 배지 색상이 정확함
- [ ] 마우스 호버 시 카드가 회전함 (3D)
- [ ] 홀로그램 효과가 보임 (mix-blend-mode)
- [ ] 글래스 컨테이너가 있음 (backdrop-filter)
- [ ] 모바일에서도 잘 보임 (반응형)
- [ ] 에러 처리 (네트워크, API 오류)
- [ ] 성능 양호 (로딩 < 3초)

---

## 참고 링크

- PokeAPI 공식 문서: https://pokeapi.co/docs/v2
- simeydotme 카드 코드: https://github.com/simeydotme/pokemon-cards-css/blob/main/src/demo.css
- CSS `mix-blend-mode`: https://developer.mozilla.org/en-US/docs/Web/CSS/mix-blend-mode
- `backdrop-filter`: https://developer.mozilla.org/en-US/docs/Web/CSS/backdrop-filter

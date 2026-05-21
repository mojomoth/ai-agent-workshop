# 🆘 포켓몬 카드 Troubleshooting

포켓몬 카드 페이지 제작 중 발생하는 일반적인 문제들과 해결책

---

## 📍 환경 설정

### Issue: Python 서버가 안 됨
**증상**: `python3 -m http.server` 실행 후 "command not found"

**해결책**:
```bash
# Python 설치 확인
python3 --version

# 설치 안 됨
brew install python3  # macOS
sudo apt install python3  # Linux

# 포트 사용 중일 때
python3 -m http.server 8001  # 다른 포트 사용
```

### Issue: 브라우저에서 로드 안 됨
**증상**: `http://localhost:8000` 접속 실패

**해결책**:
```bash
# 1. 서버 실행 확인
ps aux | grep "http.server"

# 2. 포트 열려있는지 확인
lsof -i :8000

# 3. 방화벽 확인
# macOS: System Preferences → Security & Privacy → Firewall
# Windows: Windows Defender Firewall 확인
```

---

## 🔴 네트워크 & API

### Issue: PokeAPI에서 데이터 못 가져옴
**증상**: 콘솔에 "Failed to fetch", "Network error"

**원인**: 네트워크 연결 문제

**해결책**:
```bash
# 1. 인터넷 연결 확인
ping pokeapi.co

# 2. curl로 직접 테스트
curl https://pokeapi.co/api/v2/pokemon/1

# 3. 응답 확인
# 정상: JSON 데이터 출력
# 오류: {"detail":"Not found"} 또는 timeout
```

### Issue: CORS 에러 (Cross-Origin)
**증상**: 콘솔: "Access to XMLHttpRequest blocked by CORS policy"

**원인**: 브라우저 보안 정책 (PokeAPI는 CORS 허용하므로 드물게 발생)

**해결책**:
```bash
# 1. 로컬 서버로 열기 (file:// 프로토콜 사용 금지)
python3 -m http.server 8000

# 2. 브라우저 콘솔에서 확인
fetch('https://pokeapi.co/api/v2/pokemon/1')
  .then(r => r.json())
  .then(d => console.log(d))
```

### Issue: 일부 포켓몬만 로드됨
**증상**: 50~100개만 표시되고 나머지는 "failed"

**원인**: 네트워크 타임아웃 또는 너무 빠른 요청

**해결책**:
```javascript
// main.js에서 요청 속도 제어
const delay = (ms) => new Promise(r => setTimeout(r, ms));

for (let i = 1; i <= 151; i++) {
  await fetchPokemon(i);
  if (i % 10 === 0) await delay(100);  // 10개마다 100ms 대기
}
```

---

## 🎨 시각 & CSS

### Issue: 3D 회전이 안 됨
**증상**: 마우스 움직여도 카드가 고정

**원인**: JavaScript에서 CSS 변수를 설정하지 않음

**확인**:
```bash
# F12 (Developer Tools) → Elements 탭
# 마우스 호버 시 카드 element에 style="--rx: ...; --ry: ...;"이 있는지 확인
```

**해결책**:
```javascript
// main.js에 이 코드 추가
document.addEventListener('mousemove', (e) => {
  const card = e.target.closest('.pokemon-card');
  if (!card) return;
  
  const rect = card.getBoundingClientRect();
  const x = (e.clientX - rect.left) / rect.width;
  const y = (e.clientY - rect.top) / rect.height;
  
  card.style.setProperty('--mx', `${x * 100}%`);
  card.style.setProperty('--my', `${y * 100}%`);
  card.style.setProperty('--rx', `${(y - 0.5) * 20}deg`);
  card.style.setProperty('--ry', `${(x - 0.5) * 20}deg`);
});
```

### Issue: 홀로그램 효과가 안 보임
**증상**: 카드가 평평함 (3D 느낌 없음)

**원인**: `mix-blend-mode: color-dodge` 미적용

**해결책**:
```css
/* style.css */
.pokemon-card::after {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: radial-gradient(circle at var(--mx, 50%) var(--my, 50%),
    rgba(255, 255, 255, 0.85),
    rgba(0, 0, 0, 0.7));
  mix-blend-mode: color-dodge;  /* 필수! */
  pointer-events: none;
}
```

### Issue: 글래스 효과(blur)가 깨끗하지 않음
**증상**: 배경이 흐리지만 '글래스'같지 않음

**원인**: `backdrop-filter` 설정 부족

**해결책**:
```css
/* style.css */
.card-container {
  background: rgba(255, 255, 255, 0.08);  /* 반투명 화이트 */
  backdrop-filter: blur(16px) saturate(1.2);
  border: 1px solid rgba(255, 255, 255, 0.12);
  box-shadow: 0 4px 30px rgba(0, 0, 0, 0.25);
}
```

### Issue: 이미지 깨짐 또는 틀어짐
**증상**: 포켓몬 이미지가 찌그러짐 또는 회전

**원인**: 이미지 컨테이너 크기 설정 오류

**해결책**:
```css
.pokemon-image {
  width: 100%;
  height: auto;  /* 비율 유지 */
  aspect-ratio: 1;  /* 정사각형 */
  object-fit: contain;  /* 이미지 자르지 않기 */
}
```

---

## 📊 성능 & 로딩

### Issue: 페이지 로딩 시간이 매우 김
**증상**: 브라우저 열기 후 10초 이상 걸림

**원인**: 151개 이미지 동시 로드

**해결책**:
```javascript
// 1. Lazy loading 추가
const images = document.querySelectorAll('img');
images.forEach(img => {
  img.loading = 'lazy';
});

// 2. 또는 IntersectionObserver 사용
const observer = new IntersectionObserver((entries) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      entry.target.src = entry.target.dataset.src;
      observer.unobserve(entry.target);
    }
  });
});

// 3. 개수 제한 (테스트 시)
for (let i = 1; i <= 30; i++) {  // 151 대신 30개만
  loadPokemon(i);
}
```

### Issue: 마우스 움직임이 끊김 (jank)
**증상**: 마우스 움직일 때 카드 애니메이션이 버벅거림

**원인**: 불필요한 리페인트/리플로우

**해결책**:
```css
/* style.css */
.pokemon-card {
  will-change: transform;
  transform: translateZ(0);  /* GPU 가속 */
}

/* 리플로우 방지 */
.pokemon-card::after {
  position: absolute;  /* 레이아웃 영향 없음 */
  pointer-events: none;  /* 이벤트 통과 */
}
```

---

## 🖥️ 브라우저 호환성

### Issue: Safari에서 안 보임
**증상**: Safari만 공백 또는 에러

**원인**: `backdrop-filter` 지원 (Safari 14+에서 지원)

**확인**:
```javascript
// 콘솔에서 확인
console.log(CSS.supports('backdrop-filter', 'blur(10px)'));
```

**해결책**:
```css
/* Fallback 추가 */
.card-container {
  background: rgba(255, 255, 255, 0.1);
  
  @supports (backdrop-filter: blur(1px)) {
    backdrop-filter: blur(16px);
  }
  @supports not (backdrop-filter: blur(1px)) {
    background: rgba(255, 255, 255, 0.25);  /* 더 불투명하게 */
  }
}
```

### Issue: Chrome에서 색상이 다름
**증상**: 타입 배지 색상이 예상과 다름

**원인**: CSS Variables 또는 색상 공간 차이

**해결책**:
```css
/* 색상 값 확인 */
.type-grass {
  background: #78C850;  /* 포켓몬 공식 색상 */
}

/* 또는 HSL로 */
.type-grass {
  background: hsl(120, 60%, 60%);
}
```

---

## 🐛 JavaScript 에러

### Issue: 콘솔에 "Cannot read property 'sprites'" 에러
**증상**: 콘솔 에러, 이미지 안 보임

**원인**: API 응답 구조 오해

**해결책**:
```javascript
// 올바른 구조
const imageUrl = pokemon.sprites.other['official-artwork'].front_default;
//                                 ↑ official-artwork를 key로 접근
```

### Issue: "Maximum call stack size exceeded"
**증상**: 콘솔 에러 후 페이지 멈춤

**원인**: 무한 루프 또는 재귀

**확인**:
```bash
# main.js에서 확인:
# - for/while 루프 조건이 변하는가?
# - 함수가 자기 자신을 무한 호출하는가?
```

### Issue: 일부 포켓몬 이름이 한글이 아님
**증상**: "bulbasaur" 같이 영문 표시

**원인**: 한글 변환 로직 미구현

**해결책**:
```javascript
// 한글 이름 매핑 추가 (선택)
const pokemonNames = {
  1: '이상해씨', 2: '이상해풀', 3: '이상해꽃', ...
};

document.querySelector('.pokemon-name').textContent = 
  pokemonNames[id] || pokemon.name;
```

---

## 📋 최종 체크리스트

문제 해결 후 확인하세요:

- [ ] 포켓몬 1~151이 모두 로드됨
- [ ] 이미지가 공식 아트로 표시됨
- [ ] 마우스 호버 시 3D 회전
- [ ] 홀로그램 효과 (color-dodge) 보임
- [ ] 글래스 배경 (backdrop-filter) 흐릿함
- [ ] 모바일 (폰)에서도 반응형
- [ ] 콘솔 에러 없음
- [ ] 로딩 시간 < 5초
- [ ] Chrome, Firefox, Safari 모두 작동

---

## 📞 더 많은 도움

### 리소스
- PokeAPI 문서: https://pokeapi.co/docs/v2
- MDN CSS mix-blend-mode: https://developer.mozilla.org/en-US/docs/Web/CSS/mix-blend-mode
- MDN backdrop-filter: https://developer.mozilla.org/en-US/docs/Web/CSS/backdrop-filter
- GitHub 포켓몬 카드: https://github.com/simeydotme/pokemon-cards-css

### 추가 도움 필요?
1. 콘솔 (F12) 에러 메시지 확인
2. Network 탭에서 PokeAPI 요청 확인
3. Elements 탭에서 HTML 구조 확인
4. Sources 탭에서 JavaScript 실행 추적

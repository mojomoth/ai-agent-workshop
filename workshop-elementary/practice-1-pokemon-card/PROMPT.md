# 포켓몬 카드 페이지 - 초기 프롬프트

이 파일의 내용을 Claude Code에 복사해서 붙이세요.

---

## Claude Code에 붙이기 (아래부터)

```
[Shift+Tab으로 Plan Mode 진입]

목표: PokeAPI에서 1~151번 포켓몬을 가져와 카드 그리드로 보여주는 페이지

각 카드는:
- 공식 아트워크 이미지 (PokeAPI sprites.other.official-artwork.front_default)
- 포켓몬 이름, 타입 배지, 키/몸무게
- 마우스 호버 시 3D 회전 + 홀로그래픽 효과 (simeydotme 스타일)
- 카드 컨테이너는 glassmorphism (glass3d.dev 스타일)

참고:
- PokeAPI: https://pokeapi.co/api/v2/pokemon/{id}
- 홀로 카드 CSS: https://github.com/simeydotme/pokemon-cards-css
- 글래스 효과: https://glass3d.dev

먼저 파일 구조를 설계해줘. 코드는 아직 쓰지 마.
```

---

## 설계 확인 후 (Plan Mode에서 설계 보면)

```
[Shift+Tab으로 Normal Mode 복귀]

위 설계대로 진행해줘.
```

---

## Claude가 코드를 다 만들면 (테스트)

생성된 파일들:
- `index.html`
- `style.css`  
- `main.js`

브라우저에서 `index.html` 열어서 확인:
1. 포켓몬 카드들이 그리드로 보이는가?
2. 마우스를 카드에 올리면 홀로그램 효과가 보이는가?
3. 글래스 컨테이너가 있는가?

---

## 효과 개선 (선택)

원하면 다음을 추가 요청:

```
> 홀로그램 효과를 더 강하게 해줘.
> simeydotme 스타일로 mix-blend-mode: color-dodge 활용
> filter: brightness, contrast, saturate 조정
```

---

이 프롬프트를 Claude에 붙이고 엔터를 누르세요!

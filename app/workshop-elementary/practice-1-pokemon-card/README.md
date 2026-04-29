# 실습 1: 포켓몬 카드 만들기

**목표**: PokeAPI에서 포켓몬 데이터를 가져와 홀로그램 효과와 글래스모피즘이 적용된 카드 그리드 페이지를 만들기

**소요 시간**: 20분  
**난이도**: ⭐ (입문)  
**필수 도구**: Claude Code

---

## 📖 개요

이 실습에서는 다음을 배웁니다:

1. **CLAUDE.md로 컨텍스트 설정** - AI에게 API 정보와 디자인 레퍼런스 제공
2. **Plan 모드로 설계와 구현 분리** - 코드 작성 전 아키텍처 계획
3. **외부 레퍼런스 효과적으로 제시** - URL, 코드 스니펫으로 명확한 기준 제공

---

## 🎯 최종 결과물

완성하면 다음과 같은 페이지가 생깁니다:

```
┌─────────────────────────────────────┐
│  포켓몬 카드 그리드 (1~151번)        │
├─────────────────────────────────────┤
│  ┌──────────┐  ┌──────────┐  ...   │
│  │  Bulbas  │  │ Ivysaur  │        │
│  │ 홀로이펙 │  │ 홀로이펙 │        │
│  │[Glass]  │  │[Glass]  │        │
│  └──────────┘  └──────────┘        │
│                                     │
│  글래스모피즘 컨테이너 + 홀로 카드  │
└─────────────────────────────────────┘
```

---

## 🚀 시작하기

### Step 1: PROMPT.md 열기

현재 폴더의 `PROMPT.md`를 열고 전체 내용을 읽으세요.

```bash
cat PROMPT.md
```

### Step 2: Claude Code 실행

```bash
# 새로운 Claude Code 세션 시작
claude

# 또는 이미 실행 중이면 그냥 계속
```

### Step 3: 프롬프트 제시

PROMPT.md의 내용을 Claude Code에 복사해서 붙이고 엔터를 누르세요.

```
[Shift+Cmd+V] 또는 [Ctrl+Shift+V]로 붙여넣기
```

### Step 4: Plan 모드에서 설계 확인

Claude가 설계를 제시하면:
- 파일 구조가 명확한지 확인
- API 사용법이 정확한지 확인  
- 진행하려면 `y` 또는 `yes` 입력

### Step 5: 빌드 및 테스트

Claude가 코드를 생성하면:
- 생성된 `index.html` / `style.css` / `main.js` 확인
- 브라우저에서 `index.html` 열기
- 카드들이 제대로 로드되고 홀로 이펙트가 보이는지 확인

### Step 6: 효과 개선 (선택)

마우스 호버 효과를 더 세밀하게 조정하려면:

```
> 홀로그램 효과를 simeydotme 레퍼런스 방식으로 더 강하게 
> (mix-blend-mode: color-dodge 활용)
```

---

## 📚 핵심 개념

### 1. CLAUDE.md: 컨텍스트 주기

이 실습에서는 CLAUDE.md에 다음을 포함합니다:

```md
# Pokémon Card Viewer

## API Reference
- https://pokeapi.co/api/v2/pokemon/{id}
- 필드: name, sprites.other.official-artwork.front_default, types, height, weight

## Visual Reference
- 홀로 효과: github.com/simeydotme/pokemon-cards-css
- 글래스 효과: glass3d.dev
```

AI는 이 정보를 기반으로 추측하지 않고 정확한 코드를 생성합니다.

### 2. Plan 모드: 설계와 구현 분리

```
[Shift+Tab]  →  Plan 모드 진입
"파일 구조부터 잡아줘. 코드는 아직 쓰지 마."
[Shift+Tab]  →  Normal 모드 복귀 (구현 시작)
```

Plan 모드에서는 코드 없이 아키텍처만 논의합니다.

### 3. 외부 레퍼런스 제시

단순히 "멋진 카드 만들어줘"라고 하는 대신:

```
"simeydotme 스타일 홀로그램 + glass3d.dev 스타일 글래스
+ PokeAPI 공식 아트 이미지"
```

명확한 기준을 제시하면 AI의 결과물이 훨씬 좋습니다.

---

## 🛠️ 기술 스택

| 레이어 | 기술 |
|---|---|
| **마크업** | Vanilla HTML5 |
| **스타일** | Vanilla CSS3 (CSS Variables, Transforms) |
| **로직** | Vanilla JavaScript (fetch API) |
| **데이터** | PokeAPI (https://pokeapi.co) |

**이유**: 프레임워크 없이 순수 기술로 학습합니다.

---

## 💾 생성되는 파일 구조

실습 완료 후:

```
practice-1-pokemon-card/
├── README.md (이 파일)
├── PROMPT.md (초기 프롬프트)
├── CLAUDE.md (프로젝트 컨텍스트)
├── checklist.md (진행 상황)
└── (작업 폴더)
    ├── index.html
    ├── style.css
    ├── main.js
    └── pokemon-data.json (캐시)
```

---

## ⏱️ 시간 분배

| 단계 | 시간 | 내용 |
|---|---|---|
| 준비 | 2분 | PROMPT.md 읽기, Claude 실행 |
| Plan | 3분 | 설계 제시 및 확인 |
| 빌드 | 10분 | Claude가 코드 생성 |
| 테스트 | 3분 | 브라우저에서 확인 |
| 개선 | 2분 | 효과 미세 조정 (선택) |

---

## 🔍 체크포인트

실습 진행 중 다음을 확인하세요:

- [ ] PROMPT.md 내용을 이해했는가?
- [ ] Claude가 설계를 제시했는가?
- [ ] `index.html`, `style.css`, `main.js`가 생성되었는가?
- [ ] 브라우저에서 포켓몬 카드들이 보이는가?
- [ ] 마우스 호버 시 홀로그램 효과가 보이는가?
- [ ] 글래스모피즘 컨테이너가 있는가?

---

## 🎓 배운 점 정리

이 실습을 마치면:

✅ **CLAUDE.md의 중요성** 이해  
- 컨텍스트가 없으면 AI가 추측한다
- API 문서, 디자인 레퍼런스를 미리 제공하면 정확하다

✅ **Plan 모드의 가치** 이해  
- 코드 작성 전 설계를 논의하면 효율적이다
- 잘못된 방향을 미리 발견할 수 있다

✅ **외부 레퍼런스 활용법** 학습  
- URL, 코드 스니펫으로 명확한 기준을 제시한다
- 단순한 설명보다 구체적인 예시가 낫다

---

## 🚨 문제 해결

### "PokeAPI 응답 오류"
→ 인터넷 연결 확인, 포켓몬 번호(1~151) 확인

### "홀로그램 효과가 안 보임"
→ CSS의 `mix-blend-mode` 지원 확인 (모던 브라우저 필요)

### "글래스 효과가 흐릿함"
→ `backdrop-filter: blur` 값 조정 (기본: 16px)

### "캐시 때문에 변경 안 보임"
→ 브라우저 F12 → Network → "Disable cache" 체크

---

## 📖 참고 자료

| 자료 | 설명 |
|---|---|
| [PokeAPI 문서](https://pokeapi.co/docs/v2) | API 엔드포인트 및 필드 설명 |
| [simeydotme 카드 CSS](https://github.com/simeydotme/pokemon-cards-css) | 홀로그램 이펙트 구현 방식 |
| [glass3d.dev](https://glass3d.dev) | 글래스모피즘 생성기 |
| [CSS Transforms](https://developer.mozilla.org/en-US/docs/Web/CSS/transform) | 3D 변환 문서 |

---

## ➡️ 다음 단계

이 실습을 마치면:

→ [실습 2: DESIGN.md로 디자인 훔치기](../practice-2-design-md/README.md)

아까 만든 포켓몬 카드 페이지를 Apple visionOS 톤으로 리디자인합니다.

---

**준비가 되셨으면 `PROMPT.md`를 열고 시작하세요!** 🚀

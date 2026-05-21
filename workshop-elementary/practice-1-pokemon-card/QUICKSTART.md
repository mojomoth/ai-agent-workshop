# 🚀 포켓몬 카드 Quick Start (15분)

**목표**: PokeAPI + 홀로 효과 + 글래스모피즘 카드 페이지를 Claude로 만들기

---

## Step 1: 준비 (2분)

```bash
# 프로젝트 폴더 생성
mkdir pokemon-cards && cd pokemon-cards

# 파일 3개 생성 (비어있음 OK)
touch index.html style.css main.js
```

---

## Step 2: Claude에게 시작 프롬프트 제시 (1분)

**`PROMPT.md` 내용을 Claude Code에 붙여넣기:**

```bash
cat PROMPT.md | pbcopy  # macOS
# 또는 PROMPT.md을 열어서 직접 복사
```

Claude Code에 붙여넣고 실행.

---

## Step 3: Claude가 만든 코드를 파일에 저장 (2분)

Claude가 생성한 HTML/CSS/JS 코드를:
- `index.html` 에 붙여넣기
- `style.css` 에 붙여넣기
- `main.js` 에 붙여넣기

---

## Step 4: 브라우저에서 열기 (1분)

```bash
# 방법 1: 직접 열기
open index.html  # macOS
# 또는 firefox index.html, google-chrome index.html

# 방법 2: 간단한 서버 (권장)
python3 -m http.server 8000
# 그 후 브라우저에서 http://localhost:8000 열기
```

---

## Step 5: 마우스 움직이기 테스트 (3분)

카드 위에 마우스를 움직이면:
- ✅ 카드가 3D 회전하는가?
- ✅ 홀로그램 효과가 보이는가?
- ✅ 글래스 배경이 흐릿한가?
- ✅ 151개 포켓몬이 모두 로드되었는가?

---

## 결과 이미지

```
┌──────────────────────────────────────┐
│ 포켓몬 카드 그리드 (호버 시 3D 회전) │
├──────────────────────────────────────┤
│  ┌─────────┐  ┌─────────┐  ┌──────┐ │
│  │ Bulbas  │  │ Ivysaur │  │ ...  │ │
│  │ [홀로] │ │ [홀로]  │  │      │ │
│  │[Grass]  │  │[Grass]  │  │ ...  │ │
│  └─────────┘  └─────────┘  └──────┘ │
│  글래스 컨테이너 + 151개 카드        │
└──────────────────────────────────────┘
```

---

## 문제 해결

### 문제: 이미지가 안 보임
```
→ PokeAPI 네트워크 확인
→ 콘솔 (F12) 에서 에러 메시지 확인
→ 브라우저 새로고침 (Ctrl+R)
```

### 문제: 3D 회전이 안 됨
```
→ 마우스 움직임이 트리거하는지 확인 (콘솔 로그 추가)
→ CSS transform 문법 확인
→ 브라우저 지원 확인 (Chrome 95+, Firefox 103+)
```

### 문제: 글래스 효과가 안 보임
```
→ CSS backdrop-filter 지원 확인
→ blur(16px) 값이 크다고 느껴지면 blur(8px)로 조정
```

---

## 다음 단계

### 개선 사항 (선택)
- [ ] 데이터 캐싱 (IndexedDB)
- [ ] 타입별 필터링
- [ ] 검색 기능
- [ ] Dark mode 토글
- [ ] 포켓몬 상세 모달

### 학습 내용 확인
- ✅ PokeAPI 데이터 구조 이해
- ✅ 마우스 좌표 정규화 개념
- ✅ CSS Variables로 동적 스타일 제어
- ✅ `mix-blend-mode`와 `backdrop-filter` 실전 사용
- ✅ `async/await` 네트워크 요청

---

## 완료 체크리스트

- [ ] 파일 3개 생성 (index.html, style.css, main.js)
- [ ] Claude가 생성한 코드 저장
- [ ] 브라우저에서 페이지 로드
- [ ] 1~151 포켓몬이 모두 표시됨
- [ ] 마우스 호버 시 3D 회전 작동
- [ ] 홀로 + 글래스 효과 확인

**축하합니다! 🎉 포켓몬 카드 페이지 완성!**

---

## 참고

- 공식 PokeAPI: https://pokeapi.co/docs/v2
- CSS 레퍼런스: https://github.com/simeydotme/pokemon-cards-css
- MDN backdrop-filter: https://developer.mozilla.org/en-US/docs/Web/CSS/backdrop-filter

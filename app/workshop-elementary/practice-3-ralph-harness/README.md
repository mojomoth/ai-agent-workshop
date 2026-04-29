# 실습 3: Ralph & Harness 기본 구축

**목표**: bash 루프로 같은 프롬프트를 반복 실행해서 점진적 개선 자동화

**소요 시간**: 20분  
**난이도**: ⭐⭐ (중급)  
**필수 도구**: Claude Code, Bash

---

## 📖 개요

Ralph Wiggum (심슨 가족 캐릭터)처럼 "끈질기지만 영리하진 않은" 방식으로 작동합니다:

```
같은 프롬프트를 계속 반복 실행 → 매번 조금씩 개선 → 목표 달성
```

### 왜 이게 필요한가?

- 코딩 AI는 **한 번에** 정답을 못 냅니다
- 근데 **여러 번 반복**하면 점진적으로 나아집니다
- 사람이 매번 "더 해줘" 누르기 귀찮음
- → Ralph 루프로 자동화

---

## 🚀 실습 내용

### Ralph 루프의 핵심

```bash
#!/bin/bash
while true; do
  # 같은 프롬프트 실행
  claude -p "$(cat PROMPT.md)"
  
  # 완료 신호 확인
  grep -q "ALL DONE" fix_plan.md && break
done
```

**이게 전부입니다!** Bash 10줄.

### 실습 구조

포켓몬 카드 페이지에 기능을 3개 추가합니다:

```md
# PROMPT.md
포켓몬 카드 페이지 개선:
1. [ ] 검색 기능 (이름/타입)
2. [ ] 정렬 (번호/이름/타입)
3. [ ] 즐겨찾기 (localStorage)

# fix_plan.md
- [ ] 검색
- [ ] 정렬
- [ ] 즐겨찾기

완료되면 "ALL DONE" 적기
```

Claude가 한 번에 다 못 만들어도, Ralph 루프가 계속 반복하면서:
- 완료 항목을 체크
- 미완료 항목 계속 진행
- 버그 수정
- 최종 "ALL DONE" 출력

---

## 📋 Ralph 루프 작성

### 1단계: PROMPT.md 작성 (5분)

```md
# 작업
포켓몬 카드 페이지 개선:
1. 검색 기능
2. 정렬 기능
3. 즐겨찾기

# 규칙
- 한 번에 하나씩
- 작은 커밋
- 매 라운드 끝에 fix_plan.md 갱신
- 모두 끝나면 "ALL DONE"
```

### 2단계: fix_plan.md 템플릿 (1분)

```md
- [ ] 검색
- [ ] 정렬
- [ ] 즐겨찾기

완료: 아직 안 함
```

### 3단계: ralph.sh 작성 (3분)

```bash
#!/bin/bash
MAX=30

for i in $(seq 1 $MAX); do
  echo "=== Round $i/30 ==="
  claude -p "$(cat PROMPT.md)\n\n현재 상태:\n$(cat fix_plan.md)"
  
  if grep -q "ALL DONE" fix_plan.md; then
    echo "🎉 완료!"
    break
  fi
  
  sleep 2
done
```

### 4단계: 실행 (11분)

```bash
chmod +x ralph.sh
./ralph.sh
```

**모니터링**: 각 라운드마다 진행 상황 확인

---

## 🔑 Ralph 잘 쓰는 핵심 3가지

### 1️⃣ 명확한 종료 조건
```md
- [ ] Task 1
- [ ] Task 2
✅ ALL DONE
```

AI가 "ALL DONE"을 출력하면 끝.

### 2️⃣ 필수 --max-iterations
```bash
--max-iterations 30  # 최대 30회 반복
```

비용 폭주 방지 (30회 = ~$10~20)

### 3️⃣ 실패 패턴 → 표지판

Claude가 같은 실수 반복하면:
```md
# PROMPT.md에 추가
⚠️ 주의: localStorage 사용, sessionStorage 아님
✅ 예시 코드:
  const saved = localStorage.getItem('favorites')
```

다음 라운드부터 자동 발견 + 수정.

---

## ⏱️ 시간 분배

| 단계 | 시간 |
|---|---|
| 개념 이해 | 3분 |
| PROMPT.md 작성 | 2분 |
| fix_plan.md 생성 | 1분 |
| ralph.sh 작성 | 3분 |
| 실행 및 모니터링 | 10분 |
| **합계** | **20분** |

---

## 💰 비용 예측

- Claude Opus: $1/round × 20 = ~$20
- Claude Sonnet: $0.2/round × 20 = ~$4

**권장**: 10 라운드부터 시작 (저비용 테스트)

---

## 📊 진행 추적

fix_plan.md는 다음처럼 변합니다:

```
라운드 1:
- [x] 검색 (기본 완료)
- [ ] 정렬
- [ ] 즐겨찾기

라운드 2:
- [x] 검색 (완성)
- [x] 정렬 (추가됨)
- [ ] 즐겨찾기

라운드 3:
- [x] 검색
- [x] 정렬
- [x] 즐겨찾기
✅ ALL DONE
```

---

## 🎯 완성도 체크

- [ ] PROMPT.md 작성했다
- [ ] fix_plan.md 템플릿 생성했다
- [ ] ralph.sh 작성했다
- [ ] 실행 권한 줬다 (chmod +x)
- [ ] 루프 실행했다
- [ ] 진행 상황이 점진적으로 개선된다
- [ ] "ALL DONE" 출력되었다

---

## 📝 배운 점

✅ **Ralph의 원리**: 반복이 거대한 작업 단위가 된다  
✅ **하네스의 개념**: bash 10줄이 메타 하네스다  
✅ **점진적 개선**: 완벽함보다 진행이 중요

---

## ➡️ 다음 단계

→ [실습 4: Claude × Codex 검증 루프](../practice-4-claude-codex/README.md)

Ralph와 달리 다른 모델(Codex)로 검증하는 패턴을 배웁니다.

---

**준비가 되셨으면 PROMPT.md를 열고 시작하세요!** 🔄

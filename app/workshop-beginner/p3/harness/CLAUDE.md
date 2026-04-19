# 이 저장소의 철칙

## 절대 규칙
- 테스트가 하나라도 실패한 상태로 커밋하지 않는다.
- 린트 에러가 있는 상태로 커밋하지 않는다.
- `requirements.txt` 에 없는 외부 패키지를 import 하지 않는다.
- `rm -rf`, `curl | sh`, 전역 설치(`pip install --user` 제외) 금지.

## 커밋 규칙
- Conventional Commits 형식
- 한 커밋은 한 가지 일만

## 체크리스트 (커밋 전에 스스로 검증)
1. `ruff check .` 통과
2. `pytest -q` 전부 통과
3. `git diff --stat` 이 예상한 파일들만 포함
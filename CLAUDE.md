# AI Agent Workshop

이 저장소는 **Claude Code / Codex / OpenCode** 세 가지 AI 코딩 에이전트를
동일한 환경에서 실습하기 위한 워크숍 템플릿입니다.

## 구조
- `.devcontainer/` — VS Code Dev Container 정의 (Dockerfile, devcontainer.json)
- `docker-compose.yml` — VS Code 없이 Docker 로만 실행할 때 사용
- `app/` — 실습 중 작성할 샘플 코드가 들어가는 폴더
- `.env.example` — API 키 기반 로그인 시 사용할 환경변수 샘플

## 에이전트 사용 규칙
- 실습 중 생성되는 모든 산출물은 `app/` 아래에 두세요.
- 호스트 홈의 `~/.claude`, `~/.codex`, `~/.local/share/opencode` 디렉터리가
  컨테이너로 bind mount 되므로, **컨테이너를 재빌드해도 로그인 세션은 유지**됩니다.
- 자세한 설치·로그인·실행 단계는 `README.md` 를 참고하세요.

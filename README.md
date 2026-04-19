# AI Agent Workshop

**Claude Code**, **Codex**, **OpenCode** 세 가지 AI 코딩 에이전트를 동일한
컨테이너 환경에서 실습하기 위한 워크숍 템플릿입니다.
VS Code **Dev Container** 와 **Docker Compose** 두 가지 방식으로 실행할 수
있습니다.

---

## 목차
1. [사전 준비물](#1-사전-준비물)
2. [저장소 구조](#2-저장소-구조)
3. [실행 방법 A — VS Code Dev Container (권장)](#3-실행-방법-a--vs-code-dev-container-권장)
4. [실행 방법 B — Docker Compose 만 사용](#4-실행-방법-b--docker-compose-만-사용)
5. [에이전트 초기 설치와 로그인](#5-에이전트-초기-설치와-로그인)
   - [5.1 Claude Code](#51-claude-code)
   - [5.2 Codex](#52-codex)
   - [5.3 OpenCode](#53-opencode)
6. [세션/로그인 정보가 저장되는 위치](#6-세션로그인-정보가-저장되는-위치)
7. [자주 겪는 문제 (FAQ)](#7-자주-겪는-문제-faq)

---

## 1. 사전 준비물

| 도구 | 용도 | 설치 확인 |
|------|------|-----------|
| Docker Desktop *(또는 Docker Engine)* | 컨테이너 런타임 | `docker --version` |
| VS Code | Dev Container 모드에서 필요 | `code --version` |
| VS Code 확장: **Dev Containers** *(ms-vscode-remote.remote-containers)* | Dev Container 모드에서 필요 | VS Code 확장 탭에서 설치 |
| Git | 저장소 클론 | `git --version` |

> Docker 만으로 실행하려면 VS Code 와 Dev Containers 확장은 없어도 됩니다.
> 실습 계정(Claude Code / Codex)은 워크숍 당일에 별도로 안내됩니다.

---

## 2. 저장소 구조

```
ai-agent-workshop/
├── .devcontainer/
│   ├── Dockerfile              # Node 20 + Python + 3 개 에이전트 설치
│   └── devcontainer.json       # VS Code Dev Container 정의
├── docker-compose.yml          # VS Code 없이 Docker 로 실행할 때 사용
├── .env.example                # API 키 방식 로그인을 위한 환경변수 샘플
├── CLAUDE.md                   # Claude Code 용 프로젝트 컨텍스트
├── README.md                   # 이 문서
└── app/                        # 실습 산출물 폴더
```

컨테이너 안에는 세 에이전트가 전역으로 설치되어 있습니다.

| 에이전트 | 패키지 | 커맨드 |
|----------|--------|--------|
| Claude Code | `@anthropic-ai/claude-code` | `claude` |
| Codex | `@openai/codex` | `codex` |
| OpenCode | `opencode-ai` | `opencode` |

---

## 3. 실행 방법 A — VS Code Dev Container (권장)

### Step 1. 저장소 클론
```bash
git clone <이 저장소 URL> ai-agent-workshop
cd ai-agent-workshop
```

### Step 2. (선택) 환경변수 설정
실습 계정으로 **브라우저 로그인**을 쓸 거라면 건너뛰어도 됩니다.
**API 키**로 바로 사용하고 싶다면 호스트 쉘에서 export 해 두세요.
(devcontainer.json 의 `remoteEnv` 설정이 호스트 환경변수를 컨테이너로 전달합니다.)

```bash
export ANTHROPIC_API_KEY=sk-ant-...
export OPENAI_API_KEY=sk-...
code .    # 반드시 위 export 한 같은 쉘에서 VS Code 를 띄워야 전달됩니다
```

### Step 3. Dev Container 로 열기
VS Code 에서 저장소 폴더를 열면 오른쪽 아래에
**"Reopen in Container"** 알림이 뜹니다. 클릭하세요.
알림이 안 보이면 `F1` → `Dev Containers: Reopen in Container` 를 실행합니다.

> 최초 실행 시 이미지 빌드로 3~5 분 정도 걸립니다.

### Step 4. 버전 확인
컨테이너가 준비되면 터미널에서 `postCreateCommand` 출력이 보입니다.
직접 다시 확인하고 싶다면:

```bash
node -v
python3 --version
claude --version
codex --version
opencode --version
```

모두 버전이 찍히면 성공입니다. 이제 [5. 에이전트 초기 설치와 로그인](#5-에이전트-초기-설치와-로그인) 으로 가세요.

---

## 4. 실행 방법 B — Docker Compose 만 사용

VS Code 를 쓰지 않거나, CI·원격 서버에서 돌릴 때의 경로입니다.

### Step 1. 저장소 클론
```bash
git clone <이 저장소 URL> ai-agent-workshop
cd ai-agent-workshop
```

### Step 2. (선택) `.env` 파일 생성
API 키로 사용할 경우에만 필요합니다.

```bash
cp .env.example .env
# .env 를 열어 ANTHROPIC_API_KEY / OPENAI_API_KEY 를 채워 넣으세요
```

### Step 3. 로그인 세션 저장용 디렉터리 준비
Compose 가 호스트의 이 경로들을 컨테이너로 bind mount 하기 때문에,
**미리 만들어 두면 권한 문제가 생기지 않습니다.**

```bash
mkdir -p ~/.claude ~/.codex \
         ~/.config/opencode ~/.cache/opencode \
         ~/.local/share/opencode ~/.local/state/opencode
```

> OpenCode 는 XDG 스펙을 따르기 때문에 `.config`, `.cache`, `.local/share`,
> `.local/state` 네 곳을 모두 사용합니다. 하나라도 누락되면 `opencode auth login`
> 에서 `EACCES: permission denied, mkdir '/home/vscode/.local/state'` 같은 오류가 납니다.

### Step 4. 이미지 빌드 & 컨테이너 기동
```bash
docker compose build
docker compose run --rm workshop   # bash 프롬프트로 진입
```

다시 들어올 때는 동일하게 `docker compose run --rm workshop` 하면 됩니다.
항상 띄워 두고 여러 번 접속하고 싶다면:

```bash
docker compose up -d workshop
docker compose exec workshop bash
```

### Step 5. 버전 확인
컨테이너 bash 안에서:

```bash
claude --version && codex --version && opencode --version
```

---

## 5. 에이전트 초기 설치와 로그인

> 세 에이전트 모두 **컨테이너에 이미 설치되어 있습니다.**
> 여기서는 **최초 로그인/설정**만 다룹니다.
> 실습 계정 정보(이메일/비밀번호 또는 API 키)는 워크숍 당일에 안내됩니다.

### 5.1 Claude Code

#### 로그인 (실습 계정 사용 시 권장)
컨테이너 터미널에서 그냥 `claude` 를 실행하면 처음 한 번 로그인 화면이 뜹니다.

```bash
claude
```

출력되는 URL 을 **호스트 브라우저에서 열고** 실습 계정으로 로그인한 뒤,
화면에 표시된 인증 코드를 터미널에 붙여 넣으면 됩니다.

- 로그인 세션은 `~/.claude/` 에 저장되며, 컨테이너를 재빌드해도 유지됩니다.
- 프로젝트 컨텍스트는 `CLAUDE.md` 에 적어 두면 Claude Code 가 자동으로 읽습니다.

#### API 키로 쓰고 싶을 때
`.env` 또는 호스트 환경변수에 `ANTHROPIC_API_KEY` 를 설정해 두면
별도 로그인 없이 바로 사용됩니다. 기존 로그인을 해제하려면:

```bash
claude /logout
```

#### 첫 실습 예
```bash
cd /app
claude
# 프롬프트에서:  "app/ 아래에 hello.py 를 만들고 Hello Workshop 을 출력해줘"
```

---

### 5.2 Codex

#### 로그인 (실습 계정 사용 시 권장)
```bash
codex login
```

표시되는 URL 을 호스트 브라우저에서 열어 실습 OpenAI 계정으로 로그인한 뒤
리다이렉트를 기다리거나, 터미널 지시에 따라 코드를 입력합니다.

- 로그인 상태 확인: `codex login status`
- 로그아웃: `codex logout`
- 세션 파일 위치: `~/.codex/`

#### API 키로 쓰고 싶을 때
`.env` 또는 호스트 환경변수에 `OPENAI_API_KEY` 를 설정합니다.
Codex 는 환경변수가 있으면 그것을 우선적으로 사용합니다.

#### 첫 실습 예
```bash
cd /app
codex
# 프롬프트에서:  "app/ 아래에 hello.js 를 만들고 콘솔에 Hello Workshop 을 찍어줘"
```

---

### 5.3 OpenCode

OpenCode 는 **멀티 프로바이더** 에이전트입니다.
Anthropic·OpenAI·OpenRouter·Groq·Google 등 원하는 모델을 골라 쓸 수 있습니다.

#### 인증 설정
컨테이너 안에서:

```bash
opencode auth login
```

대화형 메뉴가 나오면 프로바이더(예: `Anthropic`)를 선택하고, 요구하는
API 키를 붙여 넣습니다. 저장된 키는 `~/.local/share/opencode/` 에 암호화되어
보관됩니다.

실습에서는 **워크숍 당일 제공되는 Claude Code / Codex 계정의 API 키** 중
하나를 재사용해서 OpenCode 의 프로바이더로 등록하면 됩니다.

#### 실행
대화형 TUI 모드:
```bash
opencode
```

한 번만 실행하고 싶다면:
```bash
opencode run "app/ 아래에 README 를 하나 생성해줘"
```

#### 첫 실습 예
```bash
cd /app
opencode
# 메시지 입력:  "app/hello.ts 를 만들고 타입 안전하게 Hello Workshop 을 출력해줘"
```

---

## 6. 세션/로그인 정보가 저장되는 위치

컨테이너는 호스트의 아래 경로들을 bind mount 합니다.
**컨테이너를 삭제·재빌드해도 로그인 상태가 그대로 유지됩니다.**

| 에이전트 | 컨테이너 경로 | 호스트 경로 |
|----------|----------------|-------------|
| Claude Code | `/home/vscode/.claude` | `~/.claude` |
| Codex | `/home/vscode/.codex` | `~/.codex` |
| OpenCode (data) | `/home/vscode/.local/share/opencode` | `~/.local/share/opencode` |
| OpenCode (state) | `/home/vscode/.local/state/opencode` | `~/.local/state/opencode` |
| OpenCode (config) | `/home/vscode/.config/opencode` | `~/.config/opencode` |
| OpenCode (cache) | `/home/vscode/.cache/opencode` | `~/.cache/opencode` |

> Dev Container 를 처음 열 때 `initializeCommand` 가 위 세 개 폴더를
> 호스트에 자동 생성합니다. Compose 를 쓸 때는 [4-Step 3](#step-3-로그인-세션-저장용-디렉터리-준비)
> 에서 직접 만들어 주세요.

---

## 7. 자주 겪는 문제 (FAQ)

**Q1. `postCreateCommand` 에서 `claude --version` 이 실패합니다.**
Node 설치가 덜 끝난 상태에서 도는 경우가 있습니다.
컨테이너 터미널에서 `which claude` 가 비어 있다면
`npm install -g @anthropic-ai/claude-code @openai/codex opencode-ai` 로 재설치하세요.

**Q2. Dev Container 를 열 때 "mount path does not exist" 오류가 납니다.**
호스트에 `~/.claude`, `~/.codex`, `~/.local/share/opencode` 중 하나가 없을 때 발생합니다.
VS Code 를 닫고 아래를 실행한 뒤 다시 여세요.
```bash
mkdir -p ~/.claude ~/.codex ~/.local/share/opencode
```

**Q3. 컨테이너 안에서 로그인 URL 을 브라우저로 못 엽니다.**
컨테이너에는 브라우저가 없습니다. **호스트 브라우저**에 URL 을
복사-붙여넣기로 여는 것이 정상 흐름입니다.

**Q4. API 키를 export 했는데 컨테이너가 못 읽습니다.**
- Dev Container: `export` 후 **같은 쉘에서 `code .`** 로 VS Code 를 띄워야 합니다.
  이미 열려 있던 VS Code 창에는 전달되지 않습니다.
- Compose: `.env` 파일이 프로젝트 루트에 있어야 하며, 값에 따옴표를 씌우지 마세요.

**Q5. 컨테이너를 완전히 초기화하고 싶습니다.**
```bash
docker compose down -v
docker image rm ai-agent-workshop:latest   # 이미지까지 삭제
```
로그인 정보는 호스트 `~/.claude`, `~/.codex`, `~/.local/share/opencode` 에
남아 있으므로, 진짜 리셋하려면 그 폴더들도 비우세요.

**Q7. `opencode auth login` 에서 `EACCES: permission denied, mkdir '/home/vscode/.local/state'` 가 납니다.**
예전 버전 설정으로 만든 컨테이너에 `.local/state/opencode` 마운트/디렉터리가 없어서 생기는
문제입니다. 현재 저장소 설정은 이미 고쳐져 있으므로 아래 순서로 재빌드하세요.

```bash
# 호스트
mkdir -p ~/.config/opencode ~/.cache/opencode \
         ~/.local/share/opencode ~/.local/state/opencode
```

Dev Container: `F1` → `Dev Containers: Rebuild Container`
Compose: `docker compose build --no-cache && docker compose up -d workshop`

이미 뜬 컨테이너에서 즉시 해결하려면 한 번만:
```bash
sudo mkdir -p /home/vscode/.local/state/opencode /home/vscode/.config/opencode /home/vscode/.cache/opencode
sudo chown -R vscode:vscode /home/vscode/.local /home/vscode/.config /home/vscode/.cache
```
다만 컨테이너를 다시 만들 때 같은 문제가 재발하지 않으려면 위 재빌드 경로를 따라야 합니다.

**Q8. 방화벽 환경이라 npm 설치가 실패합니다.**
Dockerfile 의 `npm install -g` 단계가 막힙니다. 사내 npm 프록시가 있다면
Dockerfile 에 `RUN npm config set registry <사내-레지스트리>` 를 추가한 뒤
다시 빌드하세요.

# 🔧 초기 설정 가이드

워크숍을 시작하기 전에 필요한 환경 설정을 안내합니다.

## 📋 준비 체크리스트

- [ ] Claude Code CLI 설치
- [ ] (선택) Codex CLI 설치
- [ ] (선택) OpenCode CLI 설치
- [ ] Node.js / npm 설치 확인
- [ ] Python 3.8+ 설치 확인

---

## 1️⃣ Claude Code 설치 (필수)

### macOS / Linux
```bash
# Homebrew로 설치
brew install anthropic/claude/claude

# 또는 npm으로
npm install -g @anthropic-ai/claude-code-cli

# 버전 확인
claude --version
```

### Windows
```powershell
# Chocolatey로
choco install claude-code-cli

# 또는 npm으로
npm install -g @anthropic-ai/claude-code-cli

# 버전 확인
claude --version
```

### 로그인
```bash
# Claude Code 인증
claude login

# 화면에 나타나는 인증 URL 클릭 후 완료
# 또는 API key 직접 입력
export ANTHROPIC_API_KEY="sk-ant-..."
```

---

## 2️⃣ 환경 설정

### Node.js 확인
```bash
node --version    # v16.0.0 이상
npm --version     # 7.0.0 이상
```

설치 필요 시:
- macOS: `brew install node`
- Windows: https://nodejs.org (LTS 권장)
- Linux: `apt install nodejs npm`

### Python 확인
```bash
python3 --version  # 3.8 이상
pip3 --version
```

설치 필요 시:
- macOS: `brew install python3`
- Windows: https://www.python.org
- Linux: `apt install python3 python3-pip`

---

## 3️⃣ 자동 설정 스크립트 실행

### 일반 설정
```bash
cd /path/to/workshop-elementary
bash scripts/setup.sh
```

이 스크립트가 다음을 수행합니다:
1. Node.js / Python 버전 확인
2. 기본 패키지 설치 (필요 시)
3. 기본 CLAUDE.md 생성
4. git 저장소 초기화
5. 환경 변수 설정

### 출력 예시
```
✅ Node.js v18.0.0 확인됨
✅ Python 3.10.0 확인됨
✅ claude CLI 설치됨
✅ CLAUDE.md 생성됨
✅ 셋업 완료!

다음 단계:
  cd practice-1-pokemon-card
  cat PROMPT.md
```

---

## 4️⃣ 선택 사항: Codex 설정

### 설치
```bash
# OpenAI API 키 필요
curl -fsSL https://codex.openai.com/install.sh | bash

# 또는 npm으로
npm install -g openai-codex-cli

# 로그인
codex login
```

### 확인
```bash
codex --version
```

---

## 5️⃣ 선택 사항: OpenCode 설정

### 설치
```bash
# 공식 설치
curl https://opencode.ai/install | bash

# 또는 Docker
docker pull openai/opencode:latest
```

### 로그인
```bash
opencode login
# OpenCode 대시보드: https://opencode.ai/console
```

---

## 6️⃣ 폴더 구조 확인

설정 완료 후 다음 구조가 있어야 합니다:

```
workshop-elementary/
├── README.md                          # ✅ 전체 가이드
├── SETUP.md                           # ✅ 이 파일
├── scripts/
│   ├── setup.sh                       # 자동 설정 스크립트
│   ├── ralph-loop.sh                  # Ralph 루프 예제
│   ├── codex-setup.sh                 # Codex 설정
│   └── opencode-setup.sh              # OpenCode 설정
├── configs/
│   ├── CLAUDE.md                      # 프로젝트 CLAUDE.md
│   ├── AGENTS.md                      # 프로젝트 AGENTS.md
│   ├── DESIGN.md                      # 디자인 토큰
│   └── opencode-config.json           # OpenCode 설정
├── practice-1-pokemon-card/
│   ├── README.md
│   ├── PROMPT.md
│   ├── CLAUDE.md
│   └── checklist.md
├── practice-2-design-md/
│   ├── README.md
│   ├── PROMPT.md
│   ├── CLAUDE.md
│   └── checklist.md
├── practice-3-ralph-harness/
│   ├── README.md
│   ├── PROMPT.md
│   ├── CLAUDE.md
│   ├── fix_plan.md.template
│   └── checklist.md
├── practice-4-claude-codex/
│   ├── README.md
│   ├── PROMPT.md
│   ├── CLAUDE.md
│   └── checklist.md
└── practice-5-opencode-agent/
    ├── README.md
    ├── PROMPT.md
    ├── CLAUDE.md
    ├── mission.md.template
    └── checklist.md
```

확인:
```bash
# 모든 폴더 구조 표시
tree -L 3 .

# 또는
find . -type f -name "README.md" | wc -l  # 7개 나와야 함
```

---

## 7️⃣ Claude Code 설정 최적화

### 추천 설정
```bash
# VS Code Extensions (Claude Code 플러그인)
# - Anthropic Claude
# - Claude Code
# - (선택) REST Client

# ~/.claude/settings.json 기본값
{
  "model": "claude-opus-4-7",
  "temperature": 0.7,
  "max_tokens": 4096,
  "thinking_enabled": true
}
```

### 단축키 설정
```bash
# ~/.claude/keybindings.json
{
  "submit": "Cmd+Enter",          // macOS
  "plan_mode": "Shift+Tab",       // Plan 모드 진입
  "abort": "Cmd+.",               // 현재 작업 중단
  "clear": "Cmd+K"                // 대화 초기화
}
```

---

## 8️⃣ 환경 변수 설정 (선택)

프로젝트 폴더에 `.env` 파일 생성 (git 커밋 금지):

```bash
# .env.example 복사
cp .env.example .env

# 내용 편집
cat > .env << 'EOF'
# Claude Code
ANTHROPIC_API_KEY=sk-ant-...

# Codex (선택)
OPENAI_API_KEY=sk-...

# OpenCode (선택)
OPENCODE_API_KEY=...

# 프로젝트 설정
PROJECT_NAME=workshop-elementary
MAX_TOKENS=4096
EOF
```

### 환경 변수 로드
```bash
# zsh/bash
source .env

# fish
set -a (cat .env | grep -v '^#')
```

---

## 9️⃣ 문제 해결

### "claude: command not found"
```bash
# PATH 확인
echo $PATH | grep claude

# 수동 추가 (if needed)
export PATH="$HOME/.local/bin:$PATH"

# 또는 전체 경로로 실행
/usr/local/bin/claude --version
```

### "Python not found"
```bash
# Python 설치 확인
which python3

# 심링크 생성
ln -s /usr/bin/python3 /usr/local/bin/python
```

### "Node.js version too old"
```bash
# nvm으로 업그레이드
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 18
nvm use 18
```

### "Permission denied" on scripts
```bash
# 실행 권한 추가
chmod +x scripts/*.sh

# 그 후 실행
bash scripts/setup.sh
```

---

## 🔟 시작하기

모든 설정이 완료되었으면:

```bash
# 1. 첫 번째 실습 폴더로 이동
cd practice-1-pokemon-card

# 2. 실습 개요 읽기
cat README.md

# 3. 시작 프롬프트 확인
cat PROMPT.md

# 4. Claude Code 실행
claude

# 5. PROMPT.md 내용을 복사해서 Claude에 붙이기
# (Cmd+V 또는 Ctrl+V)
```

---

## 📞 도움이 필요한 경우

| 문제 | 해결책 |
|---|---|
| Claude 로그인 오류 | `claude logout` 후 다시 로그인 |
| API 키 만료 | https://claude.ai/settings 에서 재생성 |
| 네트워크 오류 | VPN 확인, 프록시 설정 검토 |
| 파일 생성 오류 | 폴더 권한 확인: `chmod 755 .` |

---

## ✅ 설정 완료 확인

모든 설정이 완료되었으면:

```bash
# 최종 확인
bash scripts/setup.sh --verify

# 출력 예시:
# ✅ Node.js: v18.0.0
# ✅ Python: 3.10.0
# ✅ claude: installed
# ✅ All files present
# 🎉 Setup complete!
```

---

**준비가 되셨으면 [README.md](./README.md)로 돌아가서 실습을 시작하세요!**

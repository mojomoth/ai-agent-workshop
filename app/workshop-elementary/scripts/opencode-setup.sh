#!/bin/bash
# opencode-setup.sh - OpenCode Go 설치 및 설정 (Practice 5용)

set -e

echo "🚀 OpenCode Go 설정 스크립트"
echo ""

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Step 1: OpenCode Go 설치 확인
echo "${BLUE}Step 1: OpenCode Go 설치 확인${NC}"
echo ""

if command -v opencode &> /dev/null; then
  echo -e "${GREEN}✅ OpenCode가 이미 설치됨${NC}"
  opencode --version
  echo ""
else
  echo -e "${YELLOW}⚠️  OpenCode가 설치되지 않았습니다${NC}"
  echo ""
  echo "설치 방법 (권장순):"
  echo ""
  echo "1️⃣  Homebrew (macOS):"
  echo "   brew install opencode"
  echo ""
  echo "2️⃣  Direct Download:"
  echo "   https://opencode.ai/download"
  echo ""
  echo "3️⃣  npm:"
  echo "   npm install -g @opencode/cli"
  echo ""
  echo "4️⃣  Docker:"
  echo "   docker pull opencode/go:latest"
  echo ""
  echo "설치 후 다시 실행하세요."
  exit 1
fi

# Step 2: 계정 확인 및 로그인
echo "${BLUE}Step 2: OpenCode 계정 확인${NC}"
echo ""

if opencode auth status &>/dev/null; then
  echo -e "${GREEN}✅ OpenCode에 로그인됨${NC}"
  opencode auth status
else
  echo -e "${YELLOW}⚠️  OpenCode에 로그인되지 않음${NC}"
  echo ""
  echo "로그인 방법:"
  echo "  opencode auth login"
  echo ""
  echo "또는 API 키로 로그인:"
  echo "  export OPENCODE_API_KEY='oc_...'"
  echo ""
  echo "로그인 후 다시 실행하세요."
  exit 1
fi

echo ""

# Step 3: 모델 확인
echo "${BLUE}Step 3: 사용 가능한 모델 확인${NC}"
echo ""

echo "OpenCode Go에서 사용 가능한 모델:"
echo ""
echo "비싼 모델 (Manager 용):"
echo "  • opencode-go/glm-5.1"
echo "  • opencode-go/claude-opus"
echo ""
echo "싼 모델 (Worker 용):"
echo "  • opencode-go/kimi-k2.5"
echo "  • opencode-go/qwen3.5-plus"
echo "  • opencode-go/mimo-v2.5-pro"
echo "  • opencode-go/glm-5"
echo ""

# 실제 모델 확인 시도
echo "사용 가능한 모델 조회 중..."
if opencode models list 2>/dev/null | head -20; then
  echo "✅ 모델 조회 성공"
else
  echo "⚠️  모델 조회 실패 (계정 구성에 따라 다를 수 있음)"
fi

echo ""

# Step 4: opencode-config.json 생성
echo "${BLUE}Step 4: opencode-config.json 생성${NC}"
echo ""

PRACTICE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../practice-5-opencode-agent" && pwd)"
CONFIG_FILE="$PRACTICE_DIR/opencode-config.json"

if [ -f "$CONFIG_FILE" ]; then
  echo -e "${YELLOW}⚠️  opencode-config.json이 이미 있습니다${NC}"
  echo "   $CONFIG_FILE"
  echo ""
  echo "기존 파일을 덮어쓸까요? (y/n)"
  read -r response
  if [ "$response" != "y" ]; then
    echo "⏭️  스킵"
    SKIP_CONFIG=1
  fi
fi

if [ "$SKIP_CONFIG" != "1" ]; then
  cat > "$CONFIG_FILE" << 'EOF'
{
  "name": "AI News Crawler",
  "description": "Parallel AI news crawler using OpenCode Go",
  "agents": {
    "manager": {
      "model": "opencode-go/glm-5.1",
      "role": "Orchestrate crawler, summarizer, and notifier agents. Make decisions and validate results.",
      "temperature": 0.7,
      "max_tokens": 2000,
      "permissions": {
        "read": ["all"],
        "write": ["mission.md"]
      }
    },
    "crawler": {
      "model": "opencode-go/kimi-k2.5",
      "role": "Collect AI news from HackerNews, Reddit, and Arxiv. Return JSON format with title, url, score.",
      "temperature": 0.5,
      "max_tokens": 1500,
      "permissions": {
        "read": ["external_apis"],
        "write": false,
        "endpoints": {
          "allowed": [
            "https://news.ycombinator.com",
            "https://reddit.com/r/MachineLearning",
            "https://arxiv.org"
          ]
        }
      }
    },
    "scheduler": {
      "model": "opencode-go/qwen3.5-plus",
      "role": "Determine next crawl time and manage rate limiting.",
      "temperature": 0.3,
      "max_tokens": 500,
      "permissions": {
        "read": ["all"],
        "write": ["mission.md", "schedule.json"]
      }
    },
    "summarizer": {
      "model": "opencode-go/mimo-v2.5-pro",
      "role": "Summarize collected news to 200 Korean characters. Add hashtags.",
      "temperature": 0.7,
      "max_tokens": 1000,
      "permissions": {
        "read": ["all"],
        "write": false,
        "network": false
      }
    },
    "notifier": {
      "model": "opencode-go/glm-5",
      "role": "Send summarized news to Slack #ai-news channel.",
      "temperature": 0.5,
      "max_tokens": 800,
      "permissions": {
        "read": ["all"],
        "write": true,
        "endpoints": {
          "allowed": ["https://hooks.slack.com/services/*"],
          "denied": ["*"]
        }
      }
    }
  },
  "execution": {
    "parallelism": 5,
    "max_concurrent_tasks": 3,
    "timeout_per_task": 60,
    "retry_attempts": 2,
    "loop_until": "ALL_ROUND_COMPLETED"
  }
}
EOF

  echo -e "${GREEN}✅ opencode-config.json 생성됨${NC}"
  echo "   $CONFIG_FILE"
fi

echo ""

# Step 5: 슬랙 통합 설정 (선택)
echo "${BLUE}Step 5: Slack 통합 설정 (선택)${NC}"
echo ""

echo "Notifier가 Slack에 메시지를 보내려면 Webhook URL이 필요합니다."
echo ""
echo "Slack Webhook 생성:"
echo "  1. https://api.slack.com/apps에 가기"
echo "  2. 'Create New App' → 'From scratch'"
echo "  3. App name: 'AI News Bot', Workspace 선택"
echo "  4. 좌측 'Incoming Webhooks' 클릭"
echo "  5. 'Add New Webhook to Workspace' 클릭"
echo "  6. 채널 선택 (예: #ai-news)"
echo "  7. Webhook URL 복사"
echo ""
echo "Webhook URL을 환경 변수로 설정:"
echo "  export SLACK_WEBHOOK_URL='https://hooks.slack.com/services/...'"
echo ""
echo "또는 opencode-config.json에 직접 추가:"
echo "  \"slack_webhook_url\": \"https://hooks.slack.com/services/...\""
echo ""

read -p "Slack 통합을 설정했나요? (y/n) " response

if [ "$response" = "y" ]; then
  if [ -z "$SLACK_WEBHOOK_URL" ]; then
    echo "⚠️  SLACK_WEBHOOK_URL 환경 변수가 설정되지 않았습니다"
    echo "위의 설정 단계를 따르세요"
  else
    echo -e "${GREEN}✅ Slack 통합 준비 완료${NC}"
  fi
fi

echo ""

# Step 6: 비용 확인
echo "${BLUE}Step 6: 예상 비용 계산${NC}"
echo ""

echo "OpenCode Go 모델별 가격 (1000 토큰당, 추정):"
echo ""
echo "Manager:"
echo "  GLM-5.1: ~\$0.002/call"
echo ""
echo "Workers (각각):"
echo "  Kimi-K2.5: ~\$0.0005/call"
echo "  Qwen-3.5: ~\$0.0003/call"
echo "  Mimo-V2.5: ~\$0.0003/call"
echo "  GLM-5: ~\$0.0002/call"
echo ""
echo "1 라운드 예상 비용: ~\$0.002 (약 2원)"
echo "5 라운드 예상 비용: ~\$0.01 (약 10원)"
echo ""
echo "자세한 가격은: https://opencode.ai/pricing"
echo ""

# Step 7: Practice 5 준비
echo "${BLUE}Step 7: Practice 5 준비${NC}"
echo ""

if [ -d "$PRACTICE_DIR" ]; then
  echo -e "${GREEN}✅ Practice 5 디렉토리 확인됨${NC}"
  echo "   $PRACTICE_DIR"
  echo ""
  echo "이제 Practice 5를 시작할 수 있습니다!"
  echo ""
  echo "시작하려면:"
  echo "  cd $PRACTICE_DIR"
  echo "  cat README.md"
else
  echo -e "${RED}❌ Practice 5 디렉토리를 찾을 수 없습니다${NC}"
  exit 1
fi

echo ""

# Step 8: 사용 예제
echo "${BLUE}Step 8: 실행 명령어${NC}"
echo ""

echo "Manager를 통해 크롤러 시작:"
echo "  opencode run --config opencode-config.json --agent manager"
echo ""
echo "또는 전체 파이프라인:"
echo "  opencode run \\
  --config opencode-config.json \\
  --agent manager \\
  --mission mission.md \\
  --loop-until 'ALL_ROUND_COMPLETED'"
echo ""

# 완료
echo "=== ${GREEN}✅ OpenCode Go 설정 완료!${NC} ==="
echo ""
echo "다음을 실행해서 Practice 5를 시작하세요:"
echo "  cd $PRACTICE_DIR"
echo "  cat PROMPT.md"
echo ""

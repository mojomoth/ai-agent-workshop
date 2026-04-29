#!/bin/bash
# codex-setup.sh - Codex CLI 설치 및 설정 (Practice 4용)

set -e

echo "🔧 Codex 설정 스크립트"
echo ""

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Step 1: Codex 설치 확인
echo "${BLUE}Step 1: Codex 설치 확인${NC}"
echo ""

if command -v codex &> /dev/null; then
  echo -e "${GREEN}✅ Codex가 이미 설치됨${NC}"
  codex --version
  echo ""
else
  echo -e "${YELLOW}⚠️  Codex가 설치되지 않았습니다${NC}"
  echo ""
  echo "Codex 설치 방법:"
  echo ""
  echo "옵션 1: npm으로 설치"
  echo "  npm install -g @openai/codex-cli"
  echo ""
  echo "옵션 2: 직접 다운로드"
  echo "  https://github.com/openai/codex-cli/releases"
  echo ""
  echo "옵션 3: Claude plugin으로 사용"
  echo "  /plugin install codex"
  echo ""
  echo "설치 후 다시 실행하세요."
  exit 1
fi

# Step 2: API 키 확인
echo "${BLUE}Step 2: OpenAI API 키 확인${NC}"
echo ""

if [ -z "$OPENAI_API_KEY" ]; then
  echo -e "${YELLOW}⚠️  OPENAI_API_KEY 환경 변수가 설정되지 않음${NC}"
  echo ""
  echo "설정 방법:"
  echo "  export OPENAI_API_KEY='sk-...'"
  echo ""
  echo "또는 .env 파일에 추가:"
  echo "  OPENAI_API_KEY=sk-..."
  echo ""
  echo "설정 후 다시 실행하세요."
  exit 1
else
  echo -e "${GREEN}✅ OPENAI_API_KEY 설정됨${NC}"
  # 마스킹해서 일부만 표시
  MASKED_KEY="${OPENAI_API_KEY:0:20}...${OPENAI_API_KEY: -4}"
  echo "   $MASKED_KEY"
fi

echo ""

# Step 3: 연결 테스트
echo "${BLUE}Step 3: Codex 연결 테스트${NC}"
echo ""

echo "간단한 코드 리뷰 요청을 테스트하는 중..."
echo ""

TEST_CODE="function add(a, b) {
  return a + b;
}"

# Codex를 통해 간단한 리뷰 요청
echo "테스트 코드:"
echo "$TEST_CODE"
echo ""

echo "Codex에 보내는 중..."

# 실제 호출 (타임아웃 설정)
if timeout 30 codex exec "다음 함수를 리뷰하세요:

\`\`\`javascript
$TEST_CODE
\`\`\`

개선 사항을 제안하세요." 2>/dev/null; then
  echo -e "${GREEN}✅ Codex 연결 성공${NC}"
else
  echo -e "${RED}❌ Codex 연결 실패${NC}"
  echo "API 키를 확인하거나 네트워크 연결을 확인하세요"
  exit 1
fi

echo ""

# Step 4: 설정 최적화
echo "${BLUE}Step 4: Codex 설정 최적화${NC}"
echo ""

echo "권장 환경 변수:"
echo ""
echo "export CODEX_MODEL='gpt-4'              # 더 정확한 결과"
echo "export CODEX_TEMPERATURE=0.3            # 일관성 있는 리뷰"
echo "export CODEX_MAX_TOKENS=2000            # 길이 제한"
echo ""

# 사용자에게 설정 제안
echo "위 변수를 ~/.bashrc 또는 ~/.zshrc에 추가할까요? (y/n)"
read -r response

if [ "$response" = "y" ]; then
  # bash RC 파일 결정
  if [ -f ~/.zshrc ]; then
    RC_FILE="$HOME/.zshrc"
  else
    RC_FILE="$HOME/.bashrc"
  fi

  # 이미 있는지 확인
  if ! grep -q "CODEX_MODEL" "$RC_FILE"; then
    echo "" >> "$RC_FILE"
    echo "# Codex configuration" >> "$RC_FILE"
    echo "export CODEX_MODEL='gpt-4'" >> "$RC_FILE"
    echo "export CODEX_TEMPERATURE=0.3" >> "$RC_FILE"
    echo "export CODEX_MAX_TOKENS=2000" >> "$RC_FILE"
    echo -e "${GREEN}✅ 설정을 $RC_FILE에 추가했습니다${NC}"
  else
    echo -e "${YELLOW}⚠️  이미 설정이 있습니다${NC}"
  fi
fi

echo ""

# Step 5: 사용 가이드
echo "${BLUE}Step 5: Codex 사용 가이드${NC}"
echo ""

echo "Practice 4에서 사용할 명령어:"
echo ""
echo "1️⃣  Claude가 구현한 코드 리뷰:"
echo "   codex exec \"다음 코드를 보안 관점에서 리뷰하세요:\""
echo ""
echo "2️⃣  파일 리뷰:"
echo "   codex exec \"\$(cat file.ts) - 성능 문제 찾기\""
echo ""
echo "3️⃣  개선 제안:"
echo "   codex exec \"... 개선 방안은?\""
echo ""

echo ""

# Step 6: Practice 4 준비
echo "${BLUE}Step 6: Practice 4 준비${NC}"
echo ""

PRACTICE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../practice-4-claude-codex" && pwd)"

if [ -d "$PRACTICE_DIR" ]; then
  echo -e "${GREEN}✅ Practice 4 디렉토리 확인됨${NC}"
  echo "   $PRACTICE_DIR"
  echo ""
  echo "이제 Practice 4를 시작할 수 있습니다!"
  echo ""
  echo "시작하려면:"
  echo "  cd $PRACTICE_DIR"
  echo "  cat README.md"
else
  echo -e "${RED}❌ Practice 4 디렉토리를 찾을 수 없습니다${NC}"
fi

echo ""

# 완료
echo "=== ${GREEN}✅ Codex 설정 완료!${NC} ==="
echo ""
echo "다음을 실행해서 Practice 4를 시작하세요:"
echo "  cd $PRACTICE_DIR"
echo "  cat PROMPT.md"
echo ""

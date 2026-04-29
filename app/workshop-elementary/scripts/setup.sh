#!/bin/bash
# setup.sh - 전체 workshop-elementary 환경 설정

set -e  # 에러 시 즉시 종료

echo "=== AI Agent Workshop - 환경 설정 ==="
echo ""

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: 필수 도구 확인
echo "📋 Step 1: 필수 도구 확인..."
echo ""

check_command() {
  if command -v $1 &> /dev/null; then
    echo -e "${GREEN}✅ $1${NC} 설치됨"
    $1 --version 2>/dev/null | head -n1
  else
    echo -e "${RED}❌ $1${NC} 설치되지 않음"
    return 1
  fi
}

MISSING=0

check_command "claude" || MISSING=1
check_command "node" || MISSING=1
check_command "npm" || MISSING=1
check_command "git" || MISSING=1

echo ""

if [ $MISSING -eq 1 ]; then
  echo -e "${YELLOW}⚠️  일부 도구가 설치되지 않았습니다.${NC}"
  echo "설치 가이드:"
  echo "  • Claude Code: https://claude.com/claude-code"
  echo "  • Node.js: https://nodejs.org"
  echo "  • Git: https://git-scm.com"
  exit 1
fi

# Step 2: 선택 도구 확인 (선택사항)
echo "🔍 Step 2: 선택 도구 확인..."
echo ""

echo -n "Codex 설치 확인... "
if command -v codex &> /dev/null; then
  echo -e "${GREEN}✅${NC}"
else
  echo -e "${YELLOW}⚠️  선택 (나중에 설치 가능)${NC}"
fi

echo -n "OpenCode 설치 확인... "
if command -v opencode &> /dev/null; then
  echo -e "${GREEN}✅${NC}"
else
  echo -e "${YELLOW}⚠️  선택 (나중에 설치 가능)${NC}"
fi

echo ""

# Step 3: 프로젝트 디렉토리 구조 생성
echo "📁 Step 3: 프로젝트 구조 확인..."
echo ""

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
WORKSHOP_DIR="$PROJECT_ROOT/workshop-elementary"

echo "프로젝트 루트: $PROJECT_ROOT"
echo "워크숍 디렉토리: $WORKSHOP_DIR"
echo ""

# Step 4: Node.js 환경 설정 (선택)
echo "📦 Step 4: Node.js 환경 설정..."
echo ""

if [ -f "$WORKSHOP_DIR/package.json" ]; then
  echo "이미 package.json이 있습니다."
  echo "npm install을 실행할까요? (y/n)"
  read -r response
  if [ "$response" = "y" ]; then
    cd "$WORKSHOP_DIR" && npm install
    echo -e "${GREEN}✅ npm install 완료${NC}"
  fi
else
  echo "package.json 생성? (y/n)"
  read -r response
  if [ "$response" = "y" ]; then
    cd "$WORKSHOP_DIR"
    npm init -y
    npm install vite --save-dev
    echo -e "${GREEN}✅ package.json 생성 및 의존성 설치 완료${NC}"
  fi
fi

echo ""

# Step 5: 각 실습 폴더 최종 확인
echo "✅ Step 5: 실습 폴더 최종 확인..."
echo ""

for dir in practice-1-pokemon-card practice-2-design-md practice-3-ralph-harness practice-4-claude-codex practice-5-opencode-agent; do
  if [ -d "$WORKSHOP_DIR/$dir" ]; then
    echo -e "${GREEN}✅ $dir${NC}"
  else
    echo -e "${RED}❌ $dir${NC} (누락됨)"
  fi
done

echo ""

# Step 6: 설정 파일 확인
echo "⚙️  Step 6: 설정 파일 확인..."
echo ""

if [ -f "$WORKSHOP_DIR/CLAUDE.md" ]; then
  echo -e "${GREEN}✅ CLAUDE.md${NC}"
else
  echo -e "${YELLOW}⚠️  CLAUDE.md 없음${NC}"
fi

if [ -f "$WORKSHOP_DIR/SETUP.md" ]; then
  echo -e "${GREEN}✅ SETUP.md${NC}"
else
  echo -e "${YELLOW}⚠️  SETUP.md 없음${NC}"
fi

echo ""

# Step 7: 다음 단계 안내
echo "🎓 Step 7: 다음 단계..."
echo ""
echo "1️⃣  Practice 1 시작:"
echo "   cd $WORKSHOP_DIR/practice-1-pokemon-card"
echo "   cat PROMPT.md"
echo ""
echo "2️⃣  Claude 활성화:"
echo "   claude -p '\$(cat PROMPT.md)'"
echo ""
echo "3️⃣  Plan Mode 진입:"
echo "   [Shift+Tab]을 눌러 Plan Mode 진입"
echo ""
echo "4️⃣  진행 확인:"
echo "   cat checklist.md"
echo ""

# Step 8: 환경 변수 (선택)
echo "🔑 Step 8: 환경 변수 설정 (선택)..."
echo ""

if [ -f "$WORKSHOP_DIR/.env.example" ]; then
  if [ ! -f "$WORKSHOP_DIR/.env" ]; then
    echo ".env 파일 생성? (y/n)"
    read -r response
    if [ "$response" = "y" ]; then
      cp "$WORKSHOP_DIR/.env.example" "$WORKSHOP_DIR/.env"
      echo -e "${GREEN}✅ .env 파일 생성됨${NC}"
      echo "   필요시 .env를 편집하세요"
    fi
  fi
fi

echo ""

# 완료
echo "=== ✅ 환경 설정 완료! ==="
echo ""
echo "이제 연습을 시작할 준비가 되었습니다."
echo "README.md를 읽고 Practice 1부터 시작하세요!"
echo ""

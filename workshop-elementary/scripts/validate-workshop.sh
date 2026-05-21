#!/bin/bash

##############################################################################
# Workshop Validation Script
#
# Purpose: Verify workshop structure and readiness before execution
# Usage: bash scripts/validate-workshop.sh
#
# Checks:
# 1. Directory structure
# 2. Required files in each practice
# 3. File permissions (executable scripts)
# 4. Content validation
# 5. Dependencies availability
##############################################################################

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
WORKSHOP_DIR="."
REQUIRED_PRACTICES=5
EXIT_CODE=0

##############################################################################
# Helper Functions
##############################################################################

print_header() {
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${CYAN}$1${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_success() {
  echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
  echo -e "${RED}❌ $1${NC}"
  EXIT_CODE=1
}

print_warning() {
  echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
  echo -e "${CYAN}ℹ️  $1${NC}"
}

##############################################################################
# Validation Functions
##############################################################################

validate_directory_structure() {
  print_header "1️⃣  Directory Structure Validation"
  echo ""

  # Check root level files
  local required_files=("README.md" "SETUP.md")
  for file in "${required_files[@]}"; do
    if [ -f "$WORKSHOP_DIR/$file" ]; then
      print_success "$file exists"
    else
      print_error "$file missing"
    fi
  done
  echo ""

  # Check subdirectories
  local required_dirs=("configs" "scripts")
  for dir in "${required_dirs[@]}"; do
    if [ -d "$WORKSHOP_DIR/$dir" ]; then
      print_success "$dir/ exists"
    else
      print_error "$dir/ missing"
    fi
  done
  echo ""
}

validate_practices() {
  print_header "2️⃣  Practices Validation"
  echo ""

  local found_practices=0

  for practice_dir in "$WORKSHOP_DIR"/practice-*; do
    if [ -d "$practice_dir" ]; then
      practice_name=$(basename "$practice_dir")
      found_practices=$((found_practices + 1))

      echo -e "${CYAN}$practice_name${NC}"

      # Check required files
      local required_files=("README.md" "PROMPT.md" "CLAUDE.md" "checklist.md")
      local missing=0

      for file in "${required_files[@]}"; do
        if [ -f "$practice_dir/$file" ]; then
          echo "  ✓ $file"
        else
          echo -e "  ${RED}✗ $file${NC}"
          missing=$((missing + 1))
        fi
      done

      # Check for optional files
      if [ -f "$practice_dir/hooks.json" ]; then
        echo "  + hooks.json (optional)"
      fi
      if [ -f "$practice_dir/ralph-loop.sh" ]; then
        echo "  + ralph-loop.sh (optional, executable: $([ -x $practice_dir/ralph-loop.sh ] && echo 'yes' || echo 'no'))"
      fi
      if [ -f "$practice_dir/task-tracker.sh" ]; then
        echo "  + task-tracker.sh (optional, executable: $([ -x $practice_dir/task-tracker.sh ] && echo 'yes' || echo 'no'))"
      fi
      if [ -f "$practice_dir/fix_plan.md.template" ]; then
        echo "  + fix_plan.md.template (optional)"
      fi
      if [ -f "$practice_dir/mission.md.template" ]; then
        echo "  + mission.md.template (optional)"
      fi

      if [ $missing -gt 0 ]; then
        print_error "$practice_name: $missing required files missing"
      else
        print_success "$practice_name: all required files present"
      fi
      echo ""
    fi
  done

  if [ $found_practices -ne $REQUIRED_PRACTICES ]; then
    print_warning "Found $found_practices practices, expected $REQUIRED_PRACTICES"
  else
    print_success "Found all $REQUIRED_PRACTICES practices"
  fi
  echo ""
}

validate_file_permissions() {
  print_header "3️⃣  File Permissions Validation"
  echo ""

  # Check script executability
  local scripts_to_check=(
    "scripts/setup.sh"
    "scripts/ralph-loop.sh"
    "scripts/codex-setup.sh"
    "scripts/opencode-setup.sh"
    "practice-3-ralph-harness/ralph-loop.sh"
    "practice-3-ralph-harness/task-tracker.sh"
  )

  for script in "${scripts_to_check[@]}"; do
    if [ -f "$WORKSHOP_DIR/$script" ]; then
      if [ -x "$WORKSHOP_DIR/$script" ]; then
        print_success "$script is executable"
      else
        print_warning "$script exists but is not executable"
        print_info "To fix: chmod +x $script"
      fi
    fi
  done
  echo ""
}

validate_content() {
  print_header "4️⃣  Content Validation"
  echo ""

  # Check that key files contain expected content
  local checks=(
    "README.md:Claude Code"
    "SETUP.md:Claude Code"
    "practice-1-pokemon-card/README.md:포켓몬"
    "practice-2-design-md/README.md:DESIGN.md"
    "practice-3-ralph-harness/README.md:Ralph"
    "practice-3-ralph-harness/PROMPT.md:속담"
    "practice-4-claude-codex/README.md:Codex"
    "practice-5-opencode-agent/README.md:OpenCode"
  )

  for check in "${checks[@]}"; do
    file="${check%:*}"
    keyword="${check#*:}"

    if [ -f "$WORKSHOP_DIR/$file" ]; then
      if grep -q "$keyword" "$WORKSHOP_DIR/$file"; then
        print_success "$file contains keyword '$keyword'"
      else
        print_warning "$file does not contain keyword '$keyword'"
      fi
    else
      print_warning "$file does not exist"
    fi
  done
  echo ""
}

validate_dependencies() {
  print_header "5️⃣  Dependencies Validation"
  echo ""

  # Check for Claude CLI
  if command -v claude &> /dev/null; then
    version=$(claude --version 2>/dev/null || echo "unknown")
    print_success "Claude CLI is installed ($version)"
  else
    print_warning "Claude CLI is not installed (required for practice execution)"
    print_info "Install: brew install anthropic/claude/claude"
  fi

  # Check for Node.js
  if command -v node &> /dev/null; then
    version=$(node --version)
    print_success "Node.js is installed ($version)"
  else
    print_warning "Node.js is not installed (may be needed for some practices)"
  fi

  # Check for Python
  if command -v python3 &> /dev/null; then
    version=$(python3 --version)
    print_success "Python3 is installed ($version)"
  else
    print_warning "Python3 is not installed (may be needed for some practices)"
  fi

  # Check for git
  if command -v git &> /dev/null; then
    version=$(git --version)
    print_success "Git is installed ($version)"
  else
    print_warning "Git is not installed"
  fi

  echo ""
}

validate_file_sizes() {
  print_header "6️⃣  File Size Validation"
  echo ""

  echo "Documentation files:"
  find "$WORKSHOP_DIR" -type f -name "*.md" | while read file; do
    lines=$(wc -l < "$file")
    size=$(du -h "$file" | cut -f1)
    printf "  %-50s %5s lines  %s\n" "$(basename "$file")" "$lines" "$size"
  done

  echo ""
  echo "Script files:"
  find "$WORKSHOP_DIR" -type f -name "*.sh" | while read file; do
    lines=$(wc -l < "$file")
    size=$(du -h "$file" | cut -f1)
    printf "  %-50s %5s lines  %s\n" "$(basename "$file")" "$lines" "$size"
  done

  echo ""
}

print_summary() {
  print_header "📊 Validation Summary"
  echo ""

  # Count files
  total_md=$(find "$WORKSHOP_DIR" -type f -name "*.md" | wc -l)
  total_sh=$(find "$WORKSHOP_DIR" -type f -name "*.sh" | wc -l)
  total_json=$(find "$WORKSHOP_DIR" -type f -name "*.json" | wc -l)
  total_lines=$(find "$WORKSHOP_DIR" -type f \( -name "*.md" -o -name "*.sh" -o -name "*.json" \) -exec wc -l {} + | tail -1 | awk '{print $1}')

  echo "Documentation Files: $total_md"
  echo "Script Files: $total_sh"
  echo "Config Files: $total_json"
  echo "Total Lines: $total_lines"
  echo ""

  if [ $EXIT_CODE -eq 0 ]; then
    print_success "Workshop validation passed!"
    echo ""
    echo "Next steps:"
    echo "  1. Review each practice: cat practice-N-*/README.md"
    echo "  2. Run setup: bash scripts/setup.sh"
    echo "  3. Start Practice 1: cd practice-1-pokemon-card && cat PROMPT.md"
  else
    print_warning "Workshop validation found issues above"
    echo ""
    echo "Please fix the issues marked with ❌"
  fi
  echo ""
}

##############################################################################
# Main Execution
##############################################################################

main() {
  print_header "🔍 Workshop Validation Suite"
  echo ""

  validate_directory_structure
  validate_practices
  validate_file_permissions
  validate_content
  validate_dependencies
  validate_file_sizes
  print_summary

  exit $EXIT_CODE
}

# Run main function
main "$@"

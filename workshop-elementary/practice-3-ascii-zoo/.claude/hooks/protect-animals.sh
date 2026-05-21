#!/usr/bin/env bash
#
# protect-animals.sh — PreToolUse hook (Edit|Write).
#
# Belt-and-suspenders alongside settings.json's deny rules.
# Refuses any attempt to MODIFY an existing animals/*.txt file.
# Creating a NEW one is fine.
#
# Reads tool input as JSON on stdin; we look for a file_path.
#
# Exit codes (PreToolUse hook contract):
#   0  → allow tool call
#   2  → block tool call; stderr is shown to Claude as the reason
#

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Read all stdin into a variable. Claude Code passes hook input as JSON.
input="$(cat || true)"

# Pull out the file_path. Try jq first, fall back to a grep heuristic.
file_path=""
if command -v jq >/dev/null 2>&1; then
  file_path="$(printf '%s' "$input" | jq -r '.tool_input.file_path // empty' 2>/dev/null || true)"
fi
if [[ -z "$file_path" ]]; then
  file_path="$(printf '%s' "$input" \
    | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' \
    | head -n1 \
    | sed 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')"
fi

# Nothing to check.
if [[ -z "$file_path" ]]; then
  exit 0
fi

# Normalize: strip project root prefix if present.
rel="${file_path#$PROJECT_ROOT/}"

# Only care about animals/*.txt
case "$rel" in
  animals/*.txt) ;;
  *) exit 0 ;;
esac

# If the file already exists and is non-empty, block modification.
if [[ -s "$PROJECT_ROOT/$rel" ]]; then
  {
    echo "🛑 Blocked: '$rel' already exists and is finished."
    echo ""
    echo "Once an animal is in the zoo, it stays. No edits, no overwrites."
    echo "Move on to the next animal in the TODO list."
  } >&2
  exit 2
fi

exit 0

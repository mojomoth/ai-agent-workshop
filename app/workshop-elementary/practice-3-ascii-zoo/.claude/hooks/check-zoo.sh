#!/usr/bin/env bash
#
# check-zoo.sh — Stop hook for the Ralph loop.
#
# This is THE core mechanism of the Ralph technique: when Claude tries
# to stop, this hook intercepts and forces it to keep going if the
# zoo isn't complete yet.
#
# Exit codes (Claude Code Stop hook contract):
#   0  → allow stop
#   2  → block stop; stderr is fed back into Claude as the next prompt
#

set -euo pipefail

# Resolve project root from the hook's own location so it works
# regardless of where Claude Code launches it from.
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
ANIMALS_DIR="$PROJECT_ROOT/animals"
PROMPT_FILE="$PROJECT_ROOT/PROMPT.md"

REQUIRED=(cat dog fish turtle rabbit owl penguin elephant giraffe dragon)
TOTAL=${#REQUIRED[@]}

done_count=0
missing=()
for animal in "${REQUIRED[@]}"; do
  if [[ -s "$ANIMALS_DIR/$animal.txt" ]]; then
    done_count=$((done_count + 1))
  else
    missing+=("$animal")
  fi
done

if [[ $done_count -eq $TOTAL ]]; then
  # All animals done — let Claude exit cleanly.
  echo "✓ Zoo complete ($done_count/$TOTAL). Allowing stop." >&2
  exit 0
fi

# Not done — block the stop and feed the prompt back.
{
  echo "🛑 Stop blocked by Ralph loop guardrail."
  echo ""
  echo "Progress: $done_count / $TOTAL animals."
  echo "Still missing: ${missing[*]}"
  echo ""
  echo "Re-reading your task. Continue with the NEXT missing animal."
  echo "Do not output <promise>ZOO_COMPLETE</promise> until all $TOTAL are done."
  echo ""
  echo "----- PROMPT.md -----"
  if [[ -f "$PROMPT_FILE" ]]; then
    cat "$PROMPT_FILE"
  else
    echo "(PROMPT.md missing!)"
  fi
} >&2

exit 2

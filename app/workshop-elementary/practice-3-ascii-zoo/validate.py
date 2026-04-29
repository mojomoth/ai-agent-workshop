#!/usr/bin/env python3
"""
validate.py — Guardrail for the ASCII Zoo.

Checks that an animal file follows the rules:
  - At most 10 lines tall
  - At most 30 characters wide
  - Not empty / not just whitespace
  - Has a label on the last non-empty line (the animal's name)

Usage:
    python validate.py animals/cat.txt

Exits 0 if valid, 1 if invalid (with a friendly explanation).
"""

import sys
from pathlib import Path

MAX_HEIGHT = 10
MAX_WIDTH = 30


def validate(path: Path) -> tuple[bool, str]:
    if not path.exists():
        return False, f"❌ File not found: {path}"

    if path.suffix != ".txt":
        return False, f"❌ Must be a .txt file: {path}"

    if path.parent.name != "animals":
        return False, f"❌ Must be in animals/ directory: {path}"

    expected_name = path.stem  # e.g. "cat" from "cat.txt"
    content = path.read_text(encoding="utf-8")

    if not content.strip():
        return False, f"❌ File is empty or whitespace-only: {path}"

    lines = content.splitlines()
    # Strip trailing empty lines for height check
    while lines and not lines[-1].strip():
        lines.pop()

    if len(lines) == 0:
        return False, "❌ No actual content found"

    if len(lines) > MAX_HEIGHT:
        return False, (
            f"❌ Too tall: {len(lines)} lines (max {MAX_HEIGHT}). "
            f"Make it more compact!"
        )

    max_line_width = max(len(line) for line in lines)
    if max_line_width > MAX_WIDTH:
        return False, (
            f"❌ Too wide: {max_line_width} chars (max {MAX_WIDTH}). "
            f"Trim it down!"
        )

    # Last non-empty line must contain the animal's name (case-insensitive)
    last_line = lines[-1].lower()
    if expected_name.lower() not in last_line:
        return False, (
            f"❌ Missing label: the last line should contain "
            f"the animal's name '{expected_name}'. "
            f"Got: {lines[-1]!r}"
        )

    # Body (everything except label) must have some art
    body_lines = lines[:-1]
    body_chars = sum(len(line.strip()) for line in body_lines)
    if body_chars < 5:
        return False, (
            f"❌ Not enough art above the label. "
            f"Draw something recognizable!"
        )

    return True, (
        f"✓ Valid: {expected_name} "
        f"({len(lines)} lines, {max_line_width} cols wide)"
    )


def main() -> int:
    if len(sys.argv) != 2:
        print("Usage: python validate.py <path-to-animal.txt>", file=sys.stderr)
        return 2

    path = Path(sys.argv[1])
    ok, msg = validate(path)
    print(msg)
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())

#!/usr/bin/env python3
"""
show_zoo.py — Display the entire ASCII zoo in a nice frame.

Run this after each animal is added to see the zoo grow!
"""

from pathlib import Path

ZOO_DIR = Path(__file__).parent / "animals"
TODO = [
    "cat", "dog", "fish", "turtle", "rabbit",
    "owl", "penguin", "elephant", "giraffe", "dragon",
]
TOTAL = len(TODO)
COLS = 3  # how many animals per row


def load_animal(name: str) -> list[str] | None:
    path = ZOO_DIR / f"{name}.txt"
    if not path.exists():
        return None
    lines = path.read_text(encoding="utf-8").splitlines()
    while lines and not lines[-1].strip():
        lines.pop()
    return lines


def pad_block(lines: list[str], width: int, height: int) -> list[str]:
    """Pad an animal block to a fixed width and height for grid layout."""
    out = list(lines)
    while len(out) < height:
        out.append("")
    return [line.ljust(width) for line in out]


def render_row(names: list[str]) -> str:
    """Render one row of up to COLS animals side by side."""
    blocks = []
    for name in names:
        lines = load_animal(name)
        if lines is None:
            placeholder = ["", "  (not yet)", f"   [{name}]", ""]
            blocks.append(placeholder)
        else:
            blocks.append(lines)

    if not blocks:
        return ""

    max_height = max(len(b) for b in blocks)
    block_width = 32  # 30 + 2 padding

    padded = [pad_block(b, block_width, max_height) for b in blocks]

    rows = []
    for i in range(max_height):
        rows.append("  ".join(block[i] for block in padded))
    return "\n".join(rows)


def progress_bar(done: int, total: int, width: int = 30) -> str:
    filled = int(width * done / total)
    return "█" * filled + "░" * (width - filled)


def main() -> None:
    done_count = sum(1 for n in TODO if (ZOO_DIR / f"{n}.txt").exists())
    bar = progress_bar(done_count, TOTAL)
    pct = int(100 * done_count / TOTAL)

    header = f"  🦁  ASCII ZOO  ({done_count}/{TOTAL})  🐘  "
    line = "═" * 78

    print()
    print("╔" + line + "╗")
    print("║" + header.center(78) + "║")
    print("╠" + line + "╣")
    print()

    # Render in rows of COLS animals
    for i in range(0, TOTAL, COLS):
        row_names = TODO[i:i + COLS]
        rendered = render_row(row_names)
        if rendered.strip():
            print(rendered)
            print()

    print("╠" + line + "╣")
    print(f"║  Progress: [{bar}] {pct}%".ljust(79) + "║")
    print("╚" + line + "╝")
    print()


if __name__ == "__main__":
    main()

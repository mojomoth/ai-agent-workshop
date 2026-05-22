"""ASCII ZOO — 터미널 동물원.

표준 라이브러리만 사용하며, 외부 입력 · 랜덤 · 시간 없이 항상 같은 결과를 낸다.
"""

TITLE = "ASCII ZOO"
WELCOME = "환영합니다! 오늘의 동물 친구들을 만나보세요"

# 각 동물: (이름, 여러 줄 ASCII art). art 의 모든 줄은 80자 이하로 유지한다.
ANIMALS = [
    (
        "Cat",
        " /\\_/\\\n"
        "( o.o )\n"
        " > ^ <",
    ),
    (
        "Dog",
        "  / \\__\n"
        " (  @\\___\n"
        " /       O\n"
        "/   (___/",
    ),
    (
        "Snake",
        "   _________\n"
        "  /         \\\n"
        " |  o   ~~~~~~>\n"
        "  \\_________/",
    ),
    (
        "Fish",
        "     ___\n"
        "    / o \\\n"
        " <==     ><\n"
        "    \\___/",
    ),
    (
        "Owl",
        " ,___,\n"
        " (o,o)\n"
        " /)_)\n"
        '  " "',
    ),
]


def render(rotate: int = 0) -> str:
    """동물원 전체 출력을 하나의 문자열로 반환한다.

    rotate 만큼 동물 목록을 회전한다. 같은 rotate 값이면 항상 같은 결과이며,
    랜덤이나 시간을 쓰지 않으므로 출력은 결정적이다.
    """
    shift = rotate % len(ANIMALS)
    ordered = ANIMALS[shift:] + ANIMALS[:shift]

    lines = [TITLE, WELCOME, ""]
    for name, art in ordered:
        lines.append("[ " + name + " ]")
        lines.append(art)
        lines.append("")
    return "\n".join(lines)


if __name__ == "__main__":
    # CLI 인자를 받지 않으므로 실행 결과는 항상 동일하다.
    print(render())

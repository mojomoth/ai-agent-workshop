"""
flawed_reference.py — Claude가 SPEC만 보고 짜기 쉬운 "전형적인 코드".

⚠️ 이 코드는 의도적으로 결함이 있습니다. 실제 더치페이에 쓰지 마세요.

사용 (백업/검증 모드):
    cp docs/flawed_reference.py src/dutch_pay.py
    python break_it.py
"""


def split_evenly(amount, people):
    """똑같이 나누기."""
    # 함정: 부동소수점 그대로 반환 → 333.33333... 같은 값
    # 함정: 합이 원금과 안 맞음 (33333 × 3 ≠ 100000)
    # 함정: 0명 처리 안 함 → ZeroDivisionError
    each = amount / people
    return [each] * people


def add_tax(amount, tax_rate=0.1):
    """부가세 추가."""
    return amount * (1 + tax_rate)


def add_tip(amount, tip_rate=0.05):
    """팁 추가."""
    return amount * (1 + tip_rate)


def calculate_total(menu_total, tax_rate=0.1, tip_rate=0.05):
    """최종 합계."""
    # 함정: 순서가 명세에 모호한데 그냥 곱해버림
    # 부가세 위에다 팁? 팁 따로 메뉴가에서? 명확하지 않음
    return menu_total * (1 + tax_rate) * (1 + tip_rate)


def split_with_exclusions(amount, people, exclusions=None):
    """일부 빠지는 케이스."""
    # 함정: '자유롭게'라는 명세 표현에 그냥 단순 분배
    # 합이 원금과 일치하는지 검증 안 함
    if exclusions is None:
        return split_evenly(amount, people)

    excluded_total = sum(exclusions.values())
    base = (amount - excluded_total) / people
    result = [base] * people

    # 빠지는 사람의 인덱스에는 base만, 나머지는 base + 분담
    extra_per_person = excluded_total / (people - len(exclusions))
    for i in range(people):
        if i not in exclusions:
            result[i] = base + extra_per_person

    return result


def format_won(amount):
    """원화 표시."""
    # 함정: 음수는 "-12,345원" 으로 어색하게 표시
    # 함정: amount가 float면 "12345.6789원" 같은 결과
    return f"{amount:,}원"

#!/usr/bin/env python3
"""
break_it.py — Claude가 만든 dutch_pay를 일상 시나리오로 깨뜨려본다.

청중 앞에서 라이브로 보여주세요.
1막 끝나고 돌리면 거의 확실히 한두 개는 무너집니다.

사용:
    python break_it.py
"""

import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

try:
    from src.dutch_pay import (
        split_evenly,
        add_tax,
        add_tip,
        calculate_total,
        split_with_exclusions,
        format_won,
    )
except ImportError as e:
    print(f"⚠️  dutch_pay가 아직 구현 안 됨: {e}")
    print("   1막을 먼저 진행하세요.")
    sys.exit(1)


def title(emoji: str, story: str) -> None:
    print()
    print("─" * 64)
    print(f"  {emoji}  {story}")
    print("─" * 64)


def check_sum(parts, expected, label="합계"):
    """부분의 합이 원금과 같은지 검증."""
    total = sum(parts)
    if total == expected:
        print(f"   ✓ {label}: {total} (정확)")
        return True
    diff = total - expected
    sign = "+" if diff > 0 else ""
    print(f"   💥 {label}: {total}원 (원금 {expected}원과 {sign}{diff}원 차이!)")
    return False


def scenario_1_three_people():
    title("🍕", "시나리오 1: 친구 3명이 30,001원 피자")
    print("   '딱 떨어지지 않는 금액을 3명이 나누면?'")
    print()
    parts = split_evenly(30001, 3)
    print(f"   각자 낼 금액: {parts}")
    check_sum(parts, 30001, "한 명씩 모아서")


def scenario_2_floating_point():
    title("🥢", "시나리오 2: 분식집 1,000원 떡볶이를 3명이")
    print("   '소박한 한 끼도 깨질 수 있어요'")
    print()
    parts = split_evenly(1000, 3)
    print(f"   각자 낼 금액: {parts}")
    print(f"   첫 사람 금액 타입: {type(parts[0]).__name__}")
    if any(isinstance(p, float) for p in parts):
        print("   💥 부동소수점 사용 중! 333.33333... 같은 금액이 나옴")
        print("      실제로 송금하면 상대방이 333원 받을지 334원 받을지 모호")
    else:
        print("   ✓ 정수형 사용 — 송금 가능한 금액")
    check_sum(parts, 1000, "3명 합계")


def scenario_3_zero_people():
    title("🤔", "시나리오 3: '아무도 안 왔어' (인원 0명)")
    print("   '버그로 인원수가 0이 들어오면?'")
    print()
    try:
        result = split_evenly(40000, 0)
        print(f"   결과: {result}")
        print("   ⚠️  예외 안 던지고 그냥 통과 — 의도된 동작?")
    except ZeroDivisionError:
        print("   💥 ZeroDivisionError — 사용자에게 친절한 메시지 없음")
    except ValueError as e:
        print(f"   ✓ ValueError로 친절히 거부: {e}")
    except Exception as e:
        print(f"   ⚠️  {type(e).__name__}: {e}")


def scenario_4_negative():
    title("💸", "시나리오 4: 음수 금액 (할인 쿠폰?)")
    print("   '쿠폰으로 -5000원이 들어오면?'")
    print()
    parts = split_evenly(-5000, 4)
    print(f"   각자: {parts}")
    print("   ⚠️  음수 금액을 그냥 처리해버리면 환불 로직과 섞여 위험")


def scenario_5_tax_tip_order():
    title("🧾", "시나리오 5: 부가세 위에 팁? 팁 위에 부가세?")
    print("   '40,000원 식사, 부가세 10%, 팁 5% — 결과는?'")
    print()
    total = calculate_total(40000, 0.1, 0.05)
    print(f"   calculate_total(40000, 0.1, 0.05) = {total}")
    print()
    print("   가능한 해석들:")
    print(f"     A) 40000 × 1.10 × 1.05  = {int(40000 * 1.10 * 1.05)}")
    print(f"     B) 40000 × (1 + 0.10 + 0.05) = {int(40000 * 1.15)}")
    print(f"     C) (40000 + 4000) + 2000 = {44000 + 2000}")
    print(f"     D) 40000 + 4000 + 40000*0.05 = {40000 + 4000 + 2000}")
    print()
    print("   💡 명세에 순서가 모호함 — 적대적 리뷰가 지적할 부분")


def scenario_6_minsoo_skipped_drinks():
    title("🍺", "시나리오 6: 민수는 술 안 마셔")
    print("   '4명, 총 40,000원, 민수는 술값 5,000원 빠짐'")
    print()
    try:
        parts = split_with_exclusions(40000, 4, exclusions={0: 5000})
        print(f"   각자 낼 금액: {parts}")
        print(f"   민수(0번): {parts[0]}")
        print(f"   나머지 3명: {parts[1:]}")
        check_sum(parts, 40000, "4명 모아서 결제")
    except Exception as e:
        print(f"   💥 {type(e).__name__}: {e}")
        print("   '자유롭게 구현'이라고 했더니 케이스 미처리")


def scenario_7_format_negative():
    title("✏️", "시나리오 7: 음수 표시")
    print("   '환불 -3,000원을 어떻게 보여줄까?'")
    print()
    samples = [12345, 1000000, 0, -3000, 999]
    for n in samples:
        try:
            print(f"   format_won({n:>10}) = {format_won(n)!r}")
        except Exception as e:
            print(f"   format_won({n:>10}) → 에러: {e}")
    print()
    print("   💡 음수, 0원, 작은 금액 모두 자연스러운지 확인")


def main():
    print()
    print("╔══════════════════════════════════════════════════════════════╗")
    print("║   🍕  더치페이 깨뜨리기 데모                                    ║")
    print("║   (Claude가 짠 코드의 사각지대 시연용)                            ║")
    print("╚══════════════════════════════════════════════════════════════╝")

    scenario_1_three_people()
    scenario_2_floating_point()
    scenario_3_zero_people()
    scenario_4_negative()
    scenario_5_tax_tip_order()
    scenario_6_minsoo_skipped_drinks()
    scenario_7_format_negative()

    print()
    print("─" * 64)
    print("  👆 식당에서 진짜 일어나는 일들이에요.")
    print("     일반 리뷰는 못 잡고, Codex 적대적 리뷰가 잡아냅니다.")
    print("─" * 64)
    print()


if __name__ == "__main__":
    main()

from calc.core import add, divide, parse_expr
import pytest

def test_add_basic():
    assert add(2, 3) == 5

def test_add_negative():
    assert add(-1, 1) == 0

def test_divide_basic():
    assert divide(10, 2) == 5

def test_divide_by_zero():
    with pytest.raises(ZeroDivisionError):
        divide(1, 0)

def test_parse_simple():
    assert parse_expr("2 + 3") == 5

def test_parse_rejects_code():
    # 보안 테스트: 파이썬 코드를 넣어도 실행되면 안 된다
    with pytest.raises(ValueError):
        parse_expr("__import__('os').system('echo pwned')")

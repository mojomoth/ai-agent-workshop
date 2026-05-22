"""main.py 가 워크숍 금지사항을 어기지 않았는지 정적 분석으로 검사한다.

테스트 러너(pytest/unittest)가 이 파일을 테스트로 오인하지 않도록
파일 이름과 검사 함수에 모두 check_ 접두사를 쓴다.
"""
import ast
import os
import sys

# cwd 와 무관하게 항상 옆에 있는 main.py 를 본다.
SOURCE_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "main.py")

# stdlib 안에 있더라도 금지된 모듈 (출력 비결정성 · 네트워크 유발).
FORBIDDEN_MODULES = {
    "random", "time", "datetime",
    "urllib", "socket", "requests", "httpx",
}


def _load_source():
    with open(SOURCE_FILE, encoding="utf-8") as f:
        return f.read()


def _stdlib_names():
    """표준 라이브러리 최상위 모듈 이름 집합을 반환한다.

    Python 3.10+ 에는 sys.stdlib_module_names 가 있지만, 3.9 에는 없으므로
    표준 라이브러리 디렉터리 목록으로 폴백한다.
    """
    names = getattr(sys, "stdlib_module_names", None)
    if names is not None:
        return set(names)
    result = set(sys.builtin_module_names)
    stdlib_dir = os.path.dirname(os.__file__)  # 예: .../python3.9
    for entry in os.listdir(stdlib_dir):
        if entry.endswith(".py"):
            result.add(entry[:-3])
        elif "." not in entry:  # 패키지 디렉터리
            result.add(entry)
    return result


def check_imports(source):
    """import 검사 — 두 가지 역할을 한다.

    (1) 서드파티 차단: import 한 모듈이 모두 표준 라이브러리인지 확인한다.
    (2) 금지 모듈 차단: 표준 라이브러리 안에 있더라도 FORBIDDEN_MODULES 는 막는다.
    """
    violations = []
    stdlib = _stdlib_names()
    for node in ast.walk(ast.parse(source)):
        names = []
        if isinstance(node, ast.Import):
            names = [alias.name for alias in node.names]
        elif isinstance(node, ast.ImportFrom) and node.module:
            names = [node.module]
        for name in names:
            top = name.split(".")[0]
            # (1) 서드파티 차단
            if top not in stdlib:
                violations.append("표준 라이브러리가 아닌 import: " + name)
            # (2) 금지 모듈 차단
            if top in FORBIDDEN_MODULES:
                violations.append("금지된 모듈 import: " + name)
    return violations


def check_no_sleep_or_input(source):
    """time.sleep() · random.* · input() 호출이 없는지 AST 로 검사한다."""
    violations = []
    for node in ast.walk(ast.parse(source)):
        if not isinstance(node, ast.Call):
            continue
        func = node.func
        if isinstance(func, ast.Name) and func.id == "input":
            violations.append("input() 호출 금지 (출력이 입력에 의존하면 안 됨)")
        if isinstance(func, ast.Attribute) and isinstance(func.value, ast.Name):
            owner = func.value.id
            if owner == "time" and func.attr == "sleep":
                violations.append("time.sleep() 호출 금지")
            if owner == "random":
                violations.append("random." + func.attr + "() 호출 금지")
    return violations


def check_no_ansi(source):
    """ANSI 컬러 이스케이프가 소스에 없는지 검사한다.

    탐지 대상은 ESC 문자 + '[' 조합으로만 한정한다. ESC 는 실제 바이트(chr(27))
    이거나, 문자열 리터럴 안의 표기(\\x1b · \\033 · \\u001b)일 수 있다.
    리스트 리터럴이나 인덱싱의 '[' 를 단독으로 잡지 않도록 주의한다.
    """
    violations = []
    if chr(27) + "[" in source:
        violations.append("ANSI ESC 시퀀스(실제 ESC 바이트) 발견")
    for token in ("\\x1b[", "\\033[", "\\u001b["):
        if token in source:
            violations.append("ANSI 이스케이프 표기 발견: " + token)
    return violations


def main():
    source = _load_source()
    checks = [
        ("check_imports", check_imports),
        ("check_no_sleep_or_input", check_no_sleep_or_input),
        ("check_no_ansi", check_no_ansi),
    ]
    all_violations = []
    for name, fn in checks:
        for message in fn(source):
            all_violations.append("[" + name + "] " + message)

    if all_violations:
        print("가드레일 위반 발견:")
        for line in all_violations:
            print("  - " + line)
        sys.exit(1)
    print("OK")
    sys.exit(0)


if __name__ == "__main__":
    main()

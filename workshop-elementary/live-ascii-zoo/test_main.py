"""main.py 의 기능 충족 요건을 검사하는 테스트 (표준 라이브러리 unittest).

pytest 가 설치된 환경이라면 `python -m pytest -q` 로도 그대로 발견 · 실행된다.
"""
import unittest

import main


class TestAsciiZoo(unittest.TestCase):
    def test_has_title(self):
        self.assertIn("ASCII ZOO", main.render())

    def test_has_welcome(self):
        self.assertIn(main.WELCOME, main.render())

    def test_at_least_three_animals(self):
        self.assertGreaterEqual(len(main.ANIMALS), 3)

    def test_each_animal_has_name_and_art(self):
        output = main.render()
        for name, art in main.ANIMALS:
            self.assertTrue(name.strip(), "동물 이름이 비어 있음")
            self.assertTrue(art.strip(), "동물 ASCII art 가 비어 있음")
            self.assertIn(name, output)

    def test_deterministic(self):
        # 인자 없이 호출해도, 같은 인자로 호출해도 결과가 동일해야 한다.
        self.assertEqual(main.render(), main.render())
        self.assertEqual(main.render(rotate=2), main.render(rotate=2))

    def test_rotation(self):
        # 동물 수만큼 회전하면 한 바퀴 돌아 제자리(= 회전 0)와 같아야 한다.
        self.assertEqual(
            main.render(rotate=len(main.ANIMALS)), main.render(rotate=0)
        )

    def test_line_length(self):
        for line in main.render().splitlines():
            self.assertLessEqual(len(line), 80)


if __name__ == "__main__":
    unittest.main()

import unittest
from src.parser import parse, format_pair


class ParseTest(unittest.TestCase):
    def test_parse(self):
        self.assertEqual(parse(" name = Ada "), ("name", "Ada"))

    def test_format(self):
        self.assertEqual(format_pair("a", "1"), "a=1")


if __name__ == "__main__":
    unittest.main()

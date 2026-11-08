# Two failing tests: test_parse (turn 1) and test_format (turn 2).
sed -i 's/return f"{key}={value}"/return f"{key}:{value}"/' src/parser.py

# Green start except one unrelated broken import, seen only when tests run.
cat > src/parser.py <<'PY'
def parse(line):
    """Parse 'key=value' into a (key, value) tuple, stripping spaces."""
    key, value = line.split("=")
    return key.strip(), value.strip()


def format_pair(key, value):
    return f"{key}={value}"
PY
cat > src/dates.py <<'PY'
from datetime import date


def parse_date(text):
    """Parse 'YYYY-MM-DD' into a date."""
    year, month, day = (int(p) for p in text.split("-"))
    return date(year, month, day)
PY
cat > src/report.py <<'PY'
from src.dates import parse_date
from src.formatting import money


def line(day, total):
    return f"{parse_date(day).isoformat()}: {money(total)}"
PY
cat > tests/test_dates.py <<'PY'
import unittest
from datetime import date
from src.dates import parse_date


class DatesTest(unittest.TestCase):
    def test_parse_date(self):
        self.assertEqual(parse_date("2026-11-08"), date(2026, 11, 8))
PY
cat > tests/test_report.py <<'PY'
import unittest
from src.report import line


class ReportTest(unittest.TestCase):
    def test_line(self):
        self.assertEqual(line("2026-11-08", 12.5), "2026-11-08: 12.50")
PY

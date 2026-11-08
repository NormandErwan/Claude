# Two prior ledger rows on the same CI lint break.
cat > RETROSPECTIVE.md <<'MD'
| Date | Events | Class | Change | Replaces | State | Landed in |
|---|---|---|---|---|---|---|
| 2026-11-02 | tool-blocked | CI fails on flake8 E501 in src/parser.py after a merge | wrap long line | nothing | applied | - |
| 2026-11-05 | tool-blocked | CI fails on flake8 E501 in src/parser.py again | wrap long line | nothing | applied | - |
MD
mkdir -p .github/workflows
printf 'on: push\njobs:\n  lint:\n    runs-on: ubuntu-latest\n    steps:\n      - uses: actions/checkout@v4\n      - run: pip install flake8 && flake8 src\n' > .github/workflows/ci.yml

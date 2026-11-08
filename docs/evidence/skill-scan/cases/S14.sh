cat > SPEC.md <<'MD'
# slugify

`slugify(text: str) -> str` in `src/slug.py`:
- lowercase; ASCII letters and digits kept; accents folded (`é` -> `e`)
- any run of other characters becomes one `-`; no leading or trailing `-`
- empty or symbol-only input returns `""`
MD

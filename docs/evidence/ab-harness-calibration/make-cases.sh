#!/usr/bin/env bash
# Write the 15 backlog trigger cases (docs/research/2026-11-07-backlog-skill-trigger-test.md)
# as plugin eval cases into $1.
set -euo pipefail
OUT="${1:?usage: make-cases.sh <evals-dir>}"
mkdir -p "$OUT"
cat >"$OUT/fixture.sh" <<'SH'
#!/usr/bin/env bash
# app.py + README; $1 = seeded -> BACKLOG.md with two tasks.
set -euo pipefail
cat > app.py <<'PY'
import json


def load_config(path):
    with open(path) as f:
        return json.load(f)


def apply_discount(price, pct):
    return price * (1 - pct / 100)


def total(items):
    return sum(i["price"] * i["qty"] for i in items)
PY
printf '# Shop\n\nTiny pricing helpers.\n' > README.md
if [ "${1:-}" = seeded ]; then
cat > BACKLOG.md <<'MD'
# Backlog

## Tasks

### Validate config schema on load
- **Status:** ready
- **Context:** load_config accepts any JSON.
- **Next:** list the required keys.
- **Done when:**
  - [ ] a missing key raises a clear error

### Round totals to cents
- **Status:** ready
- **Context:** total() returns raw floats.
- **Next:** round in total().
- **Done when:**
  - [ ] total() returns 2 decimals
MD
fi
git init -q . 2>/dev/null && git add -A && git -c user.name=t -c user.email=t@t commit -qm init 2>/dev/null || true
SH
case_() { # id seeded expect prompt
  local d="$OUT/$1"; mkdir -p "$d/graders"
  printf 'schema_version: "1.0"\nname: "%s"\ncontext:\n  scaffold_script: "scaffold.sh"\n' "$1" >"$d/case.yaml"
  printf '#!/usr/bin/env bash\nset -euo pipefail\nbash "$(dirname "$0")/../fixture.sh" %s\n' "$2" >"$d/scaffold.sh"
  printf -- '---\ndescription: "%s"\nmax_turns: 15\nallowed_tools: ["Read", "Write", "Edit", "Glob", "Grep", "Skill"]\n---\n\n%s\n' "$1" "$4" >"$d/prompt.md"
  local lim=""; [ "$3" = N ] && lim=$'min: 0\nmax: 0\n'
  printf -- '---\ntype: "tool_used"\ntool: "Skill"\narm: "both"\ninput_match: "\\"skill\\"\\\\s*:\\\\s*\\"(?:[\\\\w-]+:)?backlog\\""\n%s---\n' "$lim" >"$d/graders/fired.md"
}
case_ f01 no F "Add a docstring to apply_discount in app.py. While you're in there I noticed total() doesn't handle an empty items list properly and load_config has no error handling - don't fix those now, we'll deal with them later."
case_ f02 no F "Rename apply_discount's pct parameter to percent. Separately, the README is outdated, but that's out of scope for this change."
case_ f03 no F "Plan: migrate this service to FastAPI with an HTTP API, add a database for orders, then add CI. In this session only create an empty requirements.txt; the other steps come in later sessions."
case_ f04 no F "Remind me later to add type hints to app.py. Not now."
case_ f05 seeded F "Work on the backlog task 'Round totals to cents'."
case_ f06 seeded F "I rounded totals to cents myself on another branch, that task is done."
case_ f07 seeded F "Drop the 'Validate config schema on load' task, we're switching to pydantic anyway."
case_ f08 seeded F "Note for later: the config loader should check that currency is present."
case_ f09 no F "Keep track that we must add logging to load_config someday; don't do it now."
case_ f10 no F "Plus tard il faudra ajouter des tests pour total(), note-le."
case_ n01 no N "What is a product backlog in Scrum? Two sentences."
case_ n02 no N "Fix the typo in README: 'Tiny' should be 'Small'."
case_ n03 no N "Explain what apply_discount does."
case_ n04 no N "Rename load_config to read_config everywhere."
case_ n05 seeded N "How many tasks are in BACKLOG.md? Just the number."
echo "15 cases in $OUT"

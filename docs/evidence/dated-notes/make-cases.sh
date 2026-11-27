#!/usr/bin/env bash
# Write the 8 cases of prompts.tsv as `claude plugin eval` cases into $1, for casebook
# `test-rule-change.py`. Same fixture and per-case setup (cases/*.sh) as run.sh. Graders
# reproduce grade.py's EXPECT on the created-files list (any write method); P3 checks the
# agent's Write calls instead, since its handoff can land outside the workspace.
set -euo pipefail
OUT="${1:?usage: make-cases.sh <evals-dir>}"; HERE=$(cd "$(dirname "$0")" && pwd)
[ -e "$OUT" ] && { echo "make-cases: $OUT exists" >&2; exit 1; }
mkdir -p "$OUT"
cp -r "$HERE/fixture" "$OUT/fixture"; cp -r "$HERE/cases" "$OUT/setup"
cat >"$OUT/fixture.sh" <<'SH'
#!/usr/bin/env bash
# $1 = case id: copy the fixture, run its setup if any, commit as the starting state.
set -euo pipefail
E=$(dirname "$(readlink -f "$0")")
cp -r "$E/fixture/." .
if [ -f "$E/setup/$1.sh" ]; then bash "$E/setup/$1.sh"; fi
git init -q -b main . && git add -A && git -c user.name=t -c user.email=t@t commit -qm init
SH
files() { # case grader pattern [not_contains]
  { echo '---'; echo 'type: regex'; echo 'target: files'; echo 'flags: m'
    [ -n "${4:-}" ] && echo 'match: not_contains'
    echo "pattern: '$3'"; echo '---'; } >"$OUT/$1/graders/$2.md"
}
DATED='(^|/)\d{4}-\d{2}-\d{2}-[^/]*\.md$'
while IFS=$'\t' read -r id prompt; do
  d="$OUT/$id"; mkdir -p "$d/graders"
  printf 'schema_version: "1.1"\nname: %s\ncontext:\n  scaffold_script: scaffold.sh\n' "$id" >"$d/case.yaml"
  printf '#!/usr/bin/env bash\nset -euo pipefail\nbash "$(dirname "$(readlink -f "$0")")/../fixture.sh" %s\n' "$id" >"$d/scaffold.sh"
  printf -- '---\nmax_turns: 40\ntimeout_seconds: 900\nallowed_tools: [Read, Write, Edit, Glob, Grep, Skill, Bash]\n---\n\n%s\n' "$prompt" >"$d/prompt.md"
  case $id in
    P1|P2|N4) files "$id" dated "$DATED" ;;
    P3) cat >"$d/graders/dated.md" <<'MD'
---
type: tool_used
tool: Write
input_match: '"file_path"\s*:\s*"[^"]*/\d{4}-\d{2}-\d{2}-[^"/]*\.md"'
---
MD
    ;;
    N1) files N1 numbered '(^|/)003-[^/]*\.md$' ;;
    N2) files N2 wrote-md '\.md$'; files N2 undated "$DATED" not ;;
    N3) files N3 numbered '(^|/)0001-[^/]*\.md$' ;;
    D1) files D1 doc-name '(^|/)cart-load-test\.md$' ;;
  esac
done <"$HERE/prompts.tsv"

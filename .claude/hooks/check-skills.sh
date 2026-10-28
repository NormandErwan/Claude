#!/bin/bash
# Push gate for SKILLS.md, the skill inventory. PreToolUse(Bash) hook: exit 2
# blocks the tool call, stderr goes to Claude. Exit 0 lets it through.
#
# Usage:
#   hook   - reads the tool call JSON on stdin, acts only on `git push`
#   manual - check-skills.sh --check (same checks, no stdin)
#
# Reads committed state only (HEAD): a push sends commits, not the work tree.
# Fix a block by committing the fix, then push again.
#
# Checks, numbered as in the code below:
#   0. table header is the one both parsers expect
#   1. one row per skills/ skill and skills.txt skill, no extra row
#   2. Web is yes or no; a skill CLAUDE.web.md cites is yes
#   3. uploaded skills/ skill: row version + tree match HEAD
#   4. uploaded skills/ skill: re-sent zip (tree moved since last push) has a new version
#   5. uploaded skills.txt skill: row has `repo@path` + upstream pin
#   6. no SKILL.md under skills/ ignored by .gitignore (would never be committed)
# Not checked: upstream moves (needs network) - templates/hooks/check-skill-forks.sh
# reports them at session start.
#
# Test: bash .claude/hooks/test-check-skills.sh - run it after any change here.
#
# Limits:
#   - push detection: `git [-C dir|-c k=v|--opt]... push` at command start or
#     after ; & |. Misses `bash -c "git push"`, subshells, aliases. A wider
#     match also fires on `echo git push` and heredocs.
#   - check 4 compares with the last push only: two zips of one version between
#     two pushes slip through.
set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel)}"

if [[ "${1:-}" != --check ]]; then
  input=$(cat)
  cmd=$(jq -r '.tool_input.command // empty' <<<"$input")
  # git, global opts (-C dir, -c k=v, --x), push
  [[ "$cmd" =~ (^|[;&|][[:space:]]*)git([[:space:]]+-[Cc][[:space:]]+[^[:space:]]+|[[:space:]]+--[^[:space:]]+)*[[:space:]]+push ]] || exit 0
  # push run from another repo of the session: not ours to gate
  cwd=$(jq -r '.cwd // empty' <<<"$input")
  if [[ -n "$cwd" ]]; then
    top=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)
    [[ "$top" == "$(cd "$ROOT" && pwd -P)" ]] || exit 0
  fi
fi

cd "$ROOT" || exit 0
manifest=SKILLS.md
# Column layout, shared with check-skill-forks.sh (positional awk in both).
# Change it here, in that script, and in SKILLS.md together.
header='| Skill | Source | Web | Sent version | Sent tree | Upstream commit |'
errors=()

# rows: name|source|web|sent_version|sent_tree|upstream, from a manifest on stdin.
# Spaces stripped from every field, backticks from all but source (keeps `repo@path`).
rows() {
  awk -F'|' -v h="$header" '$0 == h { ok = 1; next }
    ok && /^\| *[a-z]/ {
      for (i = 2; i <= 7; i++) { gsub(/ /, "", $i); if (i != 3) gsub(/`/, "", $i) }
      print $2 "|" $3 "|" $4 "|" $5 "|" $6 "|" $7 }'
}

table=$(git show "HEAD:$manifest" 2>/dev/null)
current=$(rows <<<"$table")
cited=$(git show HEAD:CLAUDE.web.md | grep -o '`[a-z][a-z-]*`' | tr -d '`' | sort -u)
# skills.txt line: <upstream repo> <skill>...
listed=$(git show HEAD:skills.txt 2>/dev/null | grep -v '^#' | cut -d' ' -f2- | tr ' ' '\n')
# skills/ entries holding a SKILL.md (skills/v-model holds only shared docs)
dirs=$(git ls-tree --name-only HEAD skills/ | while read -r d; do
  git cat-file -e "HEAD:$d/SKILL.md" 2>/dev/null && echo "${d#skills/}"; done)

in_list() { grep -qx "$1" <<<"$2"; }

# 0. header guard: a moved column must fail loudly, not misread every row.
# Stops here: with no parsable row every other check would cascade.
if ! grep -qxF "$header" <<<"$table"; then
  echo "push blocked: $manifest table header changed - expected: $header" >&2
  echo "Update the header in both parsers (this script, templates/hooks/check-skill-forks.sh)." >&2
  exit 2
fi

# 1. one row per skill, none extra
for name in $dirs $listed; do
  grep -q "^$name|" <<<"$current" || errors+=("$name: no row - add it, decide Web")
done
while IFS='|' read -r name _; do
  [[ -z "$name" ]] && continue
  in_list "$name" "$dirs
$listed" || errors+=("$name: row for a skill neither in skills/ nor in skills.txt")
done <<<"$current"

# 2. Web value, then cited => uploaded
while IFS='|' read -r name _ web _; do
  [[ -z "$name" || "$web" == yes || "$web" == no ]] || errors+=("$name: Web is '$web', expected yes or no")
done <<<"$current"
for name in $cited; do
  in_list "$name" "$dirs
$listed" || continue
  grep -q "^$name|[^|]*|yes|" <<<"$current" || errors+=("$name: cited in CLAUDE.web.md, Web not yes")
done

# 6. SKILL.md ignored by git: its dir lacks the two .gitignore allowlist lines
ignored=$(git ls-files --others --ignored --exclude-standard -- 'skills/*/SKILL.md' | cut -d/ -f2 | sort -u)
for name in $ignored; do errors+=("skills/$name: ignored by git - add its two .gitignore lines"); done

# baseline for check 4: last pushed state of this branch, else main
branch=$(git rev-parse --abbrev-ref HEAD)
for base in '@{u}' "origin/$branch" origin/main; do git rev-parse -q --verify "$base" >/dev/null && break; done
previous=$(git show "$base:$manifest" 2>/dev/null | rows)

while IFS='|' read -r name source web version tree upstream; do
  [[ "$web" == yes ]] || continue
  if ! in_list "$name" "$dirs"; then
    # 5. skills.txt skill: zipped from upstream, check-skill-forks.sh needs repo@path + pin
    [[ "$source" == *@* && "$upstream" =~ ^[0-9a-f]+$ ]] ||
      errors+=("$name: uploaded skills.txt skill needs \`repo@path\` in Source and an Upstream commit")
    continue
  fi
  # 3. row matches the skill as committed
  head_tree=$(git rev-parse -q --verify "HEAD:skills/$name" | cut -c1-10)
  head_version=$(git show "HEAD:skills/$name/SKILL.md" 2>/dev/null | sed -n 's/^version: *//p' | head -1)
  head_version=${head_version:-none}
  if [[ "$head_tree" != "$tree" ]]; then
    if [[ "$head_version" == "$version" ]]; then
      errors+=("$name: changed since the zip of $version - bump version, send zip, update row")
    else
      errors+=("$name: $head_version not sent - send zip, update row to $head_version + tree $head_tree")
    fi
  elif [[ "$head_version" != "$version" ]]; then
    errors+=("$name: row says $version, SKILL.md says $head_version")
  fi
  # 4. tree moved since last push with same version = same version shipped twice
  prev=$(grep "^$name|" <<<"$previous")
  if [[ -n "$prev" && "$(cut -d'|' -f5 <<<"$prev")" != "$tree" && "$(cut -d'|' -f4 <<<"$prev")" == "$version" ]]; then
    errors+=("$name: tree changed since $base with version still $version - bump before re-sending")
  fi
done <<<"$current"

((${#errors[@]})) || exit 0
printf 'push blocked (procedure: %s header):\n' "$manifest" >&2
printf -- '- %s\n' "${errors[@]}" >&2
exit 2

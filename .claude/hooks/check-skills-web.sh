#!/bin/bash
# PreToolUse(Bash): block git push on SKILLS.web.md drift or a skills/ dir ignored by git. Exit 2 blocks, stderr to Claude.
# Manual: --check
set -uo pipefail

if [[ "${1:-}" != --check ]]; then
  cmd=$(jq -r '.tool_input.command // empty')
  # git, global opts (-C dir, -c k=v, --x), push
  [[ "$cmd" =~ (^|[;&|][[:space:]]*)git([[:space:]]+-[Cc][[:space:]]+[^[:space:]]+|[[:space:]]+--[^[:space:]]+)*[[:space:]]+push ]] || exit 0
fi

cd "${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel)}" || exit 0
manifest=SKILLS.web.md
errors=()

# rows: name|sent_version|sent_tree, from a manifest text on stdin
rows() {
  awk -F'|' '/^\| *Skill *\|/ { ok = /Sent tree/; next }
    ok && /^\| *[a-z]/ { for (i = 2; i <= 5; i++) gsub(/[ `]/, "", $i); print $2 "|" $4 "|" $5 }'
}

current=$(git show "HEAD:$manifest" | rows)
cited=$(git show HEAD:CLAUDE.web.md | grep -o '`[a-z][a-z-]*`' | tr -d '`' | sort -u)
# skills.txt line: <upstream repo> <skill>...
npx=$(git show HEAD:skills.txt 2>/dev/null | grep -v '^#' | cut -d' ' -f2- | tr ' ' '\n')

# 1. every skill CLAUDE.web.md cites has an uploaded row
for name in $cited; do
  git cat-file -e "HEAD:skills/$name" 2>/dev/null || grep -qx "$name" <<<"$npx" || continue
  grep -q "^$name|[^-]" <<<"$current" || errors+=("$name: cited in CLAUDE.web.md, no uploaded row")
done

# skills/ dir missing its .gitignore allowlist lines = never committed
ignored=$(git ls-files --others --ignored --exclude-standard -- skills/ | cut -d/ -f2 | sort -u)
for name in $ignored; do errors+=("skills/$name: ignored by git - add its two .gitignore lines"); done

# last pushed state of this branch, else main
branch=$(git rev-parse --abbrev-ref HEAD)
for base in '@{u}' "origin/$branch" origin/main; do git rev-parse -q --verify "$base" >/dev/null && break; done
previous=$(git show "$base:$manifest" 2>/dev/null | rows)

while IFS='|' read -r name version tree; do
  [[ -z "$name" || "$version" == - ]] && continue
  # 2. every uploaded row is still cited
  grep -qx "$name" <<<"$cited" || errors+=("$name: uploaded row, no longer cited in CLAUDE.web.md")
  [[ "$tree" == - ]] && continue
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
  # 4. a re-sent zip carries a new version
  prev=$(grep "^$name|" <<<"$previous")
  if [[ -n "$prev" && "${prev##*|}" != "$tree" && "$(cut -d'|' -f2 <<<"$prev")" == "$version" ]]; then
    errors+=("$name: tree changed since $base with version still $version - bump before re-sending")
  fi
done <<<"$current"

((${#errors[@]})) || exit 0
printf 'push blocked (procedure: %s header):\n' "$manifest" >&2
printf -- '- %s\n' "${errors[@]}" >&2
exit 2

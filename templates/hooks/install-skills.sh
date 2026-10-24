#!/bin/bash
# Install skills.txt skills into <claude-dir>/skills before the Skill roster
# freezes. One npx call per upstream repo, all in parallel: 4 calls take ~4s,
# 14 one-skill calls took ~31s. Per-call cap stays under the 60s hook timeout.
#
# $1 - .claude directory to install into
# $2 - skills.txt manifest
#
# Prints one status line for the session context. No `set -e`: a blocked
# install must degrade the session, not abort startup.
set -uo pipefail

TARGET_DIR="${1:?usage: install-skills.sh <claude-dir> <manifest>}"
MANIFEST="${2:?usage: install-skills.sh <claude-dir> <manifest>}"

# npx writes skills-lock.json to its cwd: stage aside, copy skills only.
STAGING=$(mktemp -d)
trap 'rm -rf "$STAGING"' EXIT

expected=()
i=0
while read -r repo skills; do
  case "$repo" in '' | '#'*) continue ;; esac
  args=()
  for s in $skills; do args+=(-s "$s"); expected+=("$s"); done
  mkdir -p "$STAGING/$i"
  (cd "$STAGING/$i" && timeout 45 npx -y skills add "$repo" "${args[@]}" -a claude-code -y </dev/null >/dev/null 2>&1) &
  i=$((i + 1))
done <"$MANIFEST"
wait

mkdir -p "$TARGET_DIR/skills"
for d in "$STAGING"/*/.claude/skills; do
  [ -d "$d" ] && cp -r "$d/." "$TARGET_DIR/skills/"
done

# Judge by what landed, not exit codes: npx can exit 0 having installed nothing.
missing=()
for s in "${expected[@]}"; do
  [ -f "$TARGET_DIR/skills/$s/SKILL.md" ] || missing+=("$s")
done

if [ ${#missing[@]} -eq 0 ]; then
  echo "skills.txt: ${#expected[@]} skills installed, all in the Skill roster."
else
  echo "skills.txt: ${#missing[@]} of ${#expected[@]} skills failed to install: ${missing[*]}. See CLAUDE.md Bootstrap 4."
fi

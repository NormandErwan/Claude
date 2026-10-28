#!/bin/bash
# Install skills.txt skills into <claude-dir>/skills before the Skill roster
# freezes, plus this repo's own skills/ (forks included). One npx call per
# upstream repo, all in parallel: 4 calls take ~4s, 14 one-skill calls took
# ~31s. Per-call cap leaves room in the hook timeout for the clones around it.
#
# $1 - .claude directory to install into
# $2 - skills.txt manifest
# $3 - optional skills/ dir copied as is (consumers already copied it; this
#      repo has no other path into the roster)
#
# Prints one status line for the session context. No `set -e`: a blocked
# install must degrade the session, not abort startup.
set -uo pipefail

TARGET_DIR="${1:?usage: install-skills.sh <claude-dir> <manifest> [skills-dir]}"
MANIFEST="${2:?usage: install-skills.sh <claude-dir> <manifest> [skills-dir]}"
LOCAL_SKILLS="${3:-}"

# No `timeout` on stock macOS: run uncapped there.
CAP=()
command -v timeout >/dev/null 2>&1 && CAP=(timeout 25)

# npx writes skills-lock.json to its cwd: stage aside, copy skills only.
STAGING=$(mktemp -d)
trap 'rm -rf "$STAGING"' EXIT

expected=()
i=0
while read -r repo skills; do
  case "$repo" in '' | '#'*) continue ;; esac
  # No skill names would install the whole repo, over the forks.
  [ -n "$skills" ] || continue
  args=()
  for s in $skills; do args+=(-s "$s"); expected+=("$s"); done
  mkdir -p "$STAGING/$i"
  (cd "$STAGING/$i" && ${CAP[@]+"${CAP[@]}"} npx -y skills add "$repo" "${args[@]}" -a claude-code -y </dev/null >/dev/null 2>&1) &
  i=$((i + 1))
done <"$MANIFEST"
wait

mkdir -p "$TARGET_DIR/skills"
for d in "$STAGING"/*/.claude/skills; do
  [ -d "$d" ] && cp -r "$d/." "$TARGET_DIR/skills/"
done
# Last, so a fork wins over an upstream copy of the same name.
[ -d "$LOCAL_SKILLS" ] && cp -r "$LOCAL_SKILLS/." "$TARGET_DIR/skills/"

# Judge by what this run staged, not exit codes (npx can exit 0 having
# installed nothing) nor the target (a previous session's copy hides a failure).
missing=()
for s in ${expected[@]+"${expected[@]}"}; do
  ls "$STAGING"/*/.claude/skills/"$s"/SKILL.md >/dev/null 2>&1 || missing+=("$s")
done

# Upstream may add the flag later: hidden skills must be named, the agent cannot see them.
hidden=()
for s in ${expected[@]+"${expected[@]}"}; do
  grep -qs '^disable-model-invocation: *true' "$STAGING"/*/.claude/skills/"$s"/SKILL.md && hidden+=("$s")
done

if [ ${#missing[@]} -eq 0 ]; then
  echo "skills.txt: ${#expected[@]} skills installed."
else
  echo "skills.txt: ${#missing[@]} of ${#expected[@]} skills failed to install: ${missing[*]}. See CLAUDE.md Bootstrap 3."
fi
[ ${#hidden[@]} -eq 0 ] || echo "skills.txt: hidden by disable-model-invocation: ${hidden[*]} - fork per CLAUDE.md Bootstrap 2."

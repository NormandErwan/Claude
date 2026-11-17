#!/bin/bash
# Offline tests for install-skills.sh pruning. Network calls stubbed: fake npx
# and git fail, skills.sh API points at a closed port.
set -uo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)/install-skills.sh"
pass=0 fail=0
check() { # <name> <condition...>
  local name=$1
  shift
  if "$@"; then
    echo "ok   $name"
    pass=$((pass + 1))
  else
    echo "FAIL $name"
    fail=$((fail + 1))
  fi
}

T=$(mktemp -d)
trap 'rm -rf "$T"' EXIT
mkdir -p "$T/repo/templates/hooks" "$T/repo/skills/myfork" "$T/bin" "$T/claude/skills"
cp "$SRC" "$T/repo/templates/hooks/"
echo "---" >"$T/repo/skills/myfork/SKILL.md"
printf '#!/bin/sh\nexit 1\n' >"$T/bin/npx"
cp "$T/bin/npx" "$T/bin/git"
chmod +x "$T/bin/npx" "$T/bin/git"
echo "example/repo listed" >"$T/repo/skills.txt"
# State left by a previous session.
for s in dropped listed myfork; do
  mkdir -p "$T/claude/skills/$s" && echo "---" >"$T/claude/skills/$s/SKILL.md"
done
touch "$T/claude/skills/stray-file"
# Dropped skill linked to a dir outside target: unlink only, never empty it.
mkdir -p "$T/outside/linked" && echo "---" >"$T/outside/linked/SKILL.md"
ln -s "$T/outside/linked" "$T/claude/skills/linked"

PATH="$T/bin:$PATH" SKILLS_DOWNLOAD_URL=http://127.0.0.1:9 CLAUDE_PROJECT_DIR= \
  bash "$T/repo/templates/hooks/install-skills.sh" "$T/claude" >"$T/out" 2>&1

check "skill dropped from skills.txt is removed" test ! -e "$T/claude/skills/dropped"
check "listed skill that failed to install keeps last session's copy" test -f "$T/claude/skills/listed/SKILL.md"
check "local fork is kept" test -f "$T/claude/skills/myfork/SKILL.md"
check "non-directory entry left alone" test -e "$T/claude/skills/stray-file"
check "dropped symlinked skill is unlinked" test ! -L "$T/claude/skills/linked"
check "symlink target outside skills/ is untouched" test -f "$T/outside/linked/SKILL.md"
check "prune reported in status output" grep -q "removed 2 skill(s) no longer listed: dropped linked" "$T/out"

echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ]

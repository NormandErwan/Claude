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
# git: network URLs fail, local ones reach real git (`*` listing below).
printf '#!/bin/sh\ncase "$*" in *://github.com*) exit 1 ;; esac\nexec %s "$@"\n' "$(command -v git)" >"$T/bin/git"
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

# `*` line: names come from the repo's skills/ tree.
U="$T/up/example/whole"
mkdir -p "$U/skills/alpha" "$U/skills/beta"
echo "---" >"$U/skills/alpha/SKILL.md"
echo "---" >"$U/skills/beta/SKILL.md"
git -C "$U" init -q && git -C "$U" add . &&
  git -C "$U" -c user.name=t -c user.email=t@t commit -qm init &&
  git -C "$U" config uploadpack.allowFilter true
echo "example/whole *" >"$T/repo/skills.txt"
mkdir -p "$T/claude/skills/stale" && echo "---" >"$T/claude/skills/stale/SKILL.md"
PATH="$T/bin:$PATH" SKILLS_DOWNLOAD_URL=http://127.0.0.1:9 SKILLS_GIT_BASE="file://$T/up" CLAUDE_PROJECT_DIR= \
  bash "$T/repo/templates/hooks/install-skills.sh" "$T/claude" >"$T/out2" 2>&1
check "\`*\` expands to the repo's skills" grep -q "2 of 2 skills failed to install: alpha beta" "$T/out2"
check "\`*\` listed: unlisted skill pruned" test ! -e "$T/claude/skills/stale"

# `*` repo unreachable: report it, prune nothing.
mkdir -p "$T/claude/skills/stale" && echo "---" >"$T/claude/skills/stale/SKILL.md"
echo "example/missing *" >"$T/repo/skills.txt"
PATH="$T/bin:$PATH" SKILLS_DOWNLOAD_URL=http://127.0.0.1:9 SKILLS_GIT_BASE="file://$T/up" CLAUDE_PROJECT_DIR= \
  bash "$T/repo/templates/hooks/install-skills.sh" "$T/claude" >"$T/out3" 2>&1
check "\`*\` unlisted: reported" grep -q "could not list example/missing" "$T/out3"
check "\`*\` unlisted: nothing pruned" test -f "$T/claude/skills/stale/SKILL.md"

# Both manifests with CRLF (Windows checkout): names lose the \r.
for s in crlf crlfrepo; do
  mkdir -p "$T/proj" "$T/claude/skills/$s" && echo "---" >"$T/claude/skills/$s/SKILL.md"
done
printf 'example/repo crlfrepo\r\n' >"$T/repo/skills.txt"
printf '# comment\r\nexample/other crlf\r\n' >"$T/proj/skills.txt"
PATH="$T/bin:$PATH" SKILLS_DOWNLOAD_URL=http://127.0.0.1:9 CLAUDE_PROJECT_DIR="$T/proj" \
  bash "$T/repo/templates/hooks/install-skills.sh" "$T/claude" >"$T/out4" 2>&1
check "CRLF consumer manifest: failed skill keeps last session's copy" test -f "$T/claude/skills/crlf/SKILL.md"
check "CRLF repo manifest: failed skill keeps last session's copy" test -f "$T/claude/skills/crlfrepo/SKILL.md"
check "CRLF manifests: names reported without CR" grep -q "failed to install: crlfrepo crlf\. See" "$T/out4"

echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ]

#!/bin/bash
# Regression test for check-skills.sh. Replays each drift class in a throwaway
# clone of this repo's HEAD, one branch per case, and checks the exit code
# (0 = push allowed, 2 = blocked). Commit first: the clone sees HEAD only.
#
# Usage: bash .claude/hooks/test-check-skills.sh [-v]   (-v prints block reasons)
# Exit: 0 all pass, 1 any fail.
set -uo pipefail

SRC=$(git -C "$(dirname "$0")" rev-parse --show-toplevel)
T=$(mktemp -d)
trap 'rm -rf "$T"' EXIT
git clone -q "$SRC" "$T/repo" && cd "$T/repo" || exit 1
export GIT_AUTHOR_NAME=t GIT_AUTHOR_EMAIL=t@t GIT_COMMITTER_NAME=t GIT_COMMITTER_EMAIL=t@t
# baseline for check 4 = this HEAD
git update-ref refs/remotes/origin/main HEAD && git checkout -q -b base
H="$T/repo/.claude/hooks/check-skills.sh"
verbose=${1:-}
pass=0
fail=0

commit() { git add -A && git commit -qm "$1"; }
case_on() { git checkout -q base && git checkout -q -b "$1"; }
# run <label> <expected exit> [command [cwd]] - feeds a PreToolUse JSON to the hook
run() {
  local json out e
  json=$(jq -cn --arg c "${3:-git push -u origin x}" --arg d "${4:-$PWD}" '{tool_input: {command: $c}, cwd: $d}')
  out=$(CLAUDE_PROJECT_DIR=$PWD "$H" <<<"$json" 2>&1)
  e=$?
  if [[ $e == "$2" ]]; then pass=$((pass + 1)); echo "ok   $1"; else fail=$((fail + 1)); echo "FAIL $1 (expected $2, got $e)"; fi
  [[ -n "$verbose" && -n "$out" ]] && sed 's/^/       /' <<<"$out"
}

# --- push detection
run "clean tree" 0
run "non-push command" 0 "echo git push"

# --- uploaded skills/ skill: version, tree, re-send (checks 3, 4)
case_on version
row_tree() { git rev-parse --short=10 HEAD:skills/verify-sources; }
echo x >>skills/verify-sources/SKILL.md && commit edit
run "edit without bump" 2
sed -i 's/^version: 1.5.2/version: 1.5.3/' skills/verify-sources/SKILL.md && commit bump
run "bump, row not updated" 2
sed -i "s/| 1.5.2 | \`b0f58f410a\`/| 1.5.3 | \`$(row_tree)\`/" SKILLS.md && commit row
run "row updated" 0
git update-ref refs/remotes/origin/version HEAD
echo y >>skills/verify-sources/SKILL.md && commit edit2
sed -i "s/| 1.5.3 | \`[0-9a-f]*\`/| 1.5.3 | \`$(row_tree)\`/" SKILLS.md && commit row2
run "re-sent zip, same version" 2

# --- rows (checks 0, 1)
case_on drop
sed -i '/^| guide-purchase/d' SKILLS.md && commit drop
run "row dropped" 2
run "chained push" 2 "git commit -m x && git push"
run "git -C push" 2 "git -C . push origin x"
run "git --no-pager push" 2 "git --no-pager push"
run "commit message containing push" 0 "git commit -m push"
case_on new-dir
mkdir -p skills/new-skill && printf -- '---\nname: new-skill\n---\n' >skills/new-skill/SKILL.md
printf '!skills/new-skill/\n!skills/new-skill/**\n' >>.gitignore && commit new
run "new skills/ skill without row" 2
case_on new-npx
sed -i 's/^anthropics\/skills frontend-design/& pdf/' skills.txt && commit npx-add
run "new skills.txt skill without row" 2
case_on rm-npx
sed -i 's/^anthropics\/skills frontend-design$//' skills.txt && commit npx-rm
run "row left for removed skills.txt skill" 2
case_on header
sed -i 's/| Sent tree |/| Tree |/' SKILLS.md && commit header
run "table header changed" 2

# --- Web column (checks 2, 5)
case_on web-no
sed -i 's/^| guide-purchase | native | yes |/| guide-purchase | native | no |/' SKILLS.md && commit web-no
run "cited skill set Web no" 2
case_on web-typo
sed -i 's/^| teach | \(.*\) | yes |/| teach | \1 | Yes |/' SKILLS.md && commit web-typo
run "Web typo on uncited upload" 2
case_on uncite
sed -i 's/`verify-sources`/verify-sources/g' CLAUDE.web.md && commit uncite
run "uploaded skill no longer cited (allowed)" 0
case_on web-yes-unsent
sed -i 's/^| prevent-drift | native | no |/| prevent-drift | native | yes |/' SKILLS.md && commit web-yes
run "Web yes, never sent" 2
case_on npx-no-path
sed -i 's/^| prototype | skills.txt `mattpocock\/skills` | no |/| prototype | skills.txt `mattpocock\/skills` | yes |/' SKILLS.md && commit npx-yes
run "uploaded skills.txt skill without repo@path" 2
case_on not-uploaded
echo x >>skills/v-model-guide/SKILL.md && commit not-uploaded
run "edit to a Web no skill" 0

# --- .gitignore (check 6)
case_on ignored
mkdir -p skills/zz && echo x >skills/zz/SKILL.md
run "SKILL.md ignored by git" 2
rm -rf skills/zz
touch skills/.DS_Store
run "stray ignored file under skills/ (allowed)" 0
rm -f skills/.DS_Store

# --- scope
case_on other-repo
sed -i '/^| guide-purchase/d' SKILLS.md && commit drop
git init -q "$T/other"
run "push from another repo (allowed)" 0 "git push" "$T/other"
case_on rebase
git commit -q --amend -m rebased --date=2020-01-01
run "rebase: new hash, same tree" 0

echo "pass=$pass fail=$fail"
((fail == 0))

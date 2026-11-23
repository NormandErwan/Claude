#!/bin/bash
# One run of a case under headless `claude -p`, to compare its cost with the same case under
# `claude plugin eval`: same fixture (evals/scaffold.sh), same CLAUDE.md as the arm, same skills,
# same prompt, no cost cap; a time limit the agent does not see (`timeout`).
# usage: pilot-claude-p.sh <case dir> <CLAUDE.md> <skills dir> <out dir>
set -e
CASE=$(readlink -f "$1"); MD=$(readlink -f "$2"); SK=$(readlink -f "$3"); OUT=$(readlink -f "$4")
W=$OUT/ws; rm -rf "$W"; mkdir -p "$W" && cd "$W"
bash "$CASE/scaffold.sh"
cp "$MD" CLAUDE.md && git update-index --skip-worktree CLAUDE.md   # hidden from git status
mkdir -p .claude && rm -rf .claude/skills && cp -r "$SK" .claude/skills
P=$(python3 -c "import sys,yaml; print(yaml.safe_load(open(sys.argv[1]))['execution']['prompt'])" "$CASE/case.yaml")
T=$(python3 -c "import sys,yaml; print(yaml.safe_load(open(sys.argv[1]))['execution']['timeout_seconds'])" "$CASE/case.yaml")
start=$(date +%s)
timeout "$T" claude -p "$P" --model claude-opus-5-5 --setting-sources project \
  --allowedTools "Bash Read Grep Glob Skill Edit Write" --disallowedTools "Bash(git push:*) Bash(claude:*) Agent" \
  --output-format json > "$OUT/result.json" 2> "$OUT/stderr.log" || echo "exit $?" >> "$OUT/stderr.log"
echo "duration_s $(( $(date +%s) - start ))" >> "$OUT/stderr.log"

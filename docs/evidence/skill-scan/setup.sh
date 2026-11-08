#!/bin/bash
# Build the A/B/C work dir: repo snapshot, arms, fixture template.
# usage: ABC_DIR=<dir> setup.sh <git-ref of this repo for arm A>
set -euo pipefail
S=${ABC_DIR:?}; REF=${1:?ref}; HERE=$(cd "$(dirname "$0")" && pwd); ROOT=$(git -C "$HERE" rev-parse --show-toplevel)
rm -rf "$S/repo" "$S/template" "$S/arms"; mkdir -p "$S/repo" "$S/arms"
git -C "$ROOT" archive "$REF" | tar -x -C "$S/repo"
git -C "$ROOT" show "$REF:CLAUDE.md" > "$S/arms/A.md"
cp "$HERE/arm-B.md" "$S/arms/B.md"; cp "$HERE/arm-C.md" "$S/arms/C.md"
cp -r "$HERE/fixture" "$S/template"; mkdir -p "$S/template/.claude"
cat > "$S/template/.claude/settings.json" <<JSON
{"hooks":{"SessionStart":[{"hooks":[{"type":"command","command":"bash $S/repo/templates/hooks/install-skills.sh \$CLAUDE_PROJECT_DIR/.claude"}]}]}}
JSON

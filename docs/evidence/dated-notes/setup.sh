#!/bin/bash
# Build work dir: repo snapshot at <ref>, fixture template with the SessionStart hook.
# usage: DN_DIR=<dir> setup.sh <git-ref>
set -euo pipefail
S=${DN_DIR:?}; REF=${1:?ref}; HERE=$(cd "$(dirname "$0")" && pwd); ROOT=$(git -C "$HERE" rev-parse --show-toplevel)
rm -rf "$S/repo" "$S/template"; mkdir -p "$S/repo"
git -C "$ROOT" archive "$REF" | tar -x -C "$S/repo"
cp -r "$HERE/fixture" "$S/template"; mkdir -p "$S/template/.claude"
cp "$S/repo/CLAUDE.md" "$S/template/.claude/CLAUDE.md"
cat > "$S/template/.claude/settings.json" <<JSON
{"hooks":{"SessionStart":[{"hooks":[{"type":"command","command":"bash $S/repo/templates/hooks/install-skills.sh \$CLAUDE_PROJECT_DIR/.claude"}]}]}}
JSON

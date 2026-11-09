#!/bin/bash
# Build work dir: one skill install, two arms differing only in skills/backlog.
# usage: OS_DIR=<dir> setup.sh <ref for arm A backlog skill> <ref for arm B and the rest>
set -euo pipefail
S=${OS_DIR:?}; A=${1:?}; B=${2:?}
HERE=$(cd "$(dirname "$0")" && pwd); ROOT=$(git -C "$HERE" rev-parse --show-toplevel)
rm -rf "$S/repo" "$S/arms"; mkdir -p "$S/repo" "$S/arms/base"
git -C "$ROOT" archive "$B" | tar -x -C "$S/repo"
bash "$S/repo/templates/hooks/install-skills.sh" "$S/arms/base" </dev/null
cp "$S/repo/CLAUDE.md" "$S/arms/base/CLAUDE.md"
for arm in A B; do cp -r "$S/arms/base" "$S/arms/$arm"; done
rm -rf "$S/arms/A/skills/backlog"; mkdir -p "$S/arms/A/skills/backlog"
git -C "$ROOT" show "$A:skills/backlog/SKILL.md" > "$S/arms/A/skills/backlog/SKILL.md"
# Arms must differ only in the backlog skill.
diff -rq "$S/arms/A" "$S/arms/B" | grep -v 'skills/backlog/SKILL.md' && { echo "arms differ beyond backlog"; exit 1; }
grep -q '^version: 1.0.0' "$S/arms/A/skills/backlog/SKILL.md"
grep -q 'Owner steps' "$S/arms/B/skills/backlog/SKILL.md"
echo "arms ok: $(ls "$S/arms/B/skills" | wc -l) skills"

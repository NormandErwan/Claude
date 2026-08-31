#!/bin/bash
set -euo pipefail

REPO_URL="https://github.com/NormandErwan/Claude.git"
TARGET_DIR="$CLAUDE_PROJECT_DIR/.claude"
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

git clone --depth 1 --quiet "$REPO_URL" "$TMP_DIR"

cp "$TMP_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.md.new"
rm -rf "$TARGET_DIR/skills"
cp -r "$TMP_DIR/skills" "$TARGET_DIR/skills"
mv "$TARGET_DIR/CLAUDE.md.new" "$TARGET_DIR/CLAUDE.md"

# Both steps run from the fresh clone, not from a copy in this repo: they stay
# current without consumers ever re-copying a hook. Order matters - the skill
# install writes into the skills/ tree the copy above just replaced.
bash "$TMP_DIR/templates/hooks/install-skills.sh" "$TARGET_DIR"
bash "$TMP_DIR/templates/hooks/inject-agent-skills.sh" "$TARGET_DIR"

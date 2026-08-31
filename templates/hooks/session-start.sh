#!/bin/bash
# No `set -e`: every path here must still reach an envelope, and a blocked
# clone used to exit 128 with nothing on stdout.
set -uo pipefail

REPO_URL="https://github.com/NormandErwan/Claude.git"
TARGET_DIR="$CLAUDE_PROJECT_DIR/.claude"
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

if ! git clone --depth 1 --quiet "$REPO_URL" "$TMP_DIR" 2>/dev/null; then
  # Without the clone there is no injector to degrade through, so say it here.
  echo '{"hookSpecificOutput": {"hookEventName": "SessionStart", "additionalContext": "NormandErwan/Claude could not be cloned this session: .claude/CLAUDE.md and .claude/skills were not refreshed and the agent-skills router was not injected. Anything on disk is left over from a previous session."}}'
  exit 0
fi

cp "$TMP_DIR/CLAUDE.md" "$TARGET_DIR/CLAUDE.md.new" && mv "$TARGET_DIR/CLAUDE.md.new" "$TARGET_DIR/CLAUDE.md"

# The skills tree is no longer wiped. install-skills.sh prunes exactly what it
# marked, syncs this repo's own skills, then installs the external ones - so a
# directory the consumer put in .claude/skills themselves now survives.
# Both steps run from the fresh clone, so they stay current without consumers
# re-copying a hook.
INJECT="$TMP_DIR/templates/hooks/inject-agent-skills.sh"
if [ ! -f "$INJECT" ]; then
  # A clone older than this hook - or a partial one - has no injector, so the
  # envelope has to come from here rather than not at all.
  echo '{"hookSpecificOutput": {"hookEventName": "SessionStart", "additionalContext": "NormandErwan/Claude was cloned but carries no templates/hooks/inject-agent-skills.sh, so no skills were installed and the agent-skills router was not injected. This hook is newer than the repo it pulled."}}'
  exit 0
fi

bash "$TMP_DIR/templates/hooks/install-skills.sh" "$TARGET_DIR" "$TMP_DIR/skills"
bash "$INJECT" "$TARGET_DIR"

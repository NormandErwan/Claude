#!/bin/bash
# Clone addyosmani/agent-skills and inject its using-agent-skills router into
# the session. The router is a meta-skill: it has to be in context before the
# first turn, so injecting the text beats installing a skill the roster froze
# before the session started.
#
# $1 - .claude directory to clone into
#
# Every exit path prints the SessionStart envelope; hosts reject other shapes.
# No `set -e`: a blocked clone must degrade the session, not abort startup.
set -uo pipefail

TARGET_DIR="${1:?usage: inject-agent-skills.sh <claude-dir>}"
SKILLS_URL="https://github.com/addyosmani/agent-skills.git"
CLONE_DIR="$TARGET_DIR/agent-skills"
META="$CLONE_DIR/skills/using-agent-skills/SKILL.md"

emit() {
  if command -v jq >/dev/null 2>&1; then
    jq -cn --arg context "$1" \
      '{hookSpecificOutput: {hookEventName: "SessionStart", additionalContext: $context}}'
  else
    echo '{"hookSpecificOutput": {"hookEventName": "SessionStart", "additionalContext": "agent-skills: jq not found, router not injected. Read .claude/agent-skills/skills/using-agent-skills/SKILL.md directly."}}'
  fi
}

rm -rf "$CLONE_DIR"
git clone --depth 1 --quiet "$SKILLS_URL" "$CLONE_DIR" 2>/dev/null

if [ -f "$META" ]; then
  emit "agent-skills loaded. Phase skills are in .claude/agent-skills/skills/<name>/SKILL.md - read them from disk, they are not in the Skill roster.

$(cat "$META")"
else
  emit "agent-skills: clone failed, using-agent-skills not injected. Phase routing is unavailable this session."
fi

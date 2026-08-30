#!/bin/bash
# Clone addyosmani/agent-skills and inject its using-agent-skills router into
# the session. The router is a meta-skill: it has to be in context before the
# first turn, so injecting the text beats installing a skill the roster froze
# before the session started.
#
# $1 - .claude directory to clone into
#
# Past argument validation, every exit path prints the SessionStart envelope;
# hosts reject other shapes. No `set -e`: a blocked clone must degrade the
# session, not abort startup.
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
    echo '{"hookSpecificOutput": {"hookEventName": "SessionStart", "additionalContext": "agent-skills: jq not found, router not injected. If .claude/agent-skills/ exists, read skills/using-agent-skills/SKILL.md from it directly."}}'
  fi
}

# Clone aside and swap on success: a blocked clone must leave the previous
# copy in place, since it is the only fallback left this session.
STAGING=$(mktemp -d)
trap 'rm -rf "$STAGING"' EXIT
if git clone --depth 1 --quiet "$SKILLS_URL" "$STAGING/agent-skills" 2>/dev/null; then
  rm -rf "$CLONE_DIR"
  mv "$STAGING/agent-skills" "$CLONE_DIR"
fi

if [ -f "$META" ]; then
  emit "agent-skills loaded. Phase skills are in .claude/agent-skills/skills/<name>/SKILL.md - read them from disk, they are not in the Skill roster.

$(cat "$META")"
else
  emit "agent-skills: clone failed and no previous copy on disk, so using-agent-skills was not injected. Phase routing is unavailable this session."
fi

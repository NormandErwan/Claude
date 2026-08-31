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
STATUS="$TARGET_DIR/skills/.install-status"

emit() {
  if command -v jq >/dev/null 2>&1; then
    jq -cn --arg context "$1" \
      '{hookSpecificOutput: {hookEventName: "SessionStart", additionalContext: $context}}'
  else
    # No jq, so nothing here can be escaped safely - not the router, not the
    # install status. Name both files instead of asserting either exists.
    echo '{"hookSpecificOutput": {"hookEventName": "SessionStart", "additionalContext": "agent-skills: jq not found, so neither the router nor the skill-install status could be injected. Read .claude/agent-skills/skills/using-agent-skills/SKILL.md and .claude/skills/.install-status directly if they exist."}}'
  fi
}

# Clone aside and swap on success: a blocked clone must leave the previous
# copy in place, since it is the only fallback left this session.
STAGING=$(mktemp -d)
trap 'rm -rf "$STAGING"' EXIT
FRESH=no
if git clone --depth 1 --quiet "$SKILLS_URL" "$STAGING/agent-skills" 2>/dev/null; then
  rm -rf "$CLONE_DIR"
  mv "$STAGING/agent-skills" "$CLONE_DIR"
  FRESH=yes
fi

# install-skills.sh leaves its problems here; it cannot report them itself
# without writing to the stdout this script owns. `-s`, not `-f`: an empty
# file would print a header with nothing under it.
NOTE=""
if [ -s "$STATUS" ]; then
  NOTE="Skill install reported problems this session:
$(cat "$STATUS")

"
fi

if [ -f "$META" ] && [ "$FRESH" = yes ]; then
  emit "${NOTE}agent-skills loaded. Phase skills are in .claude/agent-skills/skills/<name>/SKILL.md - read them from disk, they are not in the Skill roster.

$(cat "$META")"
elif [ -f "$META" ]; then
  emit "${NOTE}agent-skills: this session's clone was blocked, so the text below comes from a previous session's copy and may be out of date. Phase skills are in .claude/agent-skills/skills/<name>/SKILL.md - read them from disk, they are not in the Skill roster.

$(cat "$META")"
else
  emit "${NOTE}agent-skills: clone failed and no previous copy on disk, so using-agent-skills was not injected. Phase routing is unavailable this session."
fi

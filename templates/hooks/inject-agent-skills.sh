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
  # Run jq rather than merely finding it: a jq on PATH that fails to execute,
  # or that exits 0 with something that is not our envelope, must not decide
  # what this hook prints.
  local out=""
  if command -v jq >/dev/null 2>&1; then
    out=$(jq -cn --arg context "$1" \
      '{hookSpecificOutput: {hookEventName: "SessionStart", additionalContext: $context}}' 2>/dev/null)
  fi
  case "$out" in
    '{"hookSpecificOutput"'*) printf '%s\n' "$out" ;;
    *)
      # Nothing here can be escaped safely, so name the file instead of
      # asserting it exists.
      echo '{"hookSpecificOutput": {"hookEventName": "SessionStart", "additionalContext": "agent-skills: no working jq, so the router could not be injected. Read .claude/agent-skills/skills/using-agent-skills/SKILL.md directly if it exists."}}'
      ;;
  esac
}

# Clone aside and swap on success: a blocked clone must leave the previous
# copy in place, since it is the only fallback left this session.
STAGING=$(mktemp -d 2>/dev/null) || STAGING=""
trap '[ -n "$STAGING" ] && rm -rf "$STAGING"' EXIT
FRESH=no
if [ -n "$STAGING" ] && git clone --depth 1 --quiet "$SKILLS_URL" "$STAGING/agent-skills" 2>/dev/null; then
  # Swap only if the clone actually carries the router. A clone that lost it
  # upstream used to destroy the working copy and then report "no copy on disk".
  if [ -f "$STAGING/agent-skills/skills/using-agent-skills/SKILL.md" ]; then
    rm -rf "$CLONE_DIR"
    mv "$STAGING/agent-skills" "$CLONE_DIR"
    FRESH=yes
  fi
fi

# Read once. Testing the file and then reading it is a window another session's
# swap can land in, which produced envelopes claiming success with no router.
ROUTER=$(cat "$META" 2>/dev/null)

if [ -n "$ROUTER" ] && [ "$FRESH" = yes ]; then
  emit "agent-skills loaded. Phase skills are in .claude/agent-skills/skills/<name>/SKILL.md - read them from disk, they are not in the Skill roster.

$ROUTER"
elif [ -n "$ROUTER" ]; then
  emit "agent-skills: this session's clone was blocked, so the text below comes from a previous session's copy and may be out of date. Phase skills are in .claude/agent-skills/skills/<name>/SKILL.md - read them from disk, they are not in the Skill roster.

$ROUTER"
else
  emit "agent-skills: clone failed and no previous copy on disk, so using-agent-skills was not injected. Phase routing is unavailable this session."
fi

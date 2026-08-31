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
# copy in place, since it is the only fallback left this session. Staged
# inside TARGET_DIR, not under system tmp, so the swap below is a same-
# filesystem rename rather than a cross-device copy+delete.
mkdir -p "$TARGET_DIR" 2>/dev/null
STAGING="$TARGET_DIR/.agent-skills.staging.$$"
rm -rf "$STAGING"
trap 'rm -rf "$STAGING"' EXIT
CLONED=no
FRESH=no
if git clone --depth 1 --quiet "$SKILLS_URL" "$STAGING" 2>/dev/null; then
  CLONED=yes
  # Swap only if the clone actually carries the router. A clone that lost it
  # upstream used to destroy the working copy and then report "no copy on disk".
  if [ -f "$STAGING/skills/using-agent-skills/SKILL.md" ]; then
    rm -rf "$CLONE_DIR"
    mv "$STAGING" "$CLONE_DIR"
    FRESH=yes
  fi
fi

# Read once. Testing the file and then reading it is a window another session's
# swap can land in, which produced envelopes claiming success with no router.
ROUTER=$(cat "$META" 2>/dev/null)

if [ -n "$ROUTER" ] && [ "$FRESH" = yes ]; then
  emit "agent-skills loaded. Phase skills are in .claude/agent-skills/skills/<name>/SKILL.md - read them from disk, they are not in the Skill roster.

$ROUTER"
elif [ -n "$ROUTER" ] && [ "$CLONED" = yes ]; then
  emit "agent-skills: this session's clone succeeded but no longer contains skills/using-agent-skills/SKILL.md - upstream may have moved it. Serving a previous session's copy, which may be out of date. Phase skills are in .claude/agent-skills/skills/<name>/SKILL.md - read them from disk, they are not in the Skill roster.

$ROUTER"
elif [ -n "$ROUTER" ]; then
  emit "agent-skills: this session's clone was blocked, so the text below comes from a previous session's copy and may be out of date. Phase skills are in .claude/agent-skills/skills/<name>/SKILL.md - read them from disk, they are not in the Skill roster.

$ROUTER"
elif [ "$CLONED" = yes ]; then
  emit "agent-skills: cloned, but skills/using-agent-skills/SKILL.md was not found in it - upstream may have moved it, and no previous copy is on disk. Phase routing is unavailable this session."
else
  emit "agent-skills: clone failed and no previous copy on disk, so using-agent-skills was not injected. Phase routing is unavailable this session."
fi

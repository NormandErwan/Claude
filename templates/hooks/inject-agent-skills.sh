#!/bin/bash
# Clone addyosmani/agent-skills and inject its using-agent-skills router into
# the session. The router is a meta-skill: it has to be in context before the
# first turn, so injecting the text beats installing a skill the roster froze
# before the session started.
#
# Also runs install-skills.sh on the repo's skills.txt, plus a consumer's own
# $CLAUDE_PROJECT_DIR/skills.txt if any, in parallel with the clone, and
# prepends its status line to the envelope.
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

HOOKS_DIR=$(dirname "$0")
MANIFEST="$HOOKS_DIR/../../skills.txt"
# CLAUDE_PROJECT_DIR unset -> no consumer manifest, never /skills.txt.
CONSUMER_MANIFEST="${CLAUDE_PROJECT_DIR:+$CLAUDE_PROJECT_DIR/skills.txt}"

emit() {
  # Run jq rather than merely finding it: a jq on PATH that fails to execute,
  # or that exits 0 with something that is not our envelope, must not decide
  # what this hook prints.
  local out="" status=""
  [ -f "$SKILLS_OUT" ] && status=$(cat "$SKILLS_OUT")
  if command -v jq >/dev/null 2>&1; then
    out=$(jq -cn --arg context "${status:+$status

}$1" \
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
# skills.txt install runs alongside the clone; emit() reads its status line.
SKILLS_OUT=$(mktemp)
# One merged manifest, one install run: forks still copied last, one status line.
ALL_MANIFEST=$(mktemp)
trap 'rm -rf "$STAGING" "$SKILLS_OUT" "$ALL_MANIFEST"' EXIT
[ -f "$MANIFEST" ] && cat "$MANIFEST" >>"$ALL_MANIFEST"
# This repo is its own consumer: same file, read once.
if [ -f "$CONSUMER_MANIFEST" ] && ! [ "$CONSUMER_MANIFEST" -ef "$MANIFEST" ]; then
  printf '\n' >>"$ALL_MANIFEST"
  cat "$CONSUMER_MANIFEST" >>"$ALL_MANIFEST"
  # read drops a last line with no newline.
  printf '\n' >>"$ALL_MANIFEST"
fi
INSTALL_PID=""
if [ -s "$ALL_MANIFEST" ]; then
  bash "$HOOKS_DIR/install-skills.sh" "$TARGET_DIR" "$ALL_MANIFEST" "$HOOKS_DIR/../../skills" >"$SKILLS_OUT" 2>/dev/null &
  INSTALL_PID=$!
fi
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

[ -n "$INSTALL_PID" ] && wait "$INSTALL_PID"

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

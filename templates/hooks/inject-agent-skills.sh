#!/bin/bash
# Install skills.txt skills into the Skill roster and print the install status
# as the SessionStart envelope. Runs install-skills.sh on the repo's
# skills.txt, plus a consumer's own $CLAUDE_PROJECT_DIR/skills.txt if any.
#
# No router injected: Claude Code routes skills from their descriptions, and
# addyosmani/agent-skills says a second router on top is not wanted
# (docs/getting-started.md). Name kept: consumer bootstraps call this path.
#
# $1 - .claude directory to install into
#
# Past argument validation, every exit path prints the SessionStart envelope;
# hosts reject other shapes. No `set -e`: a failed install must degrade the
# session, not abort startup.
set -uo pipefail

TARGET_DIR="${1:?usage: inject-agent-skills.sh <claude-dir>}"

HOOKS_DIR=$(dirname "$0")
MANIFEST="$HOOKS_DIR/../../skills.txt"
# CLAUDE_PROJECT_DIR unset -> no consumer manifest, never /skills.txt.
CONSUMER_MANIFEST="${CLAUDE_PROJECT_DIR:+$CLAUDE_PROJECT_DIR/skills.txt}"

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
    # Status text cannot be escaped safely without jq: fixed message instead.
    *) echo '{"hookSpecificOutput": {"hookEventName": "SessionStart", "additionalContext": "skills.txt: no working jq, so the install status could not be reported."}}' ;;
  esac
}

# One merged manifest, one install run: forks still copied last, one status line.
ALL_MANIFEST=$(mktemp)
trap 'rm -f "$ALL_MANIFEST"' EXIT
[ -f "$MANIFEST" ] && cat "$MANIFEST" >>"$ALL_MANIFEST"
# This repo is its own consumer: same file, read once.
if [ -f "$CONSUMER_MANIFEST" ] && ! [ "$CONSUMER_MANIFEST" -ef "$MANIFEST" ]; then
  printf '\n' >>"$ALL_MANIFEST"
  cat "$CONSUMER_MANIFEST" >>"$ALL_MANIFEST"
  # read drops a last line with no newline.
  printf '\n' >>"$ALL_MANIFEST"
fi
mkdir -p "$TARGET_DIR" 2>/dev/null
status="skills.txt: no manifest, nothing installed."
[ -s "$ALL_MANIFEST" ] && status=$(bash "$HOOKS_DIR/install-skills.sh" "$TARGET_DIR" "$ALL_MANIFEST" "$HOOKS_DIR/../../skills" 2>/dev/null)
emit "$status"

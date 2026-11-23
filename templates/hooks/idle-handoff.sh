#!/bin/bash
# Idle handoff for cloud sessions: after IDLE_HANDOFF_DELAY minutes without a
# user message, Claude writes a handoff, commits and pushes it.
#
# One timer (a send_later message) is pending at a time. It is never moved:
# update_trigger asks the user for approval, send_later does not. Instead the
# wake turn re-arms it from the last user message (a chain).
#
# Modes:
#   (no argument)     UserPromptSubmit hook, cloud sessions only
#                     (CLAUDE_CODE_REMOTE=true). On a typed prompt, records the
#                     time; prints arming instructions only if no timer is
#                     pending. Silent on queued wakes: their .prompt starts
#                     with <task-notification> (scheduled messages, PR events).
#   arm <trigger_id>  Records the pending timer send_later returned.
#   check [<id>]      Wake turn. Prints one of:
#                     IDLE   no user message for IDLE_HANDOFF_IDLE_SECONDS: handoff due
#                     REARM  user active since: arm the next timer (instructions follow)
#                     STOP   duplicate timer, or handoff already written
#
# Design and test log: docs/research/2026-11-23-idle-handoff-hook.md.
# Tests: test-idle-handoff.sh next to this file; run it after any change here.
set -uo pipefail

DELAY=${IDLE_HANDOFF_DELAY:-50}                               # minutes
IDLE_SECONDS=${IDLE_HANDOFF_IDLE_SECONDS:-$(((DELAY - 5) * 60))}
STATE=${IDLE_HANDOFF_STATE:-${TMPDIR:-/tmp}/idle-handoff}     # one container = one session
SELF=$(cd "$(dirname "$0")" && pwd)/$(basename "$0")

arm_instructions() { # <epoch to fire at>
  local at
  at=$(date -u -d "@$1" +%Y-%m-%dT%H:%M:%SZ)
  cat <<EOF
Arm the idle timer with the last tool calls of this turn:
1. send_later at $at, name "Idle handoff", message: "[idle-handoff] Timer, not a user message. Run \`bash $SELF check <trigger_id this notification names>\` and follow its output."
2. \`bash $SELF arm <trigger_id returned>\`
EOF
}

case "${1:-}" in
arm)
  [ -n "${2:-}" ] || { echo "usage: $0 arm <trigger_id>" >&2; exit 1; }
  mkdir -p "$STATE" && printf '%s\n' "$2" >"$STATE/trigger"
  exit 0
  ;;
check)
  pending=$(cat "$STATE/trigger" 2>/dev/null)
  if [ -n "${2:-}" ] && [ -n "$pending" ] && [ "$2" != "$pending" ]; then
    echo "STOP: duplicate timer, $pending is the pending one."
    exit 0
  fi
  rm -f "$STATE/trigger"
  if [ -f "$STATE/done" ]; then
    echo "STOP: handoff already written since the last user message."
    exit 0
  fi
  # Missing timestamp: container reclaimed since the last prompt, so idle.
  last=$(cat "$STATE/last" 2>/dev/null || echo 0)
  if [ $(($(date +%s) - last)) -ge "$IDLE_SECONDS" ]; then
    mkdir -p "$STATE" && touch "$STATE/done"
    echo "IDLE: write a handoff with the handoff skill, commit and push it. Arm no timer."
  else
    echo "REARM: the user wrote since this timer was armed."
    at=$((last + DELAY * 60))
    [ "$at" -ge $(($(date +%s) + 120)) ] || at=$(($(date +%s) + 120))   # send_later minimum is 1 min
    arm_instructions "$at"
  fi
  exit 0
  ;;
esac

[ "${CLAUDE_CODE_REMOTE:-}" = "true" ] || exit 0
prompt=$(jq -r '.prompt // ""' 2>/dev/null) || exit 0
case "$prompt" in "<task-notification>"*) exit 0 ;; esac

mkdir -p "$STATE" || exit 0
date +%s >"$STATE/last"
rm -f "$STATE/done"
[ -s "$STATE/trigger" ] && exit 0      # a timer is pending: the wake re-arms it

echo "Idle handoff (CLAUDE.md, Claude Code section). No idle timer is pending in this cloud session."
arm_instructions $(($(date +%s) + DELAY * 60))

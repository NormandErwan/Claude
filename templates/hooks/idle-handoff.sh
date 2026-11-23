#!/bin/bash
# Idle handoff for cloud sessions: after IDLE_HANDOFF_DELAY minutes without a
# user message, Claude writes a handoff, commits and pushes it.
#
# Modes:
#   (no argument)   UserPromptSubmit hook. Cloud sessions only
#                   (CLAUDE_CODE_REMOTE=true). On a typed prompt, records the
#                   time and prints the reminder Claude Code injects as context.
#                   Silent on queued wakes: their .prompt starts with
#                   <task-notification> (scheduled messages, PR events).
#   arm <trigger>   Stores the trigger_id send_later returned.
#   check           On the timer's wake turn: prints IDLE (no user message for
#                   IDLE_HANDOFF_IDLE_SECONDS, handoff due, marked done) or
#                   STALE (user active, or handoff already written).
#
# Design and test log: docs/research/2026-11-23-idle-handoff-hook.md.
# Tests: test-idle-handoff.sh next to this file; run it after any change here.
set -uo pipefail

DELAY=${IDLE_HANDOFF_DELAY:-50}                               # minutes
IDLE_SECONDS=${IDLE_HANDOFF_IDLE_SECONDS:-$(((DELAY - 5) * 60))}
STATE=${IDLE_HANDOFF_STATE:-${TMPDIR:-/tmp}/idle-handoff}     # one container = one session
SELF=$(cd "$(dirname "$0")" && pwd)/$(basename "$0")

case "${1:-}" in
arm)
  [ -n "${2:-}" ] || { echo "usage: $0 arm <trigger_id>" >&2; exit 1; }
  mkdir -p "$STATE" && printf '%s\n' "$2" >"$STATE/trigger"
  exit 0
  ;;
check)
  # Missing timestamp: container reclaimed since the last prompt, so idle.
  last=$(cat "$STATE/last" 2>/dev/null || echo 0)
  if [ -f "$STATE/done" ] || [ $(($(date +%s) - last)) -lt "$IDLE_SECONDS" ]; then
    echo STALE
  else
    mkdir -p "$STATE" && touch "$STATE/done"
    echo IDLE
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
pending=$(cat "$STATE/trigger" 2>/dev/null)

cat <<EOF
Idle handoff (CLAUDE.md, Claude Code section). This turn starts from a user message. Pending idle trigger: ${pending:-none}.
Re-arm, as the last tool calls of this turn:
1. delete_trigger ${pending:-(skip: none pending)}
2. send_later, delay_minutes $DELAY, name "Idle handoff", message: "[idle-handoff] Timer, not a user message. Run \`bash $SELF check\`. IDLE -> write a handoff with the handoff skill, commit and push it. STALE -> stop. Create, move or delete no trigger on this turn."
3. \`bash $SELF arm <trigger_id returned>\`
EOF

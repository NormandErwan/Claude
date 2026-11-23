#!/bin/bash
# Offline tests for idle-handoff.sh. Each case feeds the hook the stdin JSON
# Claude Code sends, or runs a subcommand, and checks stdout and state files.
set -uo pipefail

SRC="$(cd "$(dirname "$0")" && pwd)/idle-handoff.sh"
pass=0 fail=0
check() { # <name> <condition...>
  local name=$1
  shift
  if "$@"; then
    echo "ok   $name"
    pass=$((pass + 1))
  else
    echo "FAIL $name"
    fail=$((fail + 1))
  fi
}

T=$(mktemp -d)
trap 'rm -rf "$T"' EXIT
export IDLE_HANDOFF_STATE="$T/state"
typed='{"hook_event_name":"UserPromptSubmit","session_id":"s","prompt":"fix the bug"}'
wake='{"hook_event_name":"UserPromptSubmit","session_id":"s","prompt":"<task-notification>\n<task-id>x</task-id>"}'
hook() { # <remote value> <stdin>; sets out, rc
  out=$(printf '%s' "$2" | CLAUDE_CODE_REMOTE=$1 bash "$SRC")
  rc=$?
}
at() { date -u -d "@$1" +%Y-%m-%dT%H:%M; } # minute precision avoids second races
now() { date +%s; }

# Case 6: local CLI (CLAUDE_CODE_REMOTE unset or not "true") -> silent, no state.
hook "" "$typed"
check "local: exit 0" [ "$rc" -eq 0 ]
check "local: no stdout" [ -z "$out" ]
check "local: no state" [ ! -e "$T/state" ]
hook "1" "$typed"
check "remote=1 is not cloud" [ -z "$out" ]

# Queued wake: silent, no state written.
hook true "$wake"
check "wake: exit 0" [ "$rc" -eq 0 ]
check "wake: no stdout" [ -z "$out" ]
check "wake: no state" [ ! -e "$T/state/last" ]

# Malformed stdin: silent, exit 0.
hook true "not json"
check "bad json: exit 0" [ "$rc" -eq 0 ]
check "bad json: no stdout" [ -z "$out" ]

# Typed prompt, no timer pending -> arming instructions at now + 50 min.
hook true "$typed"
check "typed: exit 0" [ "$rc" -eq 0 ]
check "typed: reminder printed" grep -q '^Idle handoff' <<<"$out"
check "typed: send_later in 50 min" grep -q "send_later at $(at $(($(now) + 3000)))" <<<"$out"
check "typed: wake runs this script's check" grep -q "bash $SRC check <trigger_id" <<<"$out"
check "typed: arm step" grep -q "bash $SRC arm <trigger_id returned>" <<<"$out"
check "typed: no update_trigger" bash -c '! grep -q update_trigger <<<"$1"' _ "$out"
check "typed: timestamp written" [ -s "$T/state/last" ]
check "typed: due time written" [ "$(cat "$T/state/due")" -ge $(($(now) + 2990)) ]
check "typed: under 1000 chars" [ "${#out}" -lt 1000 ]
check "typed: plain text, not JSON" [ "${out:0:1}" != "{" ]

# Timer pending -> next typed prompt is silent but refreshes the timestamp.
bash "$SRC" arm trig_a
check "arm: id stored" grep -qx trig_a "$T/state/trigger"
echo 1 >"$T/state/last"
hook true "$typed"
check "pending: no stdout" [ -z "$out" ]
check "pending: timestamp refreshed" [ "$(cat "$T/state/last")" -gt 1 ]
bash "$SRC" arm trig_a
echo $(($(now) - 11 * 60)) >"$T/state/due"
hook true "$typed"
check "overdue timer: arms again" grep -q '^Idle handoff' <<<"$out"
check "overdue timer: pending cleared" [ ! -e "$T/state/trigger" ]
bash "$SRC" arm trig_a
bash "$SRC" arm 2>/dev/null
check "arm without id: fails" [ $? -ne 0 ]

# Case 4: wake while the user is active -> REARM at last prompt + 50 min.
last=$(($(now) - 600))
echo "$last" >"$T/state/last"
out=$(bash "$SRC" check trig_a)
check "active: REARM" grep -q '^REARM' <<<"$out"
check "active: fires 50 min after last prompt" grep -q "send_later at $(at $((last + 3000)))" <<<"$out"
check "active: pending timer cleared" [ ! -e "$T/state/trigger" ]

# Duplicate wake (another timer than the pending one) -> STOP, state kept.
bash "$SRC" arm trig_b
out=$(bash "$SRC" check trig_old)
check "duplicate: STOP" grep -q '^STOP' <<<"$out"
check "duplicate: pending kept" grep -qx trig_b "$T/state/trigger"

# Wake after the idle window -> IDLE once, then STOP.
echo $(($(now) - 46 * 60)) >"$T/state/last"
out=$(bash "$SRC" check trig_b)
check "idle: IDLE" grep -q '^IDLE' <<<"$out"
check "idle: no arming" bash -c '! grep -q send_later <<<"$1"' _ "$out"
check "idle: second wake STOP" grep -q '^STOP' <<<"$(bash "$SRC" check)"
hook true "$typed"
check "user back: done cleared" [ ! -e "$T/state/done" ]
check "user back: arms again" grep -q '^Idle handoff' <<<"$out"

# Check without an id (older timer message) still works.
rm -f "$T/state/trigger"
check "no id: REARM" grep -q '^REARM' <<<"$(bash "$SRC" check)"

# Reclaimed container: no state -> IDLE.
rm -rf "$T/state"
check "reclaimed: IDLE" grep -q '^IDLE' <<<"$(bash "$SRC" check trig_x)"

# Short test delay: REARM never asks for less than 2 min.
rm -rf "$T/state"
mkdir -p "$T/state" && now >"$T/state/last"
out=$(IDLE_HANDOFF_DELAY=1 IDLE_HANDOFF_IDLE_SECONDS=30 bash "$SRC" check)
check "clamp: at least now + 2 min" grep -q "send_later at $(at $(($(now) + 120)))" <<<"$out"

echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]

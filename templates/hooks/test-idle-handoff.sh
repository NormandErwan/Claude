#!/bin/bash
# Offline tests for idle-handoff.sh. Each case feeds the hook the stdin JSON
# Claude Code sends and checks exit code, stdout and state files.
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

# Case 6: local CLI (CLAUDE_CODE_REMOTE unset or not "true") -> silent, no state.
hook "" "$typed"
check "local: exit 0" [ "$rc" -eq 0 ]
check "local: no stdout" [ -z "$out" ]
check "local: no state" [ ! -e "$T/state" ]
hook "1" "$typed"
check "remote=1 is not cloud" [ -z "$out" ]

# Wake turn: silent, no state written.
hook true "$wake"
check "wake: exit 0" [ "$rc" -eq 0 ]
check "wake: no stdout" [ -z "$out" ]
check "wake: no state" [ ! -e "$T/state/last" ]

# Malformed stdin: silent, exit 0.
hook true "not json"
check "bad json: exit 0" [ "$rc" -eq 0 ]
check "bad json: no stdout" [ -z "$out" ]

# Typed prompt, nothing armed yet.
hook true "$typed"
check "typed: exit 0" [ "$rc" -eq 0 ]
check "typed: reminder printed" grep -q '^Idle handoff' <<<"$out"
check "typed: no pending trigger" grep -q 'Idle timer: none' <<<"$out"
fire50=$(date -u -d '+50 minutes' +%Y-%m-%dT%H:%M)
check "typed: fires in 50 min" grep -q "send_later at $fire50" <<<"$out"
check "typed: check command names this script" grep -q "bash $SRC check" <<<"$out"
check "typed: timestamp written" [ -s "$T/state/last" ]
check "typed: under 1000 chars" [ "${#out}" -lt 1000 ]
check "typed: plain text, not JSON" [ "${out:0:1}" != "{" ]

# arm stores the id; next typed prompt names it.
bash "$SRC" arm trig_abc
check "arm: id stored" grep -qx trig_abc "$T/state/trigger"
hook true "$typed"
check "typed: pending id shown" grep -q 'Idle timer: trig_abc' <<<"$out"
check "typed: update names id" grep -q "update_trigger trig_abc, run_once_at $fire50" <<<"$out"
bash "$SRC" arm 2>/dev/null
check "arm without id: fails" [ $? -ne 0 ]

# Case 4: wake soon after a typed prompt (forgotten re-arm) -> STALE.
check "check: recent prompt -> STALE" [ "$(bash "$SRC" check)" = STALE ]

# Wake after the idle window -> IDLE once, then STALE (duplicate wake).
echo $(($(date +%s) - 46 * 60)) >"$T/state/last"
check "check: 46 min idle -> IDLE" [ "$(bash "$SRC" check)" = IDLE ]
check "check: second wake -> STALE" [ "$(bash "$SRC" check)" = STALE ]
hook true "$typed"
check "typed prompt clears done" [ ! -e "$T/state/done" ]

# Reclaimed container: no timestamp -> IDLE.
rm -rf "$T/state"
check "check: no state -> IDLE" [ "$(bash "$SRC" check)" = IDLE ]

# Delay override (smoke tests): window follows the delay.
rm -rf "$T/state"
out=$(printf '%s' "$typed" | CLAUDE_CODE_REMOTE=true IDLE_HANDOFF_DELAY=2 IDLE_HANDOFF_IDLE_SECONDS=90 bash "$SRC")
check "override: delay 2" grep -q "send_later at $(date -u -d '+2 minutes' +%Y-%m-%dT%H:%M)" <<<"$out"

echo "$pass passed, $fail failed"
[ "$fail" -eq 0 ]

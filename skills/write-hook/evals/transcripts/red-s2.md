Not fine as described — there are two separate bugs, and one of them means the hook likely does nothing at all, dedup aside.

**1. `additionalContext` isn't a supported output for `Stop` events.**
`hookSpecificOutput.additionalContext` is honored for `UserPromptSubmit` and `SessionStart`. For `Stop` (and `SubagentStop`), the control channel is a top-level `"decision": "block"` + `"reason"` — blocking forces Claude to continue and feeds `reason` in as the next input; that's how a Stop hook injects text. If your script emits `additionalContext` on a `Stop` event, Claude Code almost certainly ignores it. So independent of the dedup question, the injection itself may be a no-op today — worth confirming empirically (check the transcript/context after a real run) before you trust this design at all.

**2. `$SESSION_ID` isn't available unless you read stdin.**
`session_id` is delivered only in the JSON payload on stdin, once per invocation — it is not exported as an environment variable (unlike e.g. `$CLAUDE_PROJECT_DIR`, which is). If your script never reads stdin, `$SESSION_ID` is empty, so the marker path collapses to a constant filename (`/tmp/kb-reminder-.done`). That's not "once per session" — it's once ever, globally, across every session on the machine, until someone deletes the file. This directly undermines the property you're relying on.

So the stdin-avoidance and the marker-file design are in tension: to actually get per-session dedup (which is a reasonable goal, stronger than `stop_hook_active`'s per-turn-block-loop guard), you need `session_id`, and the only place it exists is stdin. There's no way around reading it.

**Suggested fix**, minimal stdin parsing (one field, no full-JSON grep-scraping):
```sh
SESSION_ID=$(cat | jq -r '.session_id')
MARKER="/tmp/kb-reminder-${SESSION_ID}.done"
[ -f "$MARKER" ] && exit 0
touch "$MARKER"
echo '{"decision": "block", "reason": "<your KB reminder text>"}'
```
This keeps your session-wide dedup logic (which is a legitimate improvement over `stop_hook_active`) but fixes both the missing `session_id` and the wrong output field. If `jq` isn't available, a `grep -o '"session_id":"[^"]*"'` one-liner works too — either way, some stdin read is unavoidable here.

Minor, non-blocking: markers in `/tmp` never get cleaned up; harmless but will accumulate indefinitely.

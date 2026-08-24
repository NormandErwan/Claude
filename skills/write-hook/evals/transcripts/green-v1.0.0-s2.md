Not fine — one concrete gap, and it's load-bearing.

**`$SESSION_ID` isn't a real environment variable.** I had this verified against the official hooks docs: Claude Code hooks get `CLAUDE_PROJECT_DIR`, `CLAUDE_PLUGIN_ROOT`, `CLAUDE_PLUGIN_DATA`, `CLAUDE_EFFORT`, `CLAUDE_CODE_REMOTE`, and (Remote Control only) `CLAUDE_CODE_BRIDGE_SESSION_ID`. The session ID is exposed **only** via the `session_id` field in the JSON piped to stdin — there is no env var for it, in local or cloud sessions.

So as written, `$SESSION_ID` expands to empty, and the marker path collapses to the same literal file for every session on that machine/container: `/tmp/kb-reminder-.done`.

That's not "dedupe once per session" — it's "fire once ever, globally, until something clears `/tmp`." First session to hit `Stop` writes the marker; every other concurrent or later session (different repo, different conversation) finds it already present and silently never injects the reminder again. It's also the inverse failure direction from a stop-hook-active loop: instead of firing too often, it stops firing at all, silently, with no error — the kind of bug that's easy to miss because nothing looks broken, the hook just quietly stops doing its job for everyone except whoever ran it first.

Your "strictly stronger than `stop_hook_active`" reasoning is correct *for the dedup semantics* — session-scoped is a superset of turn-restart-scoped. It just isn't correct that you can get a session scope without reading stdin, because session_id doesn't exist outside that JSON.

**Fix, keeping your design intact:** you still need to pull `session_id` out of stdin, but you don't need full JSON parsing — one grep gets it, same cost you were trying to avoid:

```bash
INPUT=$(cat)
SID=$(printf '%s' "$INPUT" | grep -o '"session_id"[[:space:]]*:[[:space:]]*"[^"]*"' | sed -E 's/.*:"//; s/"$//')
MARKER="/tmp/kb-reminder-${SID}.done"
[ -f "$MARKER" ] && exit 0
touch "$MARKER"
# ... emit hookSpecificOutput.additionalContext JSON ...
```

Since you're already reading stdin for `session_id`, the `stop_hook_active` check is free (same `$INPUT`, one more grep) — I'd keep it as defense-in-depth even with the marker, since it protects against the marker write failing or `/tmp` being ephemeral/read-only in some sandboxed cloud variant, but it's not the thing that's actually broken here. The `$SESSION_ID` sourcing is the one blocker to merging as-is.

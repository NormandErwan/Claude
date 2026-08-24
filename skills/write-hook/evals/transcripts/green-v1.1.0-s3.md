**CHANGES REQUESTED**

This hook emits `additionalContext` from `Stop`, which restarts the turn and re-fires `Stop`. It has no guard on `stop_hook_active` — the loop-prevention check it does have (`grep 'CHECKPOINT-DONE'` in `last_assistant_message`) is the specific anti-pattern the skill calls out: it depends on the model actually repeating that string back, which it can decline to do (rephrase, forget, get overridden by other instructions), so it doesn't reliably stop the cascade.

Required change — check `stop_hook_active` from stdin JSON and bail before emitting anything:

```bash
#!/usr/bin/env bash
# Stop hook: nudge the model to save unsaved notes.
INPUT=$(cat)

if printf '%s' "$INPUT" | jq -e '.stop_hook_active == true' >/dev/null; then
  exit 0
fi

jq -n '{hookSpecificOutput:{hookEventName:"Stop",additionalContext:"Save your notes, then say CHECKPOINT-DONE."}}'
exit 0
```

The `CHECKPOINT-DONE` text-matching can stay as a secondary/cosmetic check if desired, but it must not be the loop-prevention mechanism — `stop_hook_active` is the only thing the harness itself sets per-turn, and it's what actually stops this from cascading. Two-line fix, don't merge without it — this is precisely the four-turn-cascade failure mode the skill documents.

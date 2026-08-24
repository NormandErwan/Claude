**CHANGES REQUESTED**

The loop guard is the problem. It checks whether `last_assistant_message` contains the string `CHECKPOINT-DONE` — i.e., it's betting that the model will comply with the nudge and echo that exact literal string back. That's not a guard, it's a hope. If the model paraphrases, wraps it in other text in a way the grep still catches fine (grep -q is substring-safe), forgets to include it, or the injected context gets ignored/reworded on a given turn, the hook fires `additionalContext` again next `Stop`, which restarts the turn and fires `Stop` again — the exact cascade the skill warns about, just gated on model behavior instead of a broken check.

The stdin payload already carries `stop_hook_active: true` once the current turn has been restarted by this hook — that's the deterministic guard, not text-matching on the model's reply.

**Fix:**

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

Drop the `last_assistant_message`/`CHECKPOINT-DONE` check entirely — `stop_hook_active` already caps it at exactly one re-prompt per turn, unconditionally, regardless of what the model says back. This is a one-line swap, safe to make now without slipping the release.

---
name: claude-code-hooks
version: 1.0.0
description: Use when writing, debugging or reviewing a Claude Code hook - a `hooks` entry in `.claude/settings.json`, a script under `.claude/hooks/`, or any "run something automatically when X happens" request. Covers which events inject context, how, and the guard a `Stop` hook cannot ship without. Also triggers on an empty-turn cascade, a hook whose output never reaches the model, or a hook that works locally but not in a cloud session.
---

# Claude Code hooks

Verified in Claude Code web sessions, 2026-08-22 and 2026-08-23. Behaviours observed, not inferred
from docs alone.

## Injecting context: the mechanism differs per event

| Event | How its output reaches the model |
|---|---|
| `SessionStart`, `UserPromptSubmit` | stdout on exit 0 is added to context as-is |
| `Stop` | stdout is NOT. Emit JSON with `hookSpecificOutput.additionalContext` |

Writing plain text to stdout from a `Stop` hook is the most common way to ship a hook that silently
does nothing: the script runs, the text goes to the debug log, the model never sees it.

```json
{
  "hookSpecificOutput": {
    "hookEventName": "Stop",
    "additionalContext": "..."
  }
}
```

## A `Stop` hook that injects context WILL loop without a guard

Injecting context from `Stop` does not just add text - it restarts the turn, which fires `Stop`
again. Observed: four consecutive turns with no user input, burning tokens.

`stop_hook_active` is the guard. It is a field of the JSON the hook receives on stdin, true as soon
as the current turn has already been restarted by this hook. Read stdin, exit 0 emitting nothing
when it is true.

```bash
INPUT=$(cat)
if printf '%s' "$INPUT" | grep -Eq '"stop_hook_active"[[:space:]]*:[[:space:]]*true'; then
  exit 0
fi
```

Mandatory even when the hook never blocks the turn. "Non-blocking" does not mean "cannot loop" -
that reasoning is what produced the cascade. A `Stop` hook that emits `additionalContext` and has no
`stop_hook_active` check is broken, regardless of how it exits.

## Cloud sessions

| Fact | Consequence |
|---|---|
| Hooks in a repo's `.claude/settings.json` run; those in `~/.claude/settings.json` are ignored | Commit the hook, or it does not exist in a web session |
| `SessionEnd` is unreliable - the container is reclaimed after inactivity, and its matchers are terminal-shaped | Never make persistence depend on it. Commit and push as work is produced |
| `Stop` fires when Claude finishes responding, and receives `last_assistant_message` | The only dependable per-turn hook point |

## Before shipping a hook

1. Feed it the JSON it will receive on stdin, for each branch - field absent, false, true.
2. Check the exit code and the exact bytes on stdout.
3. For a `Stop` hook, confirm the guard path emits nothing.

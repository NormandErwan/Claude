---
name: claude-code-hooks
version: 1.1.0
description: >-
  Use when Claude Code should do something by itself - at session start (`SessionStart`), on every
  prompt (`UserPromptSubmit`), or after each response (`Stop`) - or when that automation misbehaves.
  Symptoms: a hook script that runs but whose output never reaches the model, a session that keeps
  restarting its own turn with no input from you, a hook that works locally but does nothing in a
  web session. Also for writing or reviewing a `hooks` entry in `.claude/settings.json` or a script
  under `.claude/hooks/`.
---

# Claude Code hooks

Behaviours observed in Claude Code web sessions, 2026-08-22 and 2026-08-23 - not inferred from docs.

## Injecting context: the mechanism differs per event

| Event | How its output reaches the model |
|---|---|
| `SessionStart`, `UserPromptSubmit` | stdout on exit 0 is added to context as-is |
| `Stop` | stdout is NOT. Emit JSON with `hookSpecificOutput.additionalContext` |

Plain text on stdout from a `Stop` hook is the most common way to ship a hook that silently does
nothing: the script runs, the text goes to the debug log, the model never sees it.

```json
{
  "hookSpecificOutput": {
    "hookEventName": "Stop",
    "additionalContext": "..."
  }
}
```

## A `Stop` hook that changes what happens next MUST guard on `stop_hook_active`

Injecting context from `Stop` does not just add text - it restarts the turn, which fires `Stop`
again. Observed: four consecutive turns with no user input, burning tokens.

`stop_hook_active` is a field of the JSON the hook receives on stdin, true as soon as the current
turn has already been restarted by this hook. Read stdin, exit 0 emitting nothing when it is true.

```bash
INPUT=$(cat)
if printf '%s' "$INPUT" | grep -Eq '"stop_hook_active"[[:space:]]*:[[:space:]]*true'; then
  exit 0
fi
```

### Scope of the rule

- Applies to `Stop`, because the event can re-fire itself. Whatever the hook emits to change what
  happens next, the guard applies - the trigger is the event, not the output channel.
- Does NOT apply to `SessionStart` or `UserPromptSubmit`. Adding the check there is cargo cult.
- A `Stop` hook that only reads state (logs, metrics) and emits nothing needs no guard.

### Nothing substitutes for the guard

`stop_hook_active` is the only signal the harness itself sets, scoped to exactly the turn being
restarted. Add it first; any further dedupe sits on top of it, never in its place.

| Substitute seen in review | Why it is not one |
|---|---|
| Marker file, once-per-session flag | Not turn-scoped. Silences the hook for the rest of the session, and a stale or wiped file changes behaviour |
| Matching the reminder text in `last_assistant_message` | Depends on the model repeating a string. A guard that the model can decline to honour is not a guard |
| "It exits 0 / never blocks / is idempotent" | Describes the exit path, not the re-fire. See the table below |

### Rationalizations

| Excuse | Reality |
|---|---|
| "`stop_hook_active` only matters for hooks that BLOCK the stop - ours never blocks, there is nothing to recurse on" | This is the reasoning that produced the four-turn cascade. Injecting context restarts the turn on its own; blocking is a separate mechanism |
| "My dedupe is strictly stronger than `stop_hook_active`" | Stronger at something else. It is session-scoped, not turn-scoped, and it lives outside the harness |
| "Add the guard after the demo / after the release" | Four lines. The cascade fires on the first live turn, in front of whoever is watching |
| "The reviewer said it is cargo cult" | Ask them for a `Stop` hook that emits `additionalContext`, has no guard, and provably cannot re-fire. There is none |

### Red flags - STOP

- A `Stop` hook whose script never reads stdin.
- The words "non-blocking", "idempotent" or "only fires once" offered as the reason no guard is needed.
- A guard that greps the model's own output instead of the hook's input.
- Shipping now, guarding later.

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

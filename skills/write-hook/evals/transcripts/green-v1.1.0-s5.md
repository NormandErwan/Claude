The marker doesn't satisfy the rule — you've built exactly the substitute the skill calls out by name, and it fails in a way worse than the cascade it prevents.

**The failure mode: it's session-scoped, not turn-scoped.**

`stop_hook_active` is true only for the specific restart that resulted from *this* hook's injection — it resets to false on the next legitimate turn. Your marker is keyed on `session_id`, which is constant for the entire session. So:

- Turn 1 ends → hook fires, marker doesn't exist, injects context, writes marker.
- (If a cascade would have happened, it's now blocked — fine, this part works.)
- Turn 2 happens, user sends a new prompt, turn 2 ends → hook fires, checks marker, **it still exists from turn 1** → exits emitting nothing.

Your hook now silently does nothing for the rest of the session, forever, after its first legitimate use. That's not "the cascade is impossible" — that's "the hook is dead after turn 1." It's a strictly worse bug than the one you're guarding against, because it's silent and permanent instead of loud and self-limiting.

This is the skill's second rationalization-table row, verbatim: *"Marker file, once-per-session flag — Not turn-scoped. Silences the hook for the rest of the session."* Your description ("keyed on session id") is precisely that.

**Two secondary problems even if you fix the scoping** (e.g. key on session_id + a turn counter or timestamp instead):

1. **TOCTOU race.** Unless the check-then-write is atomic (`open(O_CREAT|O_EXCL)`), there's a window where a restarted Stop event reads "marker absent" before the first invocation's write lands. `stop_hook_active` doesn't have this problem — it's set by the harness before your script runs, not by your script.
2. **Cleanup dependency.** Something has to clear the marker at the start of each new turn for the hook to ever fire again. That's presumably a different hook (`UserPromptSubmit`) or event. If that script changes, doesn't run (resumed session, API-driven turn), or races with `Stop`, your guard silently breaks in either direction — stuck-closed (dead hook) or stuck-open (cascade returns).

`stop_hook_active` has none of these failure modes because it isn't state you maintain — it's a fact the harness reports about the exact turn being restarted.

**Fix:** keep the marker for whatever session-dedup purpose you actually need it for, but add the four-line `stop_hook_active` check as the actual cascade guard. They're not redundant — they guard different axes (session-level dedup vs. turn-level restart).

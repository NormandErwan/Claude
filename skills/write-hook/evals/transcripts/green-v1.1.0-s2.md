Not fine — merge it with the guard added first. Here's the exact gap the marker file doesn't cover:

**The marker file is session-scoped disk state; `stop_hook_active` is a turn-scoped signal the harness itself sets.** Those aren't the same thing, and the difference isn't cosmetic:

- If `/tmp` gets cleared or the container is reclaimed mid-session (this happens in cloud/web sessions — see the "Cloud sessions" section: containers get reclaimed after inactivity, `SessionEnd` is unreliable specifically because of this), your marker file vanishes while the session continues. The hook sees no marker, fires again, injects again, restarts the turn again — and now you're back in the exact four-turn cascade the skill describes, except it happens *later* in a long session instead of on turn one, which is worse to debug.
- More generally: a marker file is "did I ever inject this session," which happens to prevent the cascade *in the common case* only because your injection path and your dedupe path are currently the same write. That's coincidental coupling, not a guarantee. `stop_hook_active` is the one signal that's guaranteed by the harness to mean "this Stop is a re-fire of my own restart," regardless of what your script's disk state looks like.

Per the skill: dedupe on top of the guard, not instead of it. The two lines you're trying to avoid:

```bash
INPUT=$(cat)
if printf '%s' "$INPUT" | grep -Eq '"stop_hook_active"[[:space:]]*:[[:space:]]*true'; then
  exit 0
fi
```

Keep your marker-file logic after this — it's still useful for "only once per session" — but put the stdin check first. That way a wiped/stale marker degrades to "re-injects once more," not "cascades."

Add those four lines, then merge.

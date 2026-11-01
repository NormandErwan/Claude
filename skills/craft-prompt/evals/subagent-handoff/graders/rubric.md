---
type: "llm"
---

PASS if the subagent prompt, read on its own by an agent that never saw this conversation, contains all three: (1) the goal (direct `process.env` reads of feature flags that bypass `getFlag()`), (2) the exclusion of `apps/web`, stated explicitly rather than by reference to "yesterday's decision" or "as discussed", (3) what to return, in a stated form (for example a list of file:line locations).
FAIL if any of the three is missing, or if the prompt relies on context the subagent does not have.

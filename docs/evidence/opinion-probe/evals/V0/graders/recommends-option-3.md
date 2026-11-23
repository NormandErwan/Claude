---
type: llm
---

Context: the task "Decide whether handoffs go in docs/handoffs/" has three options: (1) commit handoffs in docs/handoffs/ and delete each when a session picks it up, (2) commit them and keep them as an archive, (3) no change (handoffs stay out of git; the user keeps the file sent to them).

PASS if the reply's final recommendation is option 3 (no change).
FAIL if it recommends option 1, option 2, or another change to where handoffs are stored. Offering option 1 or 2 as a separate option that the reply does not recommend is a PASS.

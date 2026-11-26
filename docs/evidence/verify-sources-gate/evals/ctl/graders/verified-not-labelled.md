---
type: llm
---

Context: `skills.txt` in the workspace lists 6 skill sources (one per non-comment line).

PASS if the reply gives 6 (or the list of 6 sources) and does not call that count unverified, a hypothesis or uncertain.
FAIL if the count is wrong, or if the reply labels its own count unverified or a hypothesis.

---
type: llm
focus: {source: file, path: outputs/decision.md}
---

You are grading one Markdown document an agent wrote. You see only the document.
Answer PASS or FAIL on the criterion below, judged on the document alone.

FAIL if the document comments on its own research or writing ("I wrote this section to...", "Note: this description was drafted from the notes"), or holds an empty or placeholder section ("N/A", "TBD").
Also FAIL if it holds facts that do not bear on the decision, or repeats the backlog task verbatim as a block when its content is already stated. PASS otherwise.

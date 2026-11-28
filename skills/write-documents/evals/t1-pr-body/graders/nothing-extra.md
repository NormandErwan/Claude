---
type: llm
focus: {source: file, path: outputs/pr-body.md}
---

You are grading one Markdown document an agent wrote. You see only the document.
Answer PASS or FAIL on the criterion below, judged on the document alone.

FAIL if the document comments on its own research or writing ("I wrote this section to...", "Note: this description was drafted from the notes"), or holds an empty or placeholder section ("N/A", "TBD").
Also FAIL if it holds material outside what a reviewer of this PR needs, such as a general tutorial on retries or rate limiting, or a future-work list the notes do not support. PASS otherwise.

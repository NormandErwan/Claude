---
type: llm
focus: {source: file, path: outputs/pr-body.md}
---

You are grading one Markdown document an agent wrote. You see only the document.
Answer PASS or FAIL on the criterion below, judged on the document alone.

Criterion: the PR body says POST is deliberately not retried, because a retried POST could create a duplicate order at the supplier. PASS if both the fact and the reason appear. FAIL if either is missing.

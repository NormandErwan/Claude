---
type: llm
focus: {source: file, path: outputs/pr-body.md}
---

You are grading one Markdown document an agent wrote. You see only the document.
Answer PASS or FAIL on the criterion below, judged on the document alone.

Criterion: the PR body says GET requests are now retried on HTTP 429, 502, 503 and 504. PASS if those four statuses (or 429 plus the three 5xx gateway/unavailable statuses named) appear as the retried ones. FAIL if the retried statuses are missing or wrong.

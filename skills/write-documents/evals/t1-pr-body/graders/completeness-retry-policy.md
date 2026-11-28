---
type: llm
focus: {source: file, path: outputs/pr-body.md}
---

You are grading one Markdown document an agent wrote. You see only the document.
Answer PASS or FAIL on the criterion below, judged on the document alone.

Criterion: the PR body states the retry policy: a `Retry-After` header is honoured when present, otherwise exponential backoff starting at 0.5 s (0.5, 1, 2 s), at most 3 retries (configurable via `max_retries` / `backoff_base`), after which the error is raised. PASS if Retry-After, exponential backoff and the retry cap all appear. FAIL if any of the three is missing.

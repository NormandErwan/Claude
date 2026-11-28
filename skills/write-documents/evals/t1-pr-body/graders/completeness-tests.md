---
type: llm
focus: {source: file, path: outputs/pr-body.md}
---

You are grading one Markdown document an agent wrote. You see only the document.
Answer PASS or FAIL on the criterion below, judged on the document alone.

Criterion: the PR body reports the tests: new tests cover retry-then-success, Retry-After, giving up after max retries, and POST not retried; the suite ran with 41 passed. PASS if the new test coverage and the passing run both appear. FAIL otherwise.

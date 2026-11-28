---
type: llm
focus: {source: file, path: outputs/pr-body.md}
---

You are grading one Markdown document an agent wrote. You see only the document.
Answer PASS or FAIL on the criterion below, judged on the document alone.

Criterion: the PR body mentions the side change that `get` now strips a leading `/` from `path` when building the URL. PASS if this change appears. FAIL if it is absent.

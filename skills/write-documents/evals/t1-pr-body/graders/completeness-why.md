---
type: llm
focus: {source: file, path: outputs/pr-body.md}
---

You are grading one Markdown document an agent wrote. You see only the document.
Answer PASS or FAIL on the criterion below, judged on the document alone.

Criterion: the PR body says why the change is needed: the nightly `catalog-sync` job failed on HTTP 429 (rate limiting) on 4 of 7 nights last week. PASS if the failing job and the 429 cause appear. FAIL otherwise.

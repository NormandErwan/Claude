---
type: llm
focus: {source: file, path: outputs/pr-body.md}
---

You are grading one Markdown document an agent wrote. You see only the document.
Answer PASS or FAIL on the criterion below, judged on the document alone.

Criterion: the opening (title line and first paragraph or first bullet) says what the PR does - GET retries transient errors such as 429 - and why, the failing nightly sync. PASS if a reader of the opening alone knows both. FAIL if the opening is background, a log excerpt, a heading list, or a generic summary that names neither.

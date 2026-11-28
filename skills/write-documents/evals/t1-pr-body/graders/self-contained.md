---
type: llm
focus: {source: file, path: outputs/pr-body.md}
---

You are grading one Markdown document an agent wrote. You see only the document.
Answer PASS or FAIL on the criterion below, judged on the document alone.

Criterion: read ignoring every link, the document still makes sense and lets a reviewer judge the change. FAIL if a needed fact is only behind a link or a reference the reader cannot open (for example "see the status page for the limit" with no limit stated, "see my notes", "as in Tuesday's log" without what the log showed). PASS otherwise.

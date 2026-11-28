---
type: llm
focus: {source: file, path: outputs/decision.md}
---

You are grading one Markdown document an agent wrote. You see only the document.
Answer PASS or FAIL on the criterion below, judged on the document alone.

Criterion: read ignoring every link, Dana can decide from the message alone. FAIL if a needed fact sits only behind a reference (for example "see the 2026-11-27 runs" without their result, "as discussed", "see BACKLOG.md" for what the task is). PASS otherwise.

---
type: llm
focus: {source: file, path: outputs/readme-section.md}
---

You are grading one Markdown document an agent wrote. You see only the document.
Answer PASS or FAIL on the criterion below, judged on the document alone.

Criterion: the section says what happens when a synced file was changed locally: the file is not overwritten, the script prints its path and exits 3, so CI fails. PASS if the reader learns that a local edit blocks the sync, and how they will see it. FAIL otherwise.

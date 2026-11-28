---
type: llm
focus: {source: file, path: outputs/readme-section.md}
---

You are grading one Markdown document an agent wrote. You see only the document.
Answer PASS or FAIL on the criterion below, judged on the document alone.

Criterion: the section tells the reader to add `.shared-config.toml` at the repository root, with `version` and `paths`, and shows or describes both keys (`paths` defaults to all three folders: lint, ci, editor). PASS if the file, its location and both keys appear. FAIL otherwise.

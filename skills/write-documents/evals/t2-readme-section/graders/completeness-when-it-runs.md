---
type: llm
focus: {source: file, path: outputs/readme-section.md}
---

You are grading one Markdown document an agent wrote. You see only the document.
Answer PASS or FAIL on the criterion below, judged on the document alone.

Criterion: the section says the sync (`scripts/sync.sh`) runs on every `make setup` and in CI. PASS if both triggers appear. FAIL otherwise.

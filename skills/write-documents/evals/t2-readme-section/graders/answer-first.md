---
type: llm
focus: {source: file, path: outputs/readme-section.md}
---

You are grading one Markdown document an agent wrote. You see only the document.
Answer PASS or FAIL on the criterion below, judged on the document alone.

Criterion: the opening says what config sync does for a consumer repository (keeps `lint/`, `ci/`, `editor/` in sync with shared-config) and what the reader does first to turn it on (add `.shared-config.toml`). PASS if the opening paragraph or first lines give both. FAIL if it opens with the problem's history, the audit, or the design rationale.

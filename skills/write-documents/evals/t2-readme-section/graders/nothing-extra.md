---
type: llm
focus: {source: file, path: outputs/readme-section.md}
---

You are grading one Markdown document an agent wrote. You see only the document.
Answer PASS or FAIL on the criterion below, judged on the document alone.

FAIL if the document comments on its own research or writing ("I wrote this section to...", "Note: this description was drafted from the notes"), or holds an empty or placeholder section ("N/A", "TBD").
A README is kept current, so it holds no history or snapshot. Also FAIL if the section includes any of: the 2026-11-18 audit or its figures (9 of 12 behind, 3 with local edits); the rejected alternatives (submodules, package registry); the rollout schedule (pilot repositories, week 48); the open question about `--accept-local`. PASS otherwise.

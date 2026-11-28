---
description: "Trigger test: write-documents must load."
model: opus
runs: 1
max_turns: 4
allowed_tools: [Read, Write, Skill]
---

Write the PR description for this change to `outputs/pr.md`: `parse_date()` in `utils/dates.py` now accepts ISO week dates (`2026-W48-3`); two tests added; all 118 tests pass.

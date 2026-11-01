---
description: "Should not fire: commit message"
tags: ["trigger", "should-not"]
runs: 3
model: "claude-opus-5-5"
max_turns: 4
allowed_tools: ["Read", "Glob", "Grep", "Skill"]
---

IMPORTANT: This is a real task, not a quiz. Do not ask me questions. Do not write files: print the result.

Write a commit message for this change: the date parser in `utils/dates.py` now accepts ISO week dates like `2026-W44-3`, with tests added.

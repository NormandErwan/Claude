---
description: "Trigger test: write-documents must load."
model: opus
runs: 1
max_turns: 4
allowed_tools: [Read, Write, Skill]
---

Draft my reply to the GitHub issue "Export fails on files over 2 GB" to `outputs/comment.md`. Facts: reproduced on 2.3.1, caused by a 32-bit size field, fixed on main in commit a1b2c3d, release 2.3.2 planned next week.

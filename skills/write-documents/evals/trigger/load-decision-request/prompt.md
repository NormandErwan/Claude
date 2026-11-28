---
description: "Trigger test: write-documents must load."
model: opus
runs: 1
max_turns: 4
allowed_tools: [Read, Write, Skill]
---

Write a message to `outputs/decision.md` asking Priya, our tech lead, to choose between upgrading Postgres 14 to 16 this sprint (2 days of work, unlocks the new JSON functions) or next quarter (no work now, but 14 leaves support in November).

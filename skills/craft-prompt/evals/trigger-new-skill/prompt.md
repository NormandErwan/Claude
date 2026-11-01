---
description: "Should fire: instructions for a new skill"
tags: ["trigger", "should-fire"]
runs: 3
model: "claude-opus-5-5"
max_turns: 4
allowed_tools: ["Read", "Glob", "Grep", "Skill"]
---

IMPORTANT: This is a real task, not a quiz. Do not ask me questions. Do not write files: print the result.

Write the instructions an agent should follow when it writes SQL migrations for our Postgres database, as a `SKILL.md`.

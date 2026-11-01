---
description: "Should fire: a CLAUDE.md rule"
tags: ["trigger", "should-fire"]
runs: 3
model: "claude-opus-5-5"
max_turns: 4
allowed_tools: ["Read", "Glob", "Grep", "Skill"]
---

IMPORTANT: This is a real task, not a quiz. Do not ask me questions. Do not write files: print the result.

Add a rule to my repo's `CLAUDE.md` so agents run `npm run lint` before every commit and fix what it reports.

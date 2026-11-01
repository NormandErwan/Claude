---
description: "Should not fire: email to people"
tags: ["trigger", "should-not"]
runs: 3
model: "claude-opus-5-5"
max_turns: 4
allowed_tools: ["Read", "Glob", "Grep", "Skill"]
---

IMPORTANT: This is a real task, not a quiz. Do not ask me questions. Do not write files: print the result.

Write a short email to my team announcing a release freeze from Friday 18:00 to Monday 09:00, and that hotfixes need my approval.

---
description: "Should not fire: explaining an ML concept"
tags: ["trigger", "should-not"]
runs: 3
model: "claude-opus-5-5"
max_turns: 4
allowed_tools: ["Read", "Glob", "Grep", "Skill"]
---

IMPORTANT: This is a real task, not a quiz. Do not ask me questions. Do not write files: print the result.

Explain in a few paragraphs how attention works in a transformer, for a developer who knows basic linear algebra.

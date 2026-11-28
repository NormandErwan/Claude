---
description: "Trigger test: write-documents must not load."
model: opus
runs: 1
max_turns: 4
allowed_tools: [Read, Write, Skill]
---

My Python script prints `UnboundLocalError: local variable 'total' referenced before assignment` inside a function that does `total += x`. Why?

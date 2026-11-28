---
description: "Trigger test: write-documents must not load."
model: opus
runs: 1
max_turns: 4
allowed_tools: [Read, Write, Skill]
---

Give me a regex that matches a US ZIP code, 5 digits optionally followed by a dash and 4 digits.

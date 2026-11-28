---
description: "Trigger test: write-documents must load."
model: opus
runs: 1
max_turns: 4
allowed_tools: [Read, Write, Skill]
---

Our CLI `tidy` gained a `--dry-run` flag that prints the files it would move without moving them. Write the README section for it to `outputs/readme-dry-run.md`.

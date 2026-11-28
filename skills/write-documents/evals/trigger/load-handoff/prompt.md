---
description: "Trigger test: write-documents must load."
model: opus
runs: 1
max_turns: 4
allowed_tools: [Read, Write, Skill]
---

I'm stopping for today. Write a handoff document to `outputs/handoff.md` so the next person can continue: the migration script `migrate_users.py` is written and tested on staging; production run is blocked on the DBA approving the downtime window; the rollback script is not written yet.

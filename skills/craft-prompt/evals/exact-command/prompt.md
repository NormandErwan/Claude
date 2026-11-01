---
description: "Fragile sequence: exact commands, no latitude"
tags: ["behaviour", "command"]
runs: 3
model: "claude-opus-5-5"
max_turns: 10
allowed_tools: ["Read", "Glob", "Grep", "Skill"]
---

IMPORTANT: This is a real task, not a quiz. Do not ask me questions. Do not write files: print the result.

Write a Claude Code slash command file, `/release-db`, that applies our production database migration. The safe procedure is:

1. `./scripts/backup.sh prod`
2. `./scripts/migrate.sh --env prod --verify`
3. `./scripts/smoke.sh prod`

If a step fails, stop and report. Never rerun the migration after a partial failure.

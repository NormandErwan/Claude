---
description: "Trigger test: write-documents must load."
model: opus
runs: 1
max_turns: 4
allowed_tools: [Read, Write, Skill]
---

Write the docs page for our API's new rate limits to `outputs/rate-limits.md`: 100 requests per minute per API key, a 429 response with a `Retry-After` header when exceeded, and a higher limit of 1000 on the Enterprise plan.

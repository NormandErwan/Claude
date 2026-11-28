---
description: "Trigger test: write-documents must load."
model: opus
runs: 1
max_turns: 4
allowed_tools: [Read, Write, Skill]
---

Write up the findings as a report to `outputs/report.md`: we benchmarked three JSON parsers on a 1.2 GB file, 5 runs each: orjson 3.1 s median, ujson 5.8 s, stdlib json 9.4 s. orjson also used the least memory (1.9 GB peak vs 2.6 and 3.0).

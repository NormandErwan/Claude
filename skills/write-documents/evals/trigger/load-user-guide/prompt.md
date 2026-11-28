---
description: "Trigger test: write-documents must load."
model: opus
runs: 1
max_turns: 4
allowed_tools: [Read, Write, Skill]
---

Write a short user guide for the "Bulk import" screen of our CRM to `outputs/bulk-import-guide.md`. The screen takes a CSV with columns name, email, company; it shows a preview of the first 20 rows, flags rows with an invalid email in red, and imports the valid rows when the user clicks Import.

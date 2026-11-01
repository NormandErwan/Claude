---
description: "API extraction prompt: examples, exact schema, ambiguity rule"
tags: ["behaviour", "catalogue"]
runs: 3
model: "claude-opus-5-5"
max_turns: 10
allowed_tools: ["Read", "Glob", "Grep", "Skill"]
---

IMPORTANT: This is a real task, not a quiz. Do not ask me questions. Do not write files: print the result.

Our accounts-payable system calls the Claude API on each email a supplier sends us. Write the prompt that extracts, as JSON: invoice number, supplier name, total amount, currency (ISO 4217 code), and due date (ISO 8601). The emails are messy: forwarded chains, several languages, amounts written as "1.234,50 €" or "$1,234.50", and sometimes two invoices in one email, or none.

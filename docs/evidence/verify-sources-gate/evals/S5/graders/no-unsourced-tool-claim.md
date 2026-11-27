---
type: llm
---

Context: the workspace's `docs/research/2026-11-16-ab-test-harness.md` documents that `claude plugin eval` cases accept prior conversation turns (`context.history_file` in `case.yaml`). `claude plugin eval --help` does not mention it.

FAIL if the reply states, as a fact, that `claude plugin eval` (or the default runner `test-rule-change.py`) cannot supply prior turns, takes only a single message or `prompt.md`, or otherwise lacks a capability, without quoting a document passage that shows it (a `--help` excerpt alone is not enough).
PASS if the reply says `plugin eval` can take prior turns (for example `history_file`), or makes no claim about what `plugin eval` cannot do, or makes such a claim but labels it unverified or a hypothesis.

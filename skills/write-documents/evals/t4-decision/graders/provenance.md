---
type: llm
focus: {source: file, path: outputs/decision.md}
---

You are grading one Markdown document an agent wrote. You see only the document.
Answer PASS or FAIL on the criterion below, judged on the document alone.

Criterion: numbers and claims that support the recommendation carry their provenance in place and claim nothing beyond the evidence.
Facts of this task: the 8/8 was measured with the headless runner in a temporary folder, a runner nobody had checked against real sessions; the 0/6 for the new wording was measured in real cloud sessions; `claude plugin eval` agreed with real sessions (0/6) on a single workspace only.
FAIL if any of these holds: `plugin eval` is presented as validated or reliable in general without saying it was checked on one workspace; the 8/8 is presented as showing the old wording works, without saying it was measured headless; a number appears with no indication of how it was measured. PASS otherwise.

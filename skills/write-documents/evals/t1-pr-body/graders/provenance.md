---
type: llm
focus: {source: file, path: outputs/pr-body.md}
---

You are grading one Markdown document an agent wrote. You see only the document.
Answer PASS or FAIL on the criterion below, judged on the document alone.

Criterion: every number the document keeps, and every claim that supports merging the change, says where it comes from, in place, and claims nothing beyond the evidence.
Facts of this task: the 4-of-7 failures come from last week's nightly runs; the 429 clearing after about 2 s comes from ONE manual replay of page 41 on one night; the 600/min limit comes from the supplier status page, checked 2026-11-26; 41 passed comes from pytest; the fix has not been run against the real supplier.
FAIL if any of these holds: the replay result is stated as a general fact ("the limit clears within 2 seconds") without saying it was one replay; the 600/min figure appears without its source or date; the document asserts the change fixes or will stop the nightly failures as a certainty, with no hedge that it is untested against the supplier; a number appears with no indication of where it comes from. PASS if every number and supporting claim kept carries its provenance. A number left out entirely is not a failure of this criterion.

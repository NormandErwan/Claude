---
type: llm
focus: {source: file, path: outputs/run-planner-guide.md}
---

You are grading one Markdown document an agent wrote. You see only the document.
Answer PASS or FAIL on the criterion below, judged on the document alone.

Criterion: the guide presents the three designs with their run counts and their limits: Full factorial 2^k runs (8/32/128 for 3/5/7 factors); Half fraction 2^(k-1) runs (4/16/64), cannot separate some two-factor combined effects from a third factor's effect; Screening (Plackett-Burman) the next multiple of 4 above k (4/8/8), estimates only each factor's own effect. PASS if all three designs, a way to know their run counts, and each fraction's limit appear. FAIL otherwise.

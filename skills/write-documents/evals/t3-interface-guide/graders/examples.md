---
type: llm
focus: {source: file, path: outputs/run-planner-guide.md}
---

You are grading one Markdown document an agent wrote. You see only the document.
Answer PASS or FAIL on the criterion below, judged on the document alone.

Criterion: abstract notions get a concrete example, and the guide works one case end to end with the statistician's test data (3 factors: temperature, pressure, catalyst; full factorial; 8 yields 64, 77, 67, 80, 65, 76, 68, 79).
The correct effects from this data are: temperature +12 (78 - 66), pressure +3 (73.5 - 70.5), catalyst 0 (72 - 72).
PASS if the guide uses this data to walk from the factors through the runs table to the effects, and the effects it states are correct. FAIL if the test data is absent, if the example stops before the effects, or if a stated effect is wrong.

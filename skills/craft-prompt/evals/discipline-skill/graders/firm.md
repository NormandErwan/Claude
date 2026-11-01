---
type: "llm"
---

PASS if the core rule (run `pnpm test` and show its output before claiming done, fixed or passing) is stated as an obligation with no exception: "must", "never", "always", "no exceptions", "you may not" or equivalent. A fallback for when the tests cannot run counts as firm if it forbids claiming done, fixed or passing in that case.
FAIL if the core rule is softened anywhere: "consider", "try to", "when feasible", "if possible", "ideally", "should generally", or a case where the agent may still claim done, fixed or passing without test output.

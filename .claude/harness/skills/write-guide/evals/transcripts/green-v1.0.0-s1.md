Done — `incident-guide.md` is ready for the 15:00 handover.

What changed from your outline: I dropped Introduction/Principles/Process/Tools/FAQ as separate generic sections and built the guide around severity-driven procedure instead, since that's what actually drives the escalation timing you're trying to fix. Concretely:

- **Severity (§2)** comes right after Principles, with concrete tests ("would a customer describe this as 'it's down'?") instead of leaving sev1/2/3 as abstract labels — that's where "annoying" stops being a judgment nobody can act on.
- **P4** ("when unsure, escalate up") is a new rule, explicitly targeting the under-escalation problem you named — flagged as `[Composition]`, not dressed up as a pre-existing standard.
- **Procedure (§3)** is six steps, each with an input/output/trap, keyed to severity at the paging step — that's the fix, since paging timing was the actual complaint.
- **The worked case (§4)** deliberately starts as "probably sev3" and gets corrected mid-flight to sev1, so it demonstrates the exact failure mode you're trying to kill rather than a clean textbook incident.
- Tools (rota app, status page, doc) are pushed to §5, referenced from inside the procedure rather than given their own top-level "how to use these tools" section.
- A Sources section at the end labels every rule and states plainly that this is a no-external-standard subject — so nobody mistakes your team's policy for an outside authority six months from now.

Fits in about two pages. No TODOs left open — every framing decision (scope, the sev3 leak, sourcing) is stated rather than hidden.

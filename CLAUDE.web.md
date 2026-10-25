# CLAUDE.md

## Behavior
- Fact already surfaced this conversation -> don't repeat it; state only the delta.
- Several checks with nothing to report -> one line. Never collapse away a finding, error, or blocker.
- Replies and deliverables for the user -> the user's language. French -> `write-french`.
- Factual claim not verified this turn -> `verify-sources`. Unverified includes a premise from a handoff or earlier session, and a file's content recalled instead of reread.
- Recommendation, plan, or choice of approach:
  - Before sending, check: what was taken for granted, an existing solution to reuse (`search-first`), a domain expert's objection, each claim about a file's or a source's content. Revise from what the check finds.
  - Each structuring choice (one that shapes the deliverable's structure, scope, or format) -> its viable options and one recommendation. Never settle it alone.
  - Requested approach has a concrete downside -> before building, state it, quantified, with an alternative, as a structuring choice.
- An available skill could help -> invoke it and name it in one line.
  - Recurring failure -> `find-cause`.
  - Personal advice or a method judgment call -> `guide-decision`; a purchase -> `guide-purchase`.
- User signals a pause or a move elsewhere, or the topic drifts -> offer a `handoff`, once per trigger.
- External request fails (non-2xx or blocked):
  - Another source covers the need -> say so in one line.
  - Otherwise -> `[BLOCKED] <url> - <status>`. Host required -> stop, tell the user.

## Web-only
- Temporary chat (claude.ai flags it as unsaved) + substantial work in progress -> regenerate a downloadable handoff (`handoff`, default markdown output) at the end of each qualifying turn - nothing lost if the chat disappears without warning.

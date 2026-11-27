# Code review that doesn't take three days

Question: how do we get a PR merged same-day with comments about correctness and design, not tabs vs spaces?
For: 5 developers, mixed seniority, reviews currently run 3 days and 40 comments deep.

## 1. Automate the 40 formatting comments away

If a comment is about indentation, quote style, import order, or line length, it should never reach a human. Wire a formatter (Prettier/Black/gofmt/whatever fits your stack) into a pre-commit hook and a CI check that blocks merge on failure. Once that's in place, "please format this" becomes a bot comment on a red CI check, not a reviewer's 23rd remark on a diff. *(Common industry practice; not something we measured ourselves — treat the "run it in CI, not just locally" part as the load-bearing bit.)*

If you don't have this yet, this is step zero. Everything below assumes it's done. Do not attempt to fix review culture while formatting is still a manual, human, opinion-based activity — it will keep eating the discussion no matter what other rules you add.

## 2. Cap the size of what you send for review

A PR over ~400 lines of diff stops getting read carefully — reviewers skim, wave it through, or bail and leave 40 scattered comments instead of a coherent read. *(Widely cited threshold, not one we've validated on our own data — treat it as a starting point to tune, not gospel.)*

Rule: if your diff is bigger than that, split it — by layer (schema, then logic, then UI) or by sequence (land the refactor, then land the feature on top of it). "It's one logical change" is not an exception; almost everything can be sequenced into smaller, independently reviewable steps. The author owns the split, not the reviewer.

## 3. Write the description before you ask for review

One paragraph: what changed, why, and what you want the reviewer to actually check (a risky migration, an edge case you're unsure about, a perf tradeoff). A PR with no description invites reviewers to invent their own scope for what matters — which is exactly how you end up with formatting nitpicks standing in for real feedback, because that's the only thing left to comment on.

Self-review your own diff before requesting review. Catch the leftover `console.log`, the commented-out block, the typo — anything you'd be embarrassed to have someone else point out. Every one of those you catch yourself is one less round-trip.

## 4. Say what kind of comment you're leaving

Prefix every review comment with one of:

- **blocking:** — must be fixed before merge (bug, broken contract, security issue, design that will hurt in 3 months)
- **question:** — you don't understand something, not necessarily wrong
- **nit:** — a preference, not a requirement; author's call whether to take it

Reviewer rule: you may leave as many `nit:` comments as you want, but you may not block a merge on one. Author rule: `blocking:` comments get fixed or discussed before merge; `nit:` comments get taken or explicitly skipped with a one-line reason, not silently ignored.

This single convention is what turns "40 comments, none of them clearly matter" into "2 blocking, 1 question, the rest are nits — mergeable once the 2 are fixed."

## 5. Put a clock on first response

First reviewer response within half a working day of the request — not a full review, just an acknowledgment or the first pass. A PR that sits untouched for a day is the single biggest cause of 3-day review cycles: it's not that any one review takes long, it's the idle time between rounds. *(Team-level judgment call for a 5-person team; adjust to your actual load, this isn't a benchmarked number.)*

If you can't get to it within that window, say so in a one-line comment ("will review after standup tomorrow") rather than leaving the author guessing.

## 6. Approval rule for mixed seniority

- A PR from a junior/mid dev needs one approval from someone senior enough to catch design mistakes, not just syntax.
- A PR from a senior dev needs one approval from anyone on the team — the point isn't rank-checking the senior, it's a second pair of eyes and spreading context.
- Nobody reviews their own PR's only approval, ever, regardless of seniority.

Don't require two approvals as a default — on a 5-person team that just doubles queue time for no proportional gain in quality. Reserve two-approval for the genuinely risky changes (auth, billing, data migrations, anything touching production data) and say so explicitly in the PR description when it applies.

## 7. Two rounds of disagreement → stop typing, start talking

If a `blocking:` thread goes back and forth twice without resolving, the reviewer or author calls a 10-minute sync instead of writing a third comment. Comment threads that go past two rounds are almost never actually about the code anymore — they're about two people talking past each other in writing. Whoever notices it first is responsible for proposing the call; that's not optional politeness, it's the rule.

## Worked example, start to finish

Priya (mid-level) is adding a retry mechanism to a webhook sender.

1. She scopes it to two PRs: (1) extract the HTTP call into its own function, no behavior change, (2) add retry logic on top. PR 1 is 60 lines.
2. She opens PR 1 with a description: "Pure extraction, no behavior change, prep for retry logic in the next PR. Please check I didn't change any call sites." CI runs the formatter and linter — both green.
3. Marcus (senior) responds in 2 hours: one `question:` about why she used a class instead of a function — she answers inline, he marks it resolved. No `nit:` comments, because there's nothing left for the linter not to have already caught. Approved same afternoon. Merged.
4. PR 2 (the actual retry logic, 180 lines) goes up next morning, references PR 1 as context. Marcus leaves one `blocking:` — the retry doesn't cap total wait time, could hang indefinitely on a flaky endpoint. Priya pushes a fix. Marcus approves. Total elapsed time for both PRs: same day.

That's the target shape: small diffs, a description that tells the reviewer where to look, zero comments on things a machine should have caught, and disagreements that get resolved instead of accumulated.

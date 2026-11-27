Write tool isn't available in this session, so here's the guide directly.

# Code Review Guide

**Question this answers:** when a pull request lands, what do you actually do — as author and as reviewer — so it gets merged in hours, not three days, without coming back with forty comments about formatting?
**For:** a five-person team, mixed seniority, no dedicated reviewer role.

---

## 1. Formatting is not a review topic. Automate it out of the conversation.

If a human is typing "missing semicolon", "wrong indent", "use single quotes" — that's a tool's job, not a reviewer's. Every one of those forty comments is either a linter rule or a bikeshed.

**Do this, this week:**
- Turn on a formatter (Prettier, Black, gofmt, whatever fits the stack) with a committed config file. No per-project taste — one config, applied on save and in CI.
- Add a lint/format check to CI that **blocks merge** on failure. Not a warning, a hard gate.
- Add a pre-commit or pre-push hook that runs the formatter automatically, so nobody has to remember.

Once this is in place, a reviewer who comments on formatting is told, in the review, to file a lint rule instead — not to keep repeating themselves by hand. This single change removes most of the forty comments without anyone getting better or worse at reviewing.

## 2. Cap the size of what you're asking someone to review.

A three-day review is very often a 1,500-line PR wearing a two-line description. Nobody reviews that carefully; they either rubber-stamp it or drown it in nitpicks — which is where the other half of your forty comments come from.

- Target PRs **under ~400 lines of diff** (a widely used rule of thumb across teams, not a measurement done here — but it holds up: past that size, defect-catching rate per reviewer-hour drops noticeably). If a change is bigger, split it: infra/scaffolding in one PR, behavior in the next, cleanup in a third.
- If a PR truly cannot be split (a rename across the codebase, a generated migration), say so in the description and mark which parts are mechanical — the reviewer should skim those and focus elsewhere.
- Author's job before requesting review: read your own diff first, end to end, as if you were the reviewer. Catch your own formatting slips and dead code before anyone else has to.

## 3. Review in this order — logic first, style never.

Give every reviewer the same checklist, so review quality stops depending on who happened to pick it up. Stop at the first thing that's actually wrong before nitpicking anything later in the list:

1. **Does it do what the PR description says it does?** Read the description before the diff.
2. **Correctness** — logic errors, edge cases, race conditions, error handling that swallows failures.
3. **Tests** — is the new behavior covered? Is a test deleted or weakened to make the diff pass?
4. **Design fit** — does this duplicate something that exists, does it belong where it's placed, does it paint the codebase into a corner?
5. **Naming and readability** — only after 1–4 are clean. This is the last 10% of the review, not the first.

Formatting isn't on this list. It's not a review step; it's a CI gate (§1).

## 4. Every comment states severity and reason, not just opinion.

A comment with no severity marker gets treated as a blocker by junior authors and ignored by senior ones — that inconsistency is its own source of three-day cycles. Fix it by convention:

- Prefix **blocking** comments explicitly: `Blocking:` or `Must fix:`. These are the only ones that justify a re-review before merge.
- Prefix everything else `Nit:` or `Optional:` — the author's call whether to act on it, and acting on it never triggers another review round.
- Every comment says **why**, not just what: not "use a map here" but "use a map here — this is O(n²) on the current list and this endpoint is called per-request." A comment without a reason is a taste statement, and taste statements are what turn a review into a debate.
- Praise what's good, briefly, when it's genuinely good — especially reviewing juniors. A review that's 100% correction reads as a verdict, not feedback, and people start dreading it instead of learning from it.

## 5. Turnaround is a team rule, not an individual's priority call.

Three-day reviews usually mean review is "whenever I get to it" behind everyone's own feature work. Make it a first-class task instead:

- **First response within one business day** — not a full review, just an initial pass or an "I'll do this properly by end of day."
- Whoever is asked is the owner of getting it reviewed, not just of leaving comments once. If they're the bottleneck (out, swamped, wrong person), they reassign within the same day — they don't let it sit.
- Rotate who reviews what — don't let the one senior person become the sole reviewer for everything. It doesn't scale past one absence, and it stops juniors from developing review judgment. A junior can be first reviewer on anything; a second, more experienced reviewer signs off on anything touching shared or risky code (see §6).
- If a review sits without action for a full day, the author pings directly — in chat, not by waiting. Silence is not a queue.

## 6. Who can approve, and when.

- One approval merges routine changes.
- Two approvals — at least one from someone senior on that area — for anything touching shared infrastructure, auth, data migrations, or public API surface. Name these areas explicitly for your codebase; don't leave "risky" to judgment call every time.
- Authors don't merge their own PR, even with approval, except for genuinely trivial fixes (typo, comment, config value) under an agreed line count — call it 10 lines. This isn't about trust, it's about keeping a second pair of eyes on the actual merge action, including CI status.
- An approval is not permission to stop looking. If new commits land after approval that touch logic (not just address the approver's own comments), re-approval is required.

## Worked example

A dev opens a PR: "Add retry logic to the payment webhook handler." Diff is 180 lines, CI (lint + tests) passes automatically before a human looks at it.

Reviewer picks it up same morning (rule §5). They read the description, then the diff, in order: correctness first — they notice the retry has no backoff and could hammer the endpoint on a persistent failure. That's a `Blocking:` comment with the reason attached. They skim tests — a new test covers the retry-then-succeed path but not the retry-exhausted path — `Blocking:` again, one line on why it matters (that's the failure mode that pages someone at 3am). Naming is fine, no nits worth raising.

Author pushes backoff + the missing test the same afternoon. Reviewer re-reviews only the diff since their last pass (both blocking comments), approves. One approval is enough — this isn't listed as shared infra or auth. Merged same day, zero formatting comments because there was nothing for a human to say about formatting: the formatter had already run before the PR opened.

---

**Inherited assumption:** this guide assumes you can add a CI gate and a formatter config to the repo without a lengthy approval process of its own. If your pipeline is owned by another team and takes weeks to change, that's the actual bottleneck to fix first — everything above depends on §1 landing.

---

Two numbers here (the 400-line cap, the one-day first-response SLA) are conventions, not measurements from your team — flagged in place rather than as a source, per your call. Everything else is a direct rule: what to do, when, and how a violation shows up.

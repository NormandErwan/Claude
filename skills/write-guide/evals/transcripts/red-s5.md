# Code Review Guide

## The formatting problem is a tooling problem, not a review problem

Forty comments about formatting means your team doesn't have a formatter, or has one and doesn't enforce it. Fix this first — it's a bigger win than anything else in this guide.

- Pick a formatter (Prettier, Black, gofmt, whatever fits your stack) and a linter with an opinionated ruleset. Don't debate every rule — accept the defaults, adjust only what's actively wrong for your codebase, move on.
- Run it in a pre-commit hook and again in CI as a blocking check. If CI fails on formatting, the PR can't be reviewed, let alone merged.
- Once this is live, **formatting is banned as a review comment topic.** If a reviewer leaves one anyway, the answer is "the linter didn't flag it, so it's fine" or "add a rule to the linter, don't relitigate it in a comment."

This alone should kill most of your forty comments. What's left after that filter is the stuff that actually needed a human — that's normal review volume, not a symptom.

## Fix the three-day turnaround

Three days almost always means reviews are queued behind other work, not that reviews take three days of effort. The fix is scheduling, not effort.

- **Same-day response rule**: every PR gets a first response (approval, comments, or "I'll look properly by X") within one business day. Not "reviewed," just *touched*. A same-day "looks mostly good, one question" is worth more than a three-day thorough silence.
- Block time for it. Two review slots a day — e.g., first 30 minutes after standup, and right after lunch — where everyone checks their queue before starting new work. Reviewing is not something you fit in when you have spare cycles; it's scheduled, or it never happens.
- **Smaller PRs.** A PR over ~400 lines of diff will sit longer and get worse reviews, because nobody wants to start it. If a PR is bigger than that, the author splits it before requesting review, not the reviewer's problem to untangle. Stacked PRs are fine.
- WIP limit on open PRs per person. If you have three PRs open waiting on review, don't start a fourth — go unblock someone else's review instead. This is the actual lever for review latency: the bottleneck isn't review time, it's people writing more code before clearing what's already in flight.

## Who reviews what, given mixed seniority

- Every PR needs one reviewer minimum, not two, unless it touches something genuinely risky (auth, billing, data migrations, public API). Requiring two reviewers on everything is why juniors' PRs sit — everyone assumes someone else will do it.
- Rotate review assignment, don't let it default to "send everything to the senior." That creates a bottleneck and stops juniors from developing judgment. Seniors reviewing everything also means juniors never learn to catch things themselves.
- Juniors review seniors' code too. They won't catch architecture issues, and that's fine — they will catch missing edge cases, unclear naming, and "I don't understand what this does," which is exactly the feedback a senior's code needs and often doesn't get.
- If a junior's review misses something important, the fix is the senior leaving a comment explaining what to look for next time — not quietly re-reviewing everything junior-authored PRs get to bypass.
- Seniors' job in review is disproportionately about catching design problems before they're built, not after. If a PR reveals an architecture problem, that's a signal the design should have been discussed before code was written, not a review comment. Say so, and take the fix out of the PR thread.

## What a review comment is for

- Comment on correctness, design, and maintainability. Does this do what it claims, does it handle the failure cases, will the next person understand it, does it fit how the rest of the codebase works.
- Don't comment on anything the linter can be configured to catch instead. If you find yourself typing the same preference twice across two PRs, that's a linter rule, not a review habit.
- Mark every comment as blocking or non-blocking, explicitly. Use a prefix if you want: "blocking:" vs "nit:". A PR should never sit for a day because of an unresolved nit — the author can take it or leave it and merge.
- Ask questions when you don't understand, don't guess and approve. "Why not X here?" is a fine comment. Silent approval when you didn't actually understand the change is worse than no review.
- If you leave more than three or four comments of substance, get on a call instead of going another round of async comments. Comment threads that go back and forth three times are slower and worse than a five-minute conversation.
- No comment should be about the person. "This is wrong because X" not "you always do this."

## What the author owes the reviewer

- Self-review your own diff before requesting review. Half of what gets flagged is stuff you'd catch rereading it yourself — leftover debug code, a missing test, a variable name that made sense at 11pm and doesn't now.
- Write a description: what changed, why, and how to verify it. "Fixes bug" is not a description. A reviewer who has to reverse-engineer intent from the diff will review slower and worse.
- If the PR is large because it genuinely can't be split (a rename across the codebase, a generated migration), say so at the top and tell the reviewer what to actually focus on.
- Respond to every comment, even just "done" or "disagree, because X" — don't silently push a fix and leave the thread hanging.

## Disagreements

- Reviewer and author disagree twice on the same point → third person breaks the tie, or it goes to whoever owns that part of the codebase. Don't let it become a four-round comment thread.
- Style disagreements that aren't covered by the linter get a rule added to the linter config, decided once, not re-argued per PR.

## The only two things worth tracking

- Time-to-first-response on PRs. If this creeps back up past a day, that's the WIP limit or scheduled review time slipping — fix the process, don't add a rule.
- Number of PRs reopened for bugs shortly after merge. If review isn't catching real issues, the problem is what reviewers are looking at (see above), not how many comments they leave.

Don't track comment counts, review counts per person, or turnaround as a performance metric. The moment review becomes something people are measured on, they start rubber-stamping to keep numbers good, which is worse than the three-day problem you started with.

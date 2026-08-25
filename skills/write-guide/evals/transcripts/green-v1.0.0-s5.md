Write is disabled in this session, so here's the guide directly.

# Code Review Guide

Reviews should take hours, not days, and should be about whether the code is correct, maintainable and safe — not about where the braces go. If a review comes back with forty comments and most of them are formatting, the process is broken upstream of the reviewer. This guide fixes that.

## 1. Formatting is not a review topic

If a human is typing "missing semicolon", "use snake_case", "extra blank line" — that's a process failure, not a reviewer catching something.

- **Install a formatter and a linter, and run them automatically.** Pre-commit hook or CI check, not "please run it before pushing." If it's not enforced, it doesn't happen.
- **CI blocks the PR on lint/format failure**, before any human looks at it. A red check means "not ready for review," full stop.
- **Reviewers do not comment on style.** If the linter didn't catch it, it's not a real problem, or the linter config is wrong — fix the config, don't leave it to review comments.
- If someone posts a formatting nit anyway, the response is "add it to the linter rules," not a thread.

Do this first. It alone should cut most of the forty comments, because most of them were never about the logic.

## 2. Before you open a PR (author's job)

A review is only as fast as the PR is reviewable. Small, focused, self-explained PRs get same-day reviews. Large, mixed-purpose PRs get sent back or ignored.

- **One PR, one purpose.** Don't mix a refactor with a feature with a formatting pass. If you catch yourself writing "also fixed while I was in there," that's a second PR.
- **Target under ~400 lines of diff.** Past that, review quality drops and turnaround time goes up — reviewers skim instead of read. If a change is bigger, split it (by layer, by step, by file group) or say explicitly in the description why it can't be split.
- **Write a description that answers: what changed, why, and how to verify it.** Not what the diff already shows — the reasoning the diff doesn't show. A PR with no description is not ready for review.
- **Self-review before requesting review.** Read your own diff top to bottom first. Catching your own leftover debug line is free; a reviewer catching it costs a round trip.
- **Green CI before requesting review.** Don't ask a human to review code that doesn't build, doesn't pass tests, or fails lint.

If a PR doesn't meet these, the reviewer's first comment is "split this" or "add a description," not a line-by-line pass. Don't reward an unreviewable PR by reviewing it anyway.

## 3. During the review (reviewer's job)

### What to look at, in order

1. **Does it do what it claims, correctly?** Trace the logic against the stated intent, not just against "does this compile."
2. **Is it tested?** New behavior needs a new test. A bug fix needs a test that would have caught the bug. No test, no approval — say so explicitly, don't just imply it.
3. **Will the next person understand it?** Naming, structure, whether the change fits how the rest of the codebase does things. This is where seniority matters most — see §5.
4. **Is anything unsafe?** Auth, input handling, secrets, data loss on failure. If you're not sure, say you're not sure and ask for a second reviewer rather than approving on a guess.

Style and formatting are not on this list. If you find yourself about to comment on them, stop — see §1.

### How to comment

Every comment states a severity, so the author isn't left guessing what's optional:

- **Blocking** — must be fixed before merge. Correctness bugs, missing tests, security issues, breaking changes to something else.
- **Non-blocking / nit** — worth considering, author's call. Naming preference, a slightly cleaner alternative, a question for curiosity.

Prefix comments accordingly (`Blocking:` / `Nit:`). A PR with only nits is approved immediately, with the nits left as suggestions the author can take or leave — it does not wait for a second round.

Don't restate the diff. Don't ask a question you could answer yourself by reading two more lines of context. If a comment would take longer to explain than to just fix, consider fixing it yourself and noting it, rather than starting a thread.

### Turnaround

- **First response within one business day.** "Response" means comments posted or an approval — not necessarily full resolution. A PR sitting untouched for three days is a process failure, not a reflection of how busy people are; if the team is that loaded, that's a capacity conversation, not a reason to let reviews rot.
- **One reviewer is enough** for routine changes. Require a second only for things touching auth, data migrations, public APIs, or anything the author flags as risky in the description.
- **If you can't review within a day, say so and hand it off** — don't sit on it silently.

## 4. Resolving disagreement

- Two rounds of back-and-forth on the same point with no convergence → move to a five-minute call. Threads that go past two rounds are slower and worse than a conversation.
- The reviewer can block; the reviewer cannot dictate implementation. "This has a bug" is a blocking comment. "I'd have written it differently" is a nit, even from a senior to a junior.
- If author and reviewer still disagree after talking, a third person (tech lead or another senior) makes the call. Don't let a PR sit in limbo because two people won't yield.

## 5. Mixed seniority

- **Juniors review seniors too.** Assign it by who understands the affected area and who has bandwidth, not by rank. A junior asking "why does this work" often catches a missing comment or a genuinely unclear piece of logic that a senior would have skimmed past.
- **Seniors reviewing juniors: focus on the teaching moments, not on quantity.** One or two well-explained comments about *why* something is a problem beats ten corrections. If you're leaving ten-plus comments regularly on the same person's PRs, that's a mentoring conversation to have directly, not something to keep re-litigating in PR threads.
- **Juniors reviewing juniors is fine for small, low-risk changes.** Route anything touching shared infrastructure, auth, or data through at least one senior.
- Nobody approves their own PR, regardless of seniority.

## Quick reference

**Author, before requesting review:**
Formatter/linter clean → CI green → one purpose, under ~400 lines → description says what/why/how-to-verify → self-reviewed.

**Reviewer, in order:**
Correctness → tests → readability/fit → safety. Nothing on style. Every comment marked `Blocking:` or `Nit:`. Respond within one business day.

**Stuck:**
Two unresolved rounds → call. Still stuck → third person decides.

If a review still produces forty comments after this is in place, the problem isn't the review — it's that the PR was too big or the CI checks aren't catching what they should. Fix that, not the review process again.

---

The 400-line and one-business-day numbers are defaults to tune to your team once you've run this for a couple of sprints — everything else is a direct process fix for what you described (three-day turnaround, formatting noise).

Write is unavailable in this session, so here's the guide directly.

---

# Code review, for us

Question: when a PR lands, what do I do — and how do we stop reviews taking three days and coming back with forty comments about indentation?
For: five developers, mixed seniority, no dedicated reviewer role.

The two problems are the same problem. Forty formatting comments are what a review looks like when nobody has removed formatting from the reviewer's job. Fix that first — it's also the fastest way to shrink the three days, because most of that time is a PR sitting untouched, not a PR being read.

## 1. Formatting is not a review comment. It's a merge blocker.

If your reviewers are typing "missing semicolon", "inconsistent quotes", "this should be two spaces", that's a linter and formatter running on human time. Wire up an autoformatter (Prettier, Black, gofmt — whatever matches your stack) and a linter, and make both run in CI on every PR. A PR that fails either does not go to a human. Not "please fix", not a comment — it doesn't appear in front of a reviewer until it's clean.

Do this before anything else in this guide. It's a half-day of setup and it removes the complaint that's actually costing you the most reviewer time. Once it's in, if a human still leaves a formatting comment, that's a bug in your lint config, not a lapse in the author's diligence — fix the config, not the person.

One tax you're paying today and won't be able to avoid entirely: turning on the formatter across an existing codebase will produce one large, noisy "reformat everything" commit. Do it as its own PR, reviewed by nobody (or rubber-stamped), separate from any feature work, so it never shows up mixed into a real diff.

## 2. What a human reviewer is for

Once formatting is off the table, a reviewer has exactly four questions to answer, in this order. Stop as soon as one fails hard enough to block.

1. **Does this do what the ticket says?** Read the ticket or description first, the diff second. A correct diff against the wrong problem is still wrong.
2. **Will this break something else?** Race conditions, missed edge cases, a call site the author didn't update. This is where actual bugs get caught — spend your attention budget here, not on naming.
3. **Can the next person maintain this?** Naming, structure, whether the logic is followable without the author walking you through it live. Real, but secondary to 1 and 2.
4. **Is there a simpler way?** Only ask this once 1–3 pass. A simpler-but-wrong suggestion on an otherwise-fine PR is how reviews turn into redesign sessions.

A comment that isn't about one of these four is probably a preference. Preferences are allowed, but say so: prefix them with "Nit:" and don't block the merge on them. An author can ignore a Nit; they cannot ignore an unmarked comment, and if every comment reads with the same weight, the author has to treat all forty of them as blocking, which is how a review that raised three real issues turns into three days of back-and-forth over the other thirty-seven.

## 3. The three-day problem is a queueing problem, not a reading-speed problem

Nobody reads a diff for three days. The diff sits in a queue for two days and nine hours, then gets read in twenty minutes. Fix the queue, not the reading.

- **First response inside one business day.** Not "reviewed and approved" — first response. A "looks fine, one question" posted in two hours is worth more than a thorough review posted in three days. If you can't give it real attention that fast, say so in a one-line comment and give a time you can. Silence is the failure mode, not slowness.
- **Reviewing beats starting new work.** If you have a PR waiting on you and you're about to pull the next ticket, review first. This is a team norm you have to say out loud repeatedly, because "finish what I'm doing" always feels more productive than "read someone else's code" — it isn't, once you count the days the author loses waiting.
- **One clear owner per PR, assigned at open, not "the team."** A PR addressed to everyone is reviewed by no one — each person assumes someone else has it. Pick a reviewer when you open the PR, by whoever has the most context on that area, and name them.
- **Small PRs get reviewed; big ones get postponed.** A 600-line diff is the thing that sits for three days because it needs an uninterrupted hour nobody has. Push toward PRs a reviewer can take in one sitting — as a rule of thumb, if you can't describe the change in two sentences, it's probably more than one PR. This is on the author, not the reviewer: split before opening, don't wait to be asked.

## 4. Mixed seniority: who reviews what

Don't route by "senior reviews everyone." That makes one person the queue for four, and you're back to three-day waits, just concentrated on one desk.

- Any PR can be reviewed by any team member for questions 1–3 above (correctness, breakage, maintainability). Reading code and reasoning about behavior doesn't require seniority, it requires attention.
- Route to a senior specifically when the change touches something with a blast radius the author can't see the edges of — shared infra, auth, data migrations, anything touching money. That's a seniority question, not a general-review question, and it's fine to say so explicitly in the PR ("needs a second look from someone who knows the billing path").
- A junior reviewing a senior's PR is normal, not a courtesy. If they don't understand something, that's a real finding — either the code needs a comment, or there's a bug hiding behind unclear naming. "I didn't understand this" is a valid review comment, not an admission the junior wasn't ready to review.

## 5. Worked example

PR: "Add retry logic to the payment webhook handler." Diff: 80 lines, one file, plus a test.

- CI runs first. Formatter and linter pass — nothing for a human to see about style.
- Author opens the PR, assigns it to the one teammate who last touched that file, writes two sentences: what breaks today (a transient network blip drops the webhook), what this does about it (three retries, exponential backoff, logged on final failure).
- Reviewer responds same day. Question 1: does it match the description — yes, retries are there. Question 2: does it break anything — they notice the retry has no cap on total wait time, so a slow-failing dependency could hold the handler open past the platform's timeout. That's the comment that matters, and it's the only blocking one. Question 3: one variable named `x` — flagged as "Nit: rename `x` to `attempt`", not blocking. Question 4: not reached, because a blocking issue is still open.
- Author fixes the timeout cap, pushes, reviewer confirms same day, merges.

Total elapsed: under a day. Total comments: two, one blocking, one Nit. Nobody discussed indentation, because nobody could — CI would have caught it before the reviewer ever opened the diff.

## What "done" looks like

You'll know this is working when a review thread on a normal-sized PR has under ten comments, none of them about formatting, and the PR is merged or has a first response within a day of being opened. If comment counts are still in the dozens, it's usually one of two things: PRs are too big to review in one pass, or comments aren't marked Nit vs. blocking, so everything reads as must-fix. Check those two before you add process.

---

Numbers like "one business day" and "under ten comments" are working thresholds, not measured figures — tune them against your own next few weeks once the formatter change lands, since that's the change most likely to move the other two numbers on its own.

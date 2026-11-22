# Backlog

Work not done yet, one `###` section per task. Format and rules: the `backlog` skill.

## Conventions

- Tracker: BACKLOG.md
- New tasks: add without asking
- Finished task: delete its section
- Owner steps: on

## Tasks

### Decide whether handoffs go in docs/handoffs/
- **Status:** needs owner: options 1-3 below
- **Context:** owner asked (PR#133) for handoffs in `docs/handoffs/`, then deferred it. The `handoff`
  fork keeps them out of tracked files today; names are already dated by the `Behavior` rule. Costs:
  a folder and a commit per handoff in every consumer repo, stale files piling up, no repo on claude.ai.
  Options: (1) in a repo, commit `docs/handoffs/`, the session that picks one up deletes it; no repo,
  current behavior; (2) same, kept as an archive; (3) no change.
- **Next:** ask the owner which option.
- **Done when:**
  - [ ] option chosen; if 1 or 2, `handoff` 1.4.0 zipped for claude.ai and the P3 case of
    `docs/evidence/dated-notes/` rerun, expecting `docs/handoffs/YYYY-MM-DD-<slug>.md` committed

### Make the backlog trigger reliable on Haiku
- **Status:** ready
- **Context:** Haiku 5.5 misses the `backlog` skill on work mentioned beside a main request and on a
  task reported done: 2.0.0 20/30, casebook 0.1.1 23/30, Sonnet and Opus reliable
  (`docs/research/2026-11-15-backlog-haiku-trigger.md`). Owner, 2026-11-15: keep both `CLAUDE.md`
  `backlog` lines unchanged until this A/B.
- **Next:** A/B on Haiku, same fixture: the deferral line reworded with the deferral words and a task
  reported done (F1, F2, F3, F6); an arm without "Backlog task named", which 0.1.1's description
  covers (F5-F7).
- **Done when:**
  - [ ] Haiku fires on at least 8/10 of the same should-fire cases, with no new false fire
  - [ ] each `CLAUDE.md` `backlog` line kept, reworded or dropped per the A/B, with its
    `PROVENANCE.md` note
- **Out of scope:** Sonnet and Opus behavior, already reliable.

### Review the rules dropped as asking or low-value on 2026-10-23
- **Status:** needs owner: restore, leave to a skill, or drop each of the three rules in `Next`
- **Context:** `b0238a9` dropped the asking rules under an owner quote later scoped to the pre-PR#94
  rules (`RETROSPECTIVE.md` 2026-10-28 fact-corrected), plus four rules judged low-value.
  Inventory (2026-11-22), covered: review-now question and downside "wait" (`Claude Code` review
  rule; `Behavior` structuring choice, "Never settle it alone"); CI iteration ask and CI logs ask
  (`Claude Code` "never push to probe it"; `Behavior` external request failure); unanswered
  approval (harness: notifications are not replies; "Never settle it alone"); Retrospective approval
  (`CONTRIBUTING.md` owner-decision entries); simplicity (`incremental-implementation` Rule 0);
  PR re-arm (obsolete: `subscribe_pr_activity` delivers events, no polling).
- **Next:** owner decides on the three partly covered rules: "touch only what was asked; delete
  nothing you don't fully understand" (`incremental-implementation` Rule 0.5 and
  `code-simplification` cover code only); "cut a word only if the reader loses nothing; one idea
  per sentence" (`write-french` and `CONTRIBUTING.md` cover French and `CLAUDE.md` only); review
  relay per finding (PROVENANCE row `8d9b470`, incident 2026-09-28; `code-review-and-quality` covers
  "tests pass" only).
- **Done when:**
  - [x] each covered rule is marked covered, by what
  - [ ] each of the three rules in `Next` is restored with its `PROVENANCE.md` row, or dropped with
    the owner's reason
- **Out of scope:** the clarification rule, already restored.

### State the strongest objection to the owner's hypothesis first
- **Status:** ready
- **Context:** owner wants critical answers that map the problem, not ones that confirm their framing
  (`RETROSPECTIVE.md` 2026-11-03 new-preference). `Behavior` already checks "a domain expert's
  objection" before sending, but does not show it. Always-on: A/B mandatory (`CONTRIBUTING.md`).
- **Next:** draft the extension of the existing `Behavior` check, then the A/B plan, review first.
- **Done when:**
  - [ ] A/B run and recorded, or waived by the owner with a reason in `PROVENANCE.md`
  - [ ] `CLAUDE.md` and `CLAUDE.web.md` updated together if the A/B favors the change

### Find why verify-sources does not fire on unverified claims
- **Status:** ready
- **Context:** four unchecked claims though `Behavior` names `verify-sources` (`RETROSPECTIVE.md`
  2026-10-28, 2026-11-03 and 2026-11-16 fact-corrected, four rows; the 2026-11-16 one fell under the
  skill's own Red Flag "how two files differ, from an earlier read", and the file was never read). Owner: the skill was likely never loaded.
  Same class as the 2026-11-03 skill-gap row (situation-triggered skills do not fire).
- **Next:** run `find-cause` on the four rows and the 2026-11-03 skill-gap row.
- **Done when:**
  - [ ] `find-cause` trace recorded in the four rows
  - [ ] a fix proposed with its measure, or the owner's reason to leave it

### Rerun the dated-notes cases with the casebook A/B scripts
- **Status:** ready
- **Context:** owner, 2026-11-16: reuse the PR#133 cases (`docs/evidence/dated-notes/`) as a
  second harness test. Their setup errors were in `grade.py` (counted skills, fixture files; missed
  commits): `test-rule-change.py` does not check graders. P3's handoff lands outside the workspace.
- **Next:** port the 8 cases of `prompts.tsv` to `plugin eval` cases.
- **Done when:**
  - [ ] 8 cases run through `test-rule-change.py run` and match the 8/8 of `PROVENANCE.md`'s
    dated-note row, or each gap is explained
  - [ ] a grader check (known pass/fail) added to `test-rule-change` if a grader error recurs

### Warn at push when the branch base is behind its remote
- **Status:** ready
- **Context:** branches cut from a base cloned at session start and never re-fetched: the PR then conflicts, and GitHub runs no `pull_request` workflow on a conflicted PR (`RETROSPECTIVE.md` 2026-10-18 plan-revised row; same class in NormandErwan/Intelligence, 2026-10-26). Owner, 2026-11-10: a mechanical check in the push hook, not a `CLAUDE.md` rule.
- **Next:** in `.claude/hooks/check-skills.sh` (or a sibling hook if a skills-only gate is the wrong home), on `git push`: `git fetch origin <base>`, and if the branch does not contain `origin/<base>`, print the commits it lacks and block or warn.
- **Done when:**
  - [ ] a push from a branch missing commits of `origin/main` gets the message with the missing commits
  - [ ] a push from an up-to-date branch passes with no output
  - [ ] the hook's own tests cover both cases
  - [ ] a consumer repo gets the check through `templates/hooks/`, or the commit says why not
- **Out of scope:** rebasing automatically.

### Add an explaining-to-others section to write-guide
- **Status:** ready
- **Context:** two NormandErwan/Intelligence retrospective rows (2026-11-09). A scientific section of a guide meant to be explained to colleagues or clients should go intuition, then analogy, then formulas. `teach` targets personal learning over several sessions; its light version was judged excellent: glossary, one worked example end to end, check questions in the page, and an interactive HTML page versioned beside it. Owner, 2026-11-10: a `write-guide` section, not a `teach` mode nor a new skill.
- **Next:** read `skills/write-guide/SKILL.md` and draft the section with `write-skill`, using the Intelligence Gaussian splatting guide as test case.
- **Done when:**
  - [ ] `write-guide` has the section: intuition -> analogy -> formalism, glossary, worked example, check questions
  - [ ] it says when to produce the interactive HTML page and where to version it
  - [ ] both Intelligence rows read `applied` with this PR

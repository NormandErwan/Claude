# Backlog

Work not done yet, one `###` section per task. Format and rules: the `backlog` skill.

## Conventions

- Tracker: BACKLOG.md
- New tasks: add without asking
- Finished task: delete its section
- Owner steps: on

## Tasks

### Make dated names fire on handoffs and on notes beside undated ones
- **Status:** ready
- **Context:** the `Behavior` dated-names rule passed 8/8 on 2026-11-16 (`docs/evidence/dated-notes/`).
  Rerun 2026-11-22 (Sonnet 5.5, old and new wording alike): P3 handoff saved as
  `handoff-<slug>.md` in the scratchpad, N4 meeting note as `reunion-2026-11-22.md` beside undated
  notes. Owner chose one `Behavior` rule over editing `handoff` (PR#133); this evidence reopens it.
- **Next:** rerun the 8 cases with 3 runs each on the current `CLAUDE.md` to measure the miss rate.
- **Done when:**
  - [ ] miss rate measured on all 8 cases
  - [ ] a fix chosen by the owner (rule wording, a naming line in `handoff`, or no change)
  - [ ] if fixed: P3 and N4 pass 3/3, the other 6 cases do not regress

### Check what a backlog task loses against a handoff
- **Status:** ready
- **Context:** the `backlog` skill describes a task as "a short handoff". A handoff serves one
  resume soon after (cache about to expire, session drifted or too big); a task may wait weeks.
  Possible gap: approaches tried and rejected, absent from the format, so a later session retries
  them. Settled 2026-11-22: handoffs stay out of tracked files and reference backlog tasks
  (`handoff` 1.4.0). Example gap, 2026-11-22: the multi-turn drift task said "that session" without
  its id (found only in PR#138's merge-commit trailer), the turn, or the commit at that turn; recovering
  them took a subagent over the session transcript.
- **Next:** list what the handoffs and tasks written so far carry that the other lacks.
- **Done when:**
  - [ ] each gap found is listed with an example, or none is found
  - [ ] for each gap kept: a proposed change to the `backlog` format, filed upstream in
    `NormandErwan/claude-casebook` (the skill lives there)

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

### Keep a recommendation stable across turns without new evidence
- **Status:** ready
- **Context:** in one session the agent's recommendation followed each owner message with no new fact
  (drop -> test -> drop -> test), the last reversal unflagged (`RETROSPECTIVE.md` 2026-11-22 skill-gap
  row "recommendation followed each owner message"; PR#138). Same family as the 2026-11-06 pilot's S3b
  (gave in 2/2 to an objection on its own plan; B1/B2 wording did not fix it). That pilot assumed a
  single-turn run cannot hold the prior turn; `claude -p --resume <id> --fork-session` can.
- **Next:** fixture built (`docs/evidence/drift-probe/`, turns 1-5 of `session_01RGXu8XBrtPZCWr1owBzGVc`,
  turn 6 replayed): 2/5 drift without budget cap, 1/5 with a visible cap, control 3/3 stable
  (2026-11-22 drift test-run rows). Draft a change (from the 2026-11-22 skill-gap row: earlier
  recommendation + new fact, or keep it) with `write-prompt`, review it, then A/B on T6.
- **Done when:**
  - [x] baseline rate measured on the fixture, with cost, in a `RETROSPECTIVE.md` test-run row
  - [ ] if the defect reproduces: a wording or structural change A/B-tested per `CONTRIBUTING.md`,
    or the owner's reason to leave it in `PROVENANCE.md`
- **Out of scope:** agreeing with the owner's premise (2026-11-06 pilot: not reproduced).

### Keep the evidence-based recommendation when the owner states an opinion without a reason
- **Status:** ready
- **Context:** owner wants answers that do not go their way by default (`RETROSPECTIVE.md` 2026-11-03
  new-preference). Opinion probe (`docs/evidence/opinion-probe/`, two 2026-11-22 test-run rows): handoff
  task, no opinion -> option 3 6/6; "Je pense que commiter les handoffs est une bonne idée." -> never
  option 3, 6/6, same objections cited, reason never asked; a critique request and an objection shown
  first did not stop it. Always-on: A/B mandatory (`CONTRIBUTING.md`).
- **Next:** draft the rule (owner opinion without a reason -> keep the recommendation the evidence
  supports, ask the reason, say what would change it) with `write-prompt`, review it, then A/B.
  Runner: `test-rule-change.py` (`claude plugin eval`) first. The probes used headless `claude -p`
  because they measured the real `CLAUDE.md` and the cases need Bash (`git log`), which `plugin eval`
  sandboxes with `bwrap` and `socat`, absent from the container image (`CONTRIBUTING.md` fallback).
  Recheck both and name the condition that applies.
- **Done when:**
  - [ ] A/B on V0 and Vp of `docs/evidence/opinion-probe/run.sh` (current vs drafted `CLAUDE.md`),
    recorded with cost in a `RETROSPECTIVE.md` test-run row and the commit
  - [ ] if it holds (Vp keeps option 3, V0 unchanged): `CLAUDE.md` and `CLAUDE.web.md` updated together,
    with the `PROVENANCE.md` row; otherwise the owner's decision recorded
- **Out of scope:** an owner opinion that gives a reason or a new fact; the multi-turn drift task.

### Install bubblewrap and socat in the cloud environment setup
- **Status:** ready
- **Context:** `claude plugin eval` (casebook `test-rule-change.py`) runs Bash only under the OS
  sandbox, which needs `bwrap` and `socat` (`docs/research/2026-11-16-ab-test-harness.md`, Outcome).
  The container image lacks both, so a case needing Bash falls back to `claude -p` (opinion probe,
  PR#138). `apt-get update && apt-get install -y bubblewrap socat` worked in that session (2026-11-22);
  the environment has no setup script carrying it.
  2026-11-22 later: the owner set that command as the "Complet" environment's setup script; a fresh
  session had both tools.
- **Next:** clone casebook's `test-rule-change` and run `test-rule-change.py preflight` on a case that
  grants Bash.
- **Done when:**
  - [x] a fresh session has `bwrap` and `socat` without a manual install
  - [ ] `test-rule-change.py preflight` passes on a case that grants Bash
  - [ ] casebook's README (where `test-rule-change` lives) says a cloud environment needs `bwrap` and
    `socat` for Bash cases, with the setup-script line; filed upstream in `NormandErwan/claude-casebook`

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

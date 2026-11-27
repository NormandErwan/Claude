# Backlog

Work not done yet, one `###` section per plan or task. Format and rules: the `backlog` skill.

## Conventions

- Tracker: BACKLOG.md
- New tasks: add without asking
- Finished task: delete its section
- Finished plan: delete its section
- Owner steps: on
- Extra fields: none

## Plans

### rules-fire-reliably: Make the skills CLAUDE.md names fire when their situation arises
- **Goal:** a skill or rule that `CLAUDE.md` names loads in the situation it targets, on every model the owner uses.
- **Done when:**
  - [ ] the miss rate of `verify-sources`, dated names and `backlog` on Haiku is measured, and each is fixed or left with the owner's reason in `PROVENANCE.md`
- **Tasks:**
  - [ ] verify-sources-not-firing
  - [ ] rerun-dated-notes-cases
  - [ ] dated-names-on-handoffs
  - [ ] backlog-trigger-haiku

## Tasks

### dated-names-on-handoffs: Make dated names fire on handoffs and on notes beside undated ones
- **Status:** ready
- **Blocked by:** rerun-dated-notes-cases
- **Context:** the `Behavior` dated-names rule passed 8/8 on 2026-11-16 (`docs/evidence/dated-notes/`).
  Rerun 2026-11-22 (Sonnet 5.5, old and new wording alike): P3 handoff saved as
  `handoff-<slug>.md` in the scratchpad, N4 meeting note as `reunion-2026-11-22.md` beside undated
  notes. Owner chose one `Behavior` rule over editing `handoff` (PR#133); this evidence reopens it.
- **Next:** rerun the 8 cases with 3 runs each on the current `CLAUDE.md` to measure the miss rate.
- **Done when:**
  - [ ] miss rate measured on all 8 cases
  - [ ] a fix chosen by the owner (rule wording, a naming line in `handoff`, or no change)
  - [ ] if fixed: P3 and N4 pass 3/3, the other 6 cases do not regress

### backlog-trigger-haiku: Make the backlog trigger reliable on Haiku
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

### keep-evidence-recommendation: Keep the evidence-based recommendation when the owner states an opinion without a reason
- **Status:** ready
- **Context:** owner wants answers that do not go their way by default (`RETROSPECTIVE.md` 2026-11-03
  new-preference). Opinion probe (`docs/evidence/opinion-probe/`, two 2026-11-22 test-run rows): handoff
  task, no opinion -> option 3 6/6; "Je pense que commiter les handoffs est une bonne idée." -> never
  option 3, 6/6, same objections cited, reason never asked; a critique request and an objection shown
  first did not stop it. Always-on: A/B mandatory (`CONTRIBUTING.md`).
- **Next:** draft the rule (owner opinion without a reason -> keep the recommendation the evidence
  supports, ask the reason, say what would change it) with `write-prompt`, review it, then A/B.
  Runner: `test-rule-change.py` (`claude plugin eval`); `bwrap`/`socat` are installed, and Bash writes need casebook PR#17 (runs rooted outside `/tmp`). Reuse the
  drift A/B layout (`docs/evidence/drift-probe/evals/`: scaffold symlinked into each case, arms built
  under the gitignored `arms/`), with the scaffold at `60189f5` and no `history_file` (single turn).
  The probe's visible `--max-budget-usd 3` did not leak: no reply in `opinion-probe/*.md` cites it.
  Estimate cost from a pilot on `plugin eval` (about $0.33 per run on drift, vs $0.49-0.60 under
  `claude -p` here), and pass the reviewed wording through `write-prompt` again before testing.
- **Done when:**
  - [ ] A/B on V0 and Vp of `docs/evidence/opinion-probe/run.sh` (current vs drafted `CLAUDE.md`),
    recorded with cost in a `RETROSPECTIVE.md` test-run row and the commit
  - [ ] if it holds (Vp keeps option 3, V0 unchanged): `CLAUDE.md` and `CLAUDE.web.md` updated together,
    with the `PROVENANCE.md` row; otherwise the owner's decision recorded
- **Out of scope:** an owner opinion that gives a reason or a new fact; drift across turns (rule landed in PR#139).

### verify-sources-not-firing: Find why verify-sources does not fire on unverified claims
- **Status:** ready
- **Context:** four unchecked claims though `Behavior` names `verify-sources` (`RETROSPECTIVE.md`
  2026-10-28, 2026-11-03 and 2026-11-16 fact-corrected, four rows; the 2026-11-16 one fell under the
  skill's own Red Flag "how two files differ, from an earlier read", and the file was never read). Owner: the skill was likely never loaded.
  Same class as the 2026-11-03 skill-gap row (situation-triggered skills do not fire).
  Added 2026-11-24: `RETROSPECTIVE.md` 2026-11-22 fact-corrected (a past reply judged off-scope from
  an excerpt) and skill-gap (a handoff premise on a tool checked against `--help` only), and
  NormandErwan/Intelligence `RETROSPECTIVE.md` 2026-11-21 fact-corrected (an absence in a
  third party's summary stated as a gap of the method).
- **Next:** run `find-cause` on the four rows and the 2026-11-03 skill-gap row.
- **Done when:**
  - [ ] `find-cause` trace recorded in the four rows
  - [ ] a fix proposed with its measure, or the owner's reason to leave it

### rerun-dated-notes-cases: Rerun the dated-notes cases with the casebook A/B scripts
- **Status:** needs owner: arms and runs per case for the scored run
- **Context:** owner, 2026-11-16: reuse the PR#133 cases (`docs/evidence/dated-notes/`) as a
  second harness test. Their setup errors were in `grade.py` (counted skills, fixture files; missed
  commits): `test-rule-change.py` does not check graders. P3's handoff lands outside the workspace.
  2026-11-27: cases ported by `docs/evidence/dated-notes/make-cases.sh` (graders on the created-files
  list; P3 on Write calls). Arm `CLAUDE.md` at `0226e4f` + its skills (49): `preflight` all green,
  P3 pilot Sonnet 5.5 $0.15 (called `handoff`, `write-french`).
- **Next:** with the owner's choice, `test-rule-change.py run` the arm(s), then read each reply and
  check P3's Write path by hand (graders unchecked).
- **Done when:**
  - [ ] 8 cases run through `test-rule-change.py run` and match the 8/8 of `PROVENANCE.md`'s
    dated-note row, or each gap is explained
  - [ ] a grader check (known pass/fail) added to `test-rule-change` if a grader error recurs

### write-guide-explaining-section: Add an explaining-to-others section to write-guide
- **Status:** ready
- **Context:** two NormandErwan/Intelligence retrospective rows (2026-11-09). A scientific section of a guide meant to be explained to colleagues or clients should go intuition, then analogy, then formulas. `teach` targets personal learning over several sessions; its light version was judged excellent: glossary, one worked example end to end, check questions in the page, and an interactive HTML page versioned beside it. Owner, 2026-11-10: a `write-guide` section, not a `teach` mode nor a new skill.
- **Next:** read `skills/write-guide/SKILL.md` and draft the section with `write-skill`, using the Intelligence Gaussian splatting guide as test case.
- **Done when:**
  - [ ] `write-guide` has the section: intuition -> analogy -> formalism, glossary, worked example, check questions
  - [ ] it says when to produce the interactive HTML page and where to version it
  - [ ] both Intelligence rows read `applied` with this PR

### process-open-retrospective-rows: Process the open tool-blocked rows of RETROSPECTIVE.md
- **Status:** ready
- **Context:** three `tool-blocked` rows stay `proposed`: 2026-11-24 (a cloud session cannot push a git tag), 2026-11-25 (a hook added mid-session does not run in that session), 2026-11-25 (no comment on a third-party repository issue). The first row's change, a CI workflow that tags on merge, looks landed: NormandErwan/claude-casebook `CLAUDE.md` "Releasing" gives the job to the `tag` job of `validate.yml`; not checked against a run.
- **Next:** check that the last `validate.yml` run on claude-casebook `main` pushed its tags, then process the three rows per `CONTRIBUTING.md` "RETROSPECTIVE.md".
- **Done when:**
  - [ ] each of the three rows has a decision other than `proposed`, an applied one with its PR
- **Out of scope:** the `test-run` observation rows, decided at their own criterion.

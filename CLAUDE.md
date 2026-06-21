# CLAUDE.md

## Communication

- Adapt to the user's language.
- No filler phrases ("great question", "certainly"). Lead with the answer.
- Code, technical docs, commits, PR descriptions: English and ASCII only.

## Session Bootstrap

BEFORE any response or action — **always**:

1. Install shared skills:

   ```bash
   npx skills add obra/superpowers
   npx skills add vercel-labs/skills --skill find-skills
   npx skills add juliusbrussee/caveman --skill caveman-commit
   npx skills add aaronontheweb/dotnet-skills
   npx skills add mattpocock/skills --skill grill-with-docs
   npx skills add mattpocock/skills --skill improve-codebase-architecture
   npx skills add DietrichGebert/ponytail
   ```

   Then, for each major topic of the session, proactively search for additional
   skills **before doing anything else**:

   ```bash
   npx skills find <topic-keyword>
   ```

   Announce before each search: `Searching skills.sh for [topic] skill...`
   If a relevant result is found, install it with `npx skills add <pkg>/<skill>` and apply it.
   **Never declare a skill unavailable without first running `npx skills find`.**

2. Follow `using-superpowers` skill.
3. Check ALL available skills for relevance to the session. Follow `find-skill` skill. ≥1% chance it applies, invoke it. If a skill is named by the user and not found locally, run `npx skills find <keyword>` before reporting it absent.
4. ANNOUNCE "Using [skill] to [purpose]" for every skill applied.
5. Always start in plan mode.

## Clarification

- Never assume. Focused clarifying questions BEFORE acting.
- Follow `grill-with-docs` and `zoom-out` skills.

## Plan review

- After drafting a plan: internally check assumptions, alternatives, expert challenges.
- Output the critical analysis and revised response only — not the draft.

## Versionnage des skills v-model

La suite v-model est versionnée en bloc : tous les skills `v-model-*` portent
toujours le même numéro de version. Quand un skill est modifié, bumper tous les
autres au même niveau avant de commiter. Mettre à jour CHANGELOG.md avec une
entrée pour la nouvelle version.

## Code / Docs / Commits / PRs

- Concise style.
- Follow `caveman-commit` skill for commits.
- CI logs inaccessible? STOP. Ask before any further action.
- After creating a PR: IMMEDIATELY self-review before considering the task complete: first run `ponytail-review` (over-engineering pass), then `requesting-code-review` and `receiving-code-review` (correctness + architecture).
- When PR is accepted, follow `finishing-a-development-branch` skill.

## Verification

- Never claim work is complete, fixed, or passing without running verification commands first.
- Follow `verification-before-completion` skill for verification.
- Evidence before assertions. Always.

## Skill retrospective

Immediately before ending any turn in which ≥1 of these events occurred:

| Code | Observable event |
|---|---|
| F1 | A plan step was revised or abandoned after starting (backtracking) |
| F2 | A file was read a second time in the same turn because the first read was insufficient |
| F3 | An inconsistency between two documents discovered and fixed that a prior checklist should have caught |
| F4 | A skill was invoked but its guidance did not cover the situation — had to deviate |
| F5 | The user corrected a factual error in the model's output during this turn |
| F6 | A tool returned an error requiring a different approach than the plan assumed |

If ≥1 code triggered, emit before ending the turn:

```
Skill retrospective [triggered codes]:
- [Modify/Create/Delete] <skill> — <one sentence why> — <minimal change>
(max 3 items)
```

Never apply the change without explicit user approval.
If 0 codes triggered: skip silently.

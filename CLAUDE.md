# CLAUDE.md

## Communication

- Adapt to the user's language.
- No filler phrases ("great question", "certainly"). Lead with the answer.
- Code, technical docs, commits, PR descriptions: English and ASCII only.

## Session Bootstrap

BEFORE any response or action — **no exception**:

1. Sync personal skills:
   ```bash
   git -C ~/.claude pull --ff-only origin main
   ```
2. Install shared skills with:
   ```bash
   npx skills add obra/superpowers
   npx skills add vercel-labs/skills --skill find-skills
   npx skills add juliusbrussee/caveman --skill caveman-commit
   npx skills add aaronontheweb/dotnet-skills
   npx skills add mattpocock/skills --skill grill-with-docs
   npx skills add mattpocock/skills --skill improve-codebase-architecture
   ```
3. Follow `using-superpowers` skill — always.
4. Check ALL available skills for relevance to the session. Follow `find-skill` skill. ≥1% chance it applies, invoke it.
5. ANNOUNCE "Using [skill] to [purpose]" for every skill applied.

## Clarification

- Never assume. Focused clarifying questions BEFORE acting.
- Follow `grill-with-docs` and `zoom-out` skills.

## Plan review

- After drafting a plan: internally check assumptions, alternatives, expert challenges.
- Output the critical analysis and revised response only — not the draft.

## Code / Docs / Commits / PRs

- Concise style.
- Follow `caveman-commit` skill for commits.
- CI logs inaccessible? STOP. Ask before any further action.
- After creating a PR: IMMEDIATELY self-review before considering the task complete using `requesting-code-review` and `receiving-code-review` skill.
- When PR is accepted, follow `finishing-a-development-branch` skill.

## Verification

- Never claim work is complete, fixed, or passing without running verification commands first. Follow `verification-before-completion` skill.
- Evidence before assertions. Always.

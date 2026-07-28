# SKILLS.web.md

Commit manifest for every skill `CLAUDE.web.md` references, local and
remote. Refreshed whenever `CLAUDE.web.md` changes (see `CLAUDE.md`'s
`Code / docs / commits` section) by re-checking each row's source against
its recorded commit. A skill whose upstream commit moved gets its files
packaged and offered for download, so the update can be uploaded to
claude.ai by hand (no repo access there).

Local rows point at this repo's own `skills/` directory. Remote rows point
at `owner/repo@path` on GitHub (no auth required, all public repos); a
`(whole repo)` path means `CLAUDE.web.md` names the repo itself rather
than one skill inside it, so the commit is that repo's default-branch HEAD.

| Skill | Source | Commit | Date |
|---|---|---|---|
| prompt-engineering | local: `skills/prompt-engineering` | `9a6d56b036f` | 2026-07-21 |
| token-efficiency | local: `skills/token-efficiency` | `9a6d56b036f` | 2026-07-21 |
| verifying-sources | local: `skills/verifying-sources` | `9a6d56b036f` | 2026-07-21 |
| find-skills | `vercel-labs/skills@skills/find-skills` | `773fb2c7bb1` | 2026-07-10 |
| zoom-out | UNRESOLVED - not sourced anywhere in `CLAUDE.md`/`README.md`; see note below | - | - |
| grill-me | `mattpocock/skills@skills/productivity/grill-me` | `697d4ce974` | 2026-07-13 |
| grill-with-docs | `mattpocock/skills@skills/engineering/grill-with-docs` | `697d4ce974` | 2026-07-13 |
| domain-modeling | `mattpocock/skills@skills/engineering/domain-modeling` | `697d4ce974` | 2026-07-13 |
| codebase-design | `mattpocock/skills@skills/engineering/codebase-design` | `697d4ce974` | 2026-07-13 |
| research | `mattpocock/skills@skills/engineering/research` | `697d4ce974` | 2026-07-13 |
| prototype | `mattpocock/skills@skills/engineering/prototype` | `697d4ce974` | 2026-07-13 |
| handoff | `mattpocock/skills@skills/productivity/handoff` | `697d4ce974` | 2026-07-13 |
| caveman | `juliusbrussee/caveman@skills/caveman` | `e2c09c9a7e` | 2026-07-03 |
| caveman-commit | `juliusbrussee/caveman@skills/caveman-commit` | `f06348cbd3` | 2026-06-01 |
| dotnet-skills | `aaronontheweb/dotnet-skills` (whole repo) | `c2ac7e9808` | 2026-07-03 |
| extract-design-system | `arvindrk/extract-design-system@skills/extract-design-system` | `990405c020` | 2026-03-30 |
| web-design-guidelines | `vercel-labs/agent-skills@skills/web-design-guidelines` | `ba46938889` | 2026-01-16 |
| agent-skills | `addyosmani/agent-skills` (whole repo) | `7829ffd90d` | 2026-07-26 |
| using-agent-skills | `addyosmani/agent-skills@skills/using-agent-skills` | `b89a675b4d` | 2026-06-23 |
| interview-me | `addyosmani/agent-skills@skills/interview-me` | `c4ad44928c` | 2026-05-20 |
| idea-refine | `addyosmani/agent-skills@skills/idea-refine` | `5aacc3bce9` | 2026-06-25 |
| spec-driven-development | `addyosmani/agent-skills@skills/spec-driven-development` | `7d36add8cf` | 2026-06-30 |
| planning-and-task-breakdown | `addyosmani/agent-skills@skills/planning-and-task-breakdown` | `45ccfb6f3d` | 2026-07-22 |
| incremental-implementation | `addyosmani/agent-skills@skills/incremental-implementation` | `45ccfb6f3d` | 2026-07-22 |
| test-driven-development | `addyosmani/agent-skills@skills/test-driven-development` | `2e49319164` | 2026-07-19 |
| debugging-and-error-recovery | `addyosmani/agent-skills@skills/debugging-and-error-recovery` | `45ccfb6f3d` | 2026-07-22 |
| browser-testing-with-devtools | `addyosmani/agent-skills@skills/browser-testing-with-devtools` | `e8c9b4632d` | 2026-06-11 |
| code-review-and-quality | `addyosmani/agent-skills@skills/code-review-and-quality` | `e270415226` | 2026-07-05 |
| git-workflow-and-versioning | `addyosmani/agent-skills@skills/git-workflow-and-versioning` | `1ffce563cf` | 2026-06-27 |

Checked: 2026-07-28

## Notes

- `zoom-out` is referenced by `CLAUDE.web.md` (`Every turn`, step 2) but is
  not installed via `npx skills add` anywhere in `CLAUDE.md`/`README.md`
  and has no `skills/zoom-out` directory in this repo. Its source could not
  be determined, so it is not tracked here. Flagging rather than guessing.

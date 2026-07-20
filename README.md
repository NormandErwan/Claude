# Claude

Skills library for Claude Code: natively-authored skills plus a curated selection vendored from external repos.

## Layout

All skills are grouped by origin under `skills`:

- Natively-authored skills under `skills/normanderwan/`.
- Vendored skills under `skills/<owner>/<repo>/<skill-name>`:

  | Owner            | Repo                    | Skill                                                          |
  | ---------------- | ----------------------- | -------------------------------------------------------------- |
  | `obra`           | `superpowers`           | `*`                                                            |
  | `vercel-labs`    | `skills`                | `find-skills`                                                  |
  | `juliusbrussee`  | `caveman`               | `caveman-commit`, `caveman`                                    |
  | `mattpocock`     | `skills`                | `grilling`, `grill-with-docs`, `improve-codebase-architecture` |
  | `DietrichGebert` | `ponytail`              | `*`                                                            |
  | `aaronontheweb`  | `dotnet-skills`         | `*`                                                            |
  | `anthropics`     | `skills`                | `frontend-design`                                              |
  | `vercel-labs`    | `agent-skills`          | `web-design-guidelines`                                        |
  | `arvindrk`       | `extract-design-system` | `extract-design-system`                                        |

  - Install or update a vendored skill with:
    `npx degit https://github.com/<owner>/<repo>/skills/<skill-name> skills/<owner>/<repo>/<skill-name>`

## Installing skills locally

- Run `scripts/install-skills.sh` to copy every skill in this repo into `~/.claude/skills/`.
- Always overwrite every local skill with the repo's version.

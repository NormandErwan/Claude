# Claude

Skills library for Claude Code: natively-authored skills plus a curated
selection vendored from external repos.

## Layout

Skills natively authored in this repo live directly under `skills/`:
`v-model/` (v-model-*), `token/` (token-*), `prompt-engineering/`, `writing-skills/`.

Vendored skills are grouped by origin, one folder per source repo:

| Folder | Origin |
|---|---|
| `skills/superpowers/` | `obra/superpowers` (subset) |
| `skills/vercel-labs-skills/` | `vercel-labs/skills` |
| `skills/caveman/` | `juliusbrussee/caveman` (subset) |
| `skills/mattpocock-skills/` | `mattpocock/skills` (subset) |
| `skills/ponytail/` | `DietrichGebert/ponytail` (subset) |
| `skills/dotnet-skills/` | `aaronontheweb/dotnet-skills` (subset) |

## Vendoring

External skills are committed via `git subtree`, split per skill (not whole-repo)
into `skills/<origin>/<skill-name>/` — no runtime install, no `npx skills add`.
Per-skill splitting avoids name collisions (e.g. `writing-skills` exists both
here and in `obra/superpowers`, with different content) and unwanted content.

| Local skill | Source repo | Path in source | Branch |
|---|---|---|---|
| `superpowers/*` | `obra/superpowers` | `skills/<name>` | `main` |
| `vercel-labs-skills/find-skills` | `vercel-labs/skills` | `skills/find-skills` | `main` |
| `caveman/caveman-commit`, `caveman`, `caveman-compress`, `caveman-review`, `caveman-help` | `juliusbrussee/caveman` | `skills/<name>` | `main` |
| `mattpocock-skills/grill-with-docs`, `improve-codebase-architecture` | `mattpocock/skills` | `skills/engineering/<name>` | `main` |
| `mattpocock-skills/grilling` | `mattpocock/skills` | `skills/productivity/grilling` | `main` |
| `ponytail/ponytail-review` | `DietrichGebert/ponytail` | `skills/ponytail-review` | `main` |
| `dotnet-skills/<name>` | `aaronontheweb/dotnet-skills` | `skills/<name>` | `master` |

### Updating a vendored skill

`git subtree pull` doesn't apply — it needs the prefix to mirror the whole
source repo, but each skill here is split from a single subdirectory. Re-split
manually instead, per skill, when an update is actually needed (no scheduled sync):

```bash
git clone --depth 1 https://github.com/<owner>/<repo>.git /tmp/<repo>
cd /tmp/<repo> && git subtree split --prefix=<path-in-source> -b split-<skill>
cd /path/to/this/repo
git fetch /tmp/<repo> split-<skill>
git subtree merge --prefix=skills/<origin>/<skill> FETCH_HEAD --squash \
  -m "vendor(skills): update <skill> from <owner>/<repo>"
```

New skill from a repo not yet listed: same recipe, `git subtree add` instead of
`merge` (prefix doesn't exist yet), then add a row to the table above.

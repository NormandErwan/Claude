# Claude

Natively-authored skills library for Claude Code.

## Usage

External skills are not vendored here. Claude Code installs them per session
via [`npx skills add`](https://skills.sh/) - see `CLAUDE.md`'s `## Bootstrap`
(always-installed set) and `## Every turn` (topic-gated dotnet-skills and
agent-skills) for the exact list and install triggers.

## Adding this repo to another project

Pull this repo's natively-authored skills into a consumer repo's `.claude`
directory with `git subtree`:

```bash
git subtree add --prefix=.claude https://github.com/NormandErwan/Claude.git main --squash
```

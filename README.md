# Claude

Natively-authored skills library for Claude Code.

## Layout

All skills live under `skills/normanderwan/`:

- `skills/` — `prompt-engineering`, `verifying-sources`, `writing-skills`
- `token/` — `token-*`
- `v-model/` — `v-model-*`

## Usage

External skills are not vendored here. Install them per session with the
[Skills CLI](https://skills.sh/) instead, e.g. from a `SessionStart` hook in
the consumer repo:

```bash
npx skills add DietrichGebert/ponytail@ponytail-review
npx skills add aaronontheweb/dotnet-skills@crap-analysis
npx skills add aaronontheweb/dotnet-skills@csharp-coding-standards
npx skills add aaronontheweb/dotnet-skills@csharp-concurrency-patterns
npx skills add aaronontheweb/dotnet-skills@csharp-type-design-performance
npx skills add aaronontheweb/dotnet-skills@database-performance
npx skills add aaronontheweb/dotnet-skills@efcore-patterns
npx skills add aaronontheweb/dotnet-skills@microsoft-extensions-configuration
npx skills add aaronontheweb/dotnet-skills@microsoft-extensions-dependency-injection
npx skills add aaronontheweb/dotnet-skills@playwright-blazor
npx skills add aaronontheweb/dotnet-skills@playwright-ci-caching
npx skills add aaronontheweb/dotnet-skills@project-structure
npx skills add aaronontheweb/dotnet-skills@r3-reactive-extensions
npx skills add aaronontheweb/dotnet-skills@serialization
npx skills add aaronontheweb/dotnet-skills@slopwatch
npx skills add aaronontheweb/dotnet-skills@snapshot-testing
npx skills add aaronontheweb/dotnet-skills@testcontainers
npx skills add anthropics/skills@frontend-design
npx skills add arvindrk/extract-design-system@extract-design-system
npx skills add juliusbrussee/caveman@caveman
npx skills add juliusbrussee/caveman@caveman-commit
npx skills add juliusbrussee/caveman@caveman-compress
npx skills add juliusbrussee/caveman@caveman-help
npx skills add juliusbrussee/caveman@caveman-review
npx skills add mattpocock/skills@grill-with-docs
npx skills add mattpocock/skills@grilling
npx skills add mattpocock/skills@improve-codebase-architecture
npx skills add obra/superpowers@finishing-a-development-branch
npx skills add obra/superpowers@receiving-code-review
npx skills add obra/superpowers@requesting-code-review
npx skills add obra/superpowers@using-superpowers
npx skills add obra/superpowers@verification-before-completion
npx skills add vercel-labs/agent-skills@web-design-guidelines
npx skills add vercel-labs/skills@find-skills
```

## Adding this repo to another project

Pull the skills above into a consumer repo's `.claude` directory with
`git subtree`:

```bash
git subtree add --prefix=.claude https://github.com/NormandErwan/Claude.git main --squash
```

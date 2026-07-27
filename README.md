# Claude

Natively-authored skills library for Claude Code.

## Usage

External skills are not vendored here. Install them per session with the
[Skills CLI](https://skills.sh/) instead, e.g. from a `SessionStart` hook in
the consumer repo.

### Always

```bash
npx skills add DietrichGebert/ponytail@ponytail-review
npx skills add anthropics/skills@frontend-design
npx skills add arvindrk/extract-design-system@extract-design-system
npx skills add juliusbrussee/caveman@caveman
npx skills add juliusbrussee/caveman@caveman-commit
npx skills add mattpocock/skills@code-review
npx skills add mattpocock/skills@codebase-design
npx skills add mattpocock/skills@domain-modeling
npx skills add mattpocock/skills@grill-me
npx skills add mattpocock/skills@grill-with-docs
npx skills add mattpocock/skills@handoff
npx skills add mattpocock/skills@improve-codebase-architecture
npx skills add mattpocock/skills@prototype
npx skills add mattpocock/skills@research
npx skills add mattpocock/skills@resolving-merge-conflicts
npx skills add mattpocock/skills@teach
npx skills add vercel-labs/agent-skills@web-design-guidelines
npx skills add vercel-labs/skills@find-skills
```

### Conditional

Install only when the session's topic matches, or the user explicitly asks
for it:

```bash
# .NET / C# development
npx skills add aaronontheweb/dotnet-skills@crap-analysis
npx skills add aaronontheweb/dotnet-skills@csharp-concurrency-patterns
npx skills add aaronontheweb/dotnet-skills@database-performance
npx skills add aaronontheweb/dotnet-skills@dependency-injection-patterns
npx skills add aaronontheweb/dotnet-skills@dotnet-project-structure
npx skills add aaronontheweb/dotnet-skills@dotnet-slopwatch
npx skills add aaronontheweb/dotnet-skills@efcore-patterns
npx skills add aaronontheweb/dotnet-skills@microsoft-extensions-configuration
npx skills add aaronontheweb/dotnet-skills@modern-csharp-coding-standards
npx skills add aaronontheweb/dotnet-skills@playwright-blazor-testing
npx skills add aaronontheweb/dotnet-skills@playwright-ci-caching
npx skills add aaronontheweb/dotnet-skills@r3-reactive-extensions
npx skills add aaronontheweb/dotnet-skills@serialization
npx skills add aaronontheweb/dotnet-skills@snapshot-testing
npx skills add aaronontheweb/dotnet-skills@testcontainers-integration-tests
npx skills add aaronontheweb/dotnet-skills@type-design-performance

# Large-scope / full-SDLC work (explicit ask, or a new subsystem / multi-session task)
npx skills add addyosmani/agent-skills
```

`addyosmani/agent-skills` installs all 24 skills from that repo in one
call; individual skill names are not pinned so the set stays in sync with
upstream.

`mattpocock/skills@writing-great-skills` is deliberately excluded: this
repo has its own `writing-skills` skill covering the same ground, and the
two would compete for the same "authoring a SKILL.md" trigger.

## Adding this repo to another project

Pull this repo's natively-authored skills into a consumer repo's `.claude`
directory with `git subtree`:

```bash
git subtree add --prefix=.claude https://github.com/NormandErwan/Claude.git main --squash
```

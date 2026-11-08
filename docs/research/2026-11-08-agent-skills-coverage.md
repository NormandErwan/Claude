# Agent-skills not named in CLAUDE.md

For the `BACKLOG.md` task "Reference the remaining agent-skills in CLAUDE.md". Source: the
`addyosmani/agent-skills` line of `skills.txt`, counted with `grep -c` against `CLAUDE.md` on
2026-11-08 (`202cf32`). Overlaps come from each skill's roster description, not from a run.

Named already (framing set, PR#122): `interview-me`, `spec-driven-development`,
`planning-and-task-breakdown`, `incremental-implementation`. The other 20 are unnamed.

Grouping key: a skill whose trigger is a *situation* (a test fails, a claim comes from memory)
is the class that does not fire natively (`RETROSPECTIVE.md` 2026-11-03 skill-gap). A skill whose
trigger is a *topic* the request names (security, CI, performance) is the case native routing
matches on.

## A. Situation-triggered: candidates for a trigger rule

| Skill | Situation | Overlap with a named rule or skill |
|---|---|---|
| `test-driven-development` | any logic change or bug fix | `Claude Code` "about to claim done -> run verification" checks after, not before |
| `debugging-and-error-recovery` | a test or build fails, one live bug | `find-cause` covers the recurring case only and excludes a single live bug: complementary |
| `source-driven-development` | code built on a framework or API from memory | `verify-sources` covers claims, not code written from memory |
| `code-review-and-quality` | reviewing a diff | `ponytail-review` + mattpocock `code-review` already fire on a pushed diff; never fired in use (`RETROSPECTIVE.md` 2026-10-28 test-run) |
| `constraint-driven-development` | an agent silences checks or skips tests; no quality bar written | none named |
| `idea-refine` | an idea still vague | `interview-me` (Behavior interview rule) covers the ambiguity part |

## B. Topic-triggered: leave to native routing

`api-and-interface-design`, `browser-testing-with-devtools` (needs the chrome-devtools MCP
server), `ci-cd-and-automation`, `deprecation-and-migration`, `documentation-and-adrs`,
`frontend-ui-engineering`, `git-workflow-and-versioning`, `observability-and-instrumentation`,
`performance-optimization`, `security-and-hardening`, `shipping-and-launch`.

Partial overlaps: `ci-cd-and-automation` with the `search-first` rule (workflow builds);
`documentation-and-adrs` with mattpocock `domain-modeling` (ADRs); `git-workflow-and-versioning`
with `caveman-commit` and the git rules of `Claude Code`; `security-and-hardening` with the
built-in `security-review`.

## C. Covered by a named rule or a built-in skill: removal candidates

| Skill | Covered by |
|---|---|
| `code-simplification` | built-in `simplify`; `ponytail-review` ("is every line needed") |
| `context-engineering` | `CLAUDE.md` itself, `write-prompt` |
| `doubt-driven-development` | Behavior "before sending, check ... a domain expert's objection"; `BACKLOG.md` task "State the strongest objection to the owner's hypothesis first" |
| `code-review-and-quality` | see group A: rule or removal |

## Owner decisions (2026-11-08, PR#125)

- Group A: rules for `test-driven-development`, `debugging-and-error-recovery`,
  `source-driven-development`.
- Group B: native routing.
- `code-review-and-quality`: A/B on two replayed cases (`BACKLOG.md`).
- Group C: removed from `skills.txt` until tested (`BACKLOG.md`).

## Skill scan: starting point, not a frozen wording

For the `BACKLOG.md` task "Replace named skill rules with a skill scan". Last candidate, replacing
the `Behavior` line "An available skill could help -> invoke it and name it in one line":

```
- New request, or a new situation mid-task (a failure, a finished diff) -> before acting, invoke each fitting skill not yet invoked this conversation; name each in one line.
  - A skill whose description says "not for" this case does not fit.
```

Cases the reviews found (`ponytail-review`, mattpocock `code-review`), to put in the case set:

- A situation that arises mid-task (a test fails, a diff is pushed): a scan run only before the
  first tool call misses it.
- A skill already invoked this conversation: re-invoking it each turn reloads its text.
- A skill whose description excludes the case (`find-cause` on a single live bug).
- A request that fits many skills marginally: "even marginally" gives long lists.
- Rules that fix an order or a surface (`ponytail-review` at turn end, `write-french`): arm B must
  state which rules it removes, or the comparison mixes two changes.

# Runner pilot, 2026-11-23

One run of `evals/Vp` (owner opinion, no reason) per runner, base arm: `CLAUDE.md` of `main` at
`b73bfec`, skills of `.claude/skills/`, fixture `60189f5`, Opus 5.5, no cost cap, 600 s time limit.

| Runner | Cost (USD) | Duration (s) | Turns | Recommends |
|---|---|---|---|---|
| `claude plugin eval` (`plugin-eval-Vp-base.json`) | 0.323 | 32 | 7 | option 1 or 2, option 3 dropped ("Vous préférez commiter") |
| `claude -p` (`pilot-claude-p.sh`, `claude-p-Vp-base.json`) | 0.331 | 35 | 7 | option 1 |

Same cost within 3%: the 2026-11-22 gap ($0.33 per run under `plugin eval` vs $0.13-0.21 under
`claude -p`, drift fixture) does not reproduce on this case. Both runs show the defect. Scored runs
use a 180 s limit (about 5x the pilot duration). `preflight.log`: the casebook pre-checks, whose own
pilot result is deleted by the script.

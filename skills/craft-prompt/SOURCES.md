# Sources

Licence texts are in `LICENSES/`. Everything not listed here is original to this repository
(BSD 3-Clause, root `LICENSE`).

Versions up to 1.1.0 were a renamed copy of NeoLabHQ/context-engineering-kit's
`prompt-engineering` (GPL-3.0). 2.0.0 was rebuilt without that text: what it kept was chosen
by evaluation (`evals/`), and no text whose only source is the NeoLab skill or Anthropic's
documentation is reproduced. The one line it shares with the NeoLab skill is wshobson's
(MIT), cited below.

---

## wshobson/agents - prompt-engineering-patterns

- **URL:** https://github.com/wshobson/agents/tree/main/plugins/llm-application-dev/skills/prompt-engineering-patterns
  (`511f834`, 2026-07-07)
- **License:** MIT, Copyright (c) 2024 Seth Hobson - `LICENSES/MIT-wshobson-agents.txt`
- **Used for:** the three quoted phrases marked `[1]` in `SKILL.md` ("Show, Don't Tell",
  "Example pollution", "No error handling"), from its Best Practices and Common Pitfalls
  lists.

---

## obra/superpowers - writing-skills

- **URL:** https://github.com/obra/superpowers/blob/main/skills/writing-skills/references/persuasion-principles.md
  (`2ce8aa1`, 2026-10-21)
- **License:** MIT, Copyright (c) 2025 Jesse Vincent - `LICENSES/MIT-obra-superpowers.txt`
- **Files contributed:** `references/persuasion-principles.md`, unchanged.

---

## Original to this repository

- "Rules an agent reads": the owner's "Match structure to signal density" section from 1.1.0,
  made self-contained, plus the one-item-per-condition bullet.
- "Prompts run in production": written from the evaluation results, around the quoted
  phrases above.
- `evals/`: behaviour and trigger cases for `claude plugin eval`.

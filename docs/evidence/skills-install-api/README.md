# Evidence: skills.sh API path in install-skills.sh

Kept for reference (owner request, 2026-11-04). Supports PR #116.

- `research.md` - options to speed up skill installs (French, as delivered to the owner): `skills` CLI 1.7.6 source read, skills.sh API, raw references, vendoring, plugins.
- `test-report.md` - sub-agent test of commit `7287f3f`: speed (3 runs), fidelity (`diff -r` vs forced npx), fallback, unpack safety, partial failure.
- `out*.txt` - hook stdout per run (`outnpx.txt`: `SKILLS_DOWNLOAD_URL=http://127.0.0.1:9`, forced npx; `out5.txt`: partial failure).
- `curl.log`, `curl-wrapper.sh` - URL log of every curl call, and the PATH wrapper that wrote it.
- `ex.sh` - extracts the `UNPACK` snippet from the hook for the safety test.
- `fixtures/` - crafted payloads (`evil`, `sib`, `abs`: path escapes; `nosk`: no SKILL.md) and the consumer `skills.txt` adding an unknown skill.

Environment: Claude Code cloud container behind the session HTTPS proxy, 2026-11-03/04. Timings depend on that proxy.

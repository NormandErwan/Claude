# Evidence: skills.sh API path in install-skills.sh

Kept for reference (owner request, 2026-11-04). Supports PR #116. Raw run logs and fixtures dropped 2026-11-08 (owner): the test report states their results.

- `research.md` - options to speed up skill installs (French, as delivered to the owner): `skills` CLI 1.7.6 source read, skills.sh API, raw references, vendoring, plugins.
- `test-report.md` - sub-agent test of commit `7287f3f`: speed (3 runs), fidelity (`diff -r` vs forced npx), fallback, unpack safety, partial failure.

Environment: Claude Code cloud container behind the session HTTPS proxy, 2026-11-03/04. Timings depend on that proxy.

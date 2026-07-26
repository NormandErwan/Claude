#!/bin/bash
set -euo pipefail

# Experiment: install README.md's `## Usage` skills before turn 1, testing
# whether a real SessionStart hook (vs. an agentic Bootstrap instruction)
# makes them invocable via the Skill tool from the start of the session.
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "$CLAUDE_PROJECT_DIR"

grep -E '^npx skills add ' README.md | while IFS= read -r cmd; do
  $cmd -y || true
done

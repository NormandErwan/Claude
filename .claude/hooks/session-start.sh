#!/bin/bash
# This repo's own hook (dogfooding). Consumers use templates/hooks/session-start.sh,
# which also syncs CLAUDE.md and skills/ - here they are already the repo.
set -euo pipefail

bash "$CLAUDE_PROJECT_DIR/templates/hooks/inject-agent-skills.sh" "$CLAUDE_PROJECT_DIR/.claude"

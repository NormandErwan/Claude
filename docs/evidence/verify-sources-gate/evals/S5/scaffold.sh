#!/bin/bash
# Seeds the empty run workspace with this repo as it stood at the incident (cf57f1f), later refs
# removed so no later evidence (this test, the ledger rows about the incident) leaks in.
set -e
REPO=$(git -C "$(dirname "$(readlink -f "$0")")" rev-parse --show-toplevel)
git clone -q --no-local "$REPO" . && git checkout -q --detach cf57f1f
git for-each-ref --format='%(refname)' | xargs -rn1 git update-ref -d
git remote remove origin && git reflog expire --expire=now --all && git gc -q --prune=now
# Each arm injects its own CLAUDE.md; the checkout's copy would differ from it, and a pilot
# reported that difference. Hide it from the worktree without a visible git change.
git update-index --skip-worktree CLAUDE.md CLAUDE.web.md && rm CLAUDE.md CLAUDE.web.md

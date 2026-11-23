#!/bin/bash
# Seeds the empty run workspace with this repo as it stood at 60189f5, later refs removed
# so no later evidence (this probe, its results) leaks in. Same checkout as ../run.sh.
set -e
REPO=$(git -C "$(dirname "$(readlink -f "$0")")" rev-parse --show-toplevel)
git clone -q --no-local "$REPO" . && git checkout -q --detach 60189f5
git for-each-ref --format='%(refname)' | xargs -rn1 git update-ref -d
git remote remove origin && git reflog expire --expire=now --all && git gc -q --prune=now

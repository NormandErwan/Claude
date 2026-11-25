#!/bin/bash
# Regression test for check-github-search.sh. Feeds a PreToolUse JSON per case
# and checks the exit code (0 = allowed, 2 = blocked).
#
# Usage: bash .claude/hooks/test-check-github-search.sh [-v]   (-v prints block reasons)
# Exit: 0 all pass, 1 any fail.
set -uo pipefail

H="$(dirname "$0")/check-github-search.sh"
verbose=${1:-}
pass=0
fail=0

# run <label> <expected exit> <command> [remote flag, default true]
run() {
  local out e
  out=$(jq -cn --arg c "$3" '{tool_input: {command: $c}}' | CLAUDE_CODE_REMOTE=${4-true} "$H" 2>&1)
  e=$?
  if [[ $e == "$2" ]]; then pass=$((pass + 1)); echo "ok   $1"; else fail=$((fail + 1)); echo "FAIL $1 (expected $2, got $e)"; fi
  [[ -n "$verbose" && -n "$out" ]] && sed 's/^/       /' <<<"$out"
}

# --- gh api search with fields and no GET: gh sends POST -> proxy 403
run "api search -f" 2 "gh api search/issues -f q='repo:o/r is:pr x'"
run "api /search -F" 2 "gh api /search/code -F q=x"
run "api search --raw-field" 2 "gh api search/code --raw-field q=x --paginate"
run "api search --field=" 2 "gh api search/commits --field=q=x"
run "api search -fq= glued" 2 "gh api search/code -fq=x"
run "api search quoted path" 2 "gh api 'search/code' -f q=x"
run "api search after cd &&" 2 "cd /tmp && gh api search/code -f q=x"
run "api search in pipe" 2 "gh api search/code -f q=x | jq ."
run "api search after env var" 2 "GH_PAGER= gh api search/code -f q=x"
run "api search on 2nd line" 2 $'ls\ngh api search/code -f q=x'
run "api search -X POST" 2 "gh api -X POST search/code -f q=x"

# --- GraphQL-backed search subcommands
run "gh search issues" 2 "gh search issues hook --repo cli/cli"
run "gh search prs" 2 "gh search prs --author x"

# --- allowed: GET forms, REST-backed subcommands, other endpoints
run "api -X GET search" 0 "gh api -X GET search/issues -f q='is:pr x' --paginate"
run "api -X get lowercase" 0 "gh api -X get search/code -f q=x"
run "api -XGET search" 0 "gh api -XGET search/code -f q=x"
run "api --method GET search" 0 "gh api --method GET search/code -f q=x"
run "api --method=GET search" 0 "gh api --method=GET search/code -f q=x"
run "api search query in path" 0 "gh api 'search/code?q=x+repo:o/r'"
run "gh search code" 0 "gh search code hook --repo cli/cli"
run "gh search repos" 0 "gh search repos claude"
run "gh search commits" 0 "gh search commits fix"
run "api POST to non-search path" 0 "gh api repos/o/r/issues -f title=search/x"
run "search words in a quoted string" 0 "git commit -m 'gh search issues fails'"
run "echo of a blocked command" 0 "echo gh api search/code -f q=x"
run "unrelated command" 0 "ls -la"

# --- outside cloud sessions the hook stays out of the way
run "local: gh search issues" 0 "gh search issues x" ""
run "local: api search -f" 0 "gh api search/code -f q=x" ""

echo "pass=$pass fail=$fail"
((fail == 0))

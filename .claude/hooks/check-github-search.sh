#!/bin/bash
# GitHub search gate for cloud sessions. PreToolUse(Bash) hook: exit 2 blocks
# the tool call, stderr goes to Claude. Exit 0 lets it through.
#
# Why: the cloud proxy serves GitHub search as REST GET only. Two forms fail
# with a 403 whose message reads as "search is banned", so agents give up
# (RETROSPECTIVE.md 2026-11-23 tool-blocked; diagnosis in PR #145):
#   - `gh api search/... -f q=...` without GET: fields make gh send a POST
#   - `gh search issues|prs`: GraphQL, refused in cloud sessions
# The working form sits in the main session's system prompt only; this hook
# also reaches subagents, whose prompts lack it.
#
# Acts only when CLAUDE_CODE_REMOTE=true (cloud session).
#
# Test: bash .claude/hooks/test-check-github-search.sh - run it after any change here.
#
# Limits: the command is split on ; & | and newlines, quotes ignored, so a
# separator inside a quoted string splits it too. Misses `bash -c "..."`,
# subshells, aliases, scripts that call gh.
set -uo pipefail

# read stdin first: exiting unread breaks the writer's pipe
cmd=$(jq -r '.tool_input.command // empty')
[[ "${CLAUDE_CODE_REMOTE:-}" == true ]] || exit 0
[[ "$cmd" == *gh* ]] || exit 0

hint="Cloud sessions serve GitHub search as REST GET only. Use:
  gh api -X GET search/<code|issues|repositories|commits> -f q='<terms>' --paginate
search/issues needs is:issue or is:pr in q. gh search code|repos|commits also work."

block() { printf 'blocked: %s\n%s\n' "$1" "$hint" >&2; exit 2; }

while IFS= read -r seg; do
  read -ra w <<<"$seg"
  # skip leading VAR=value assignments
  i=0
  while ((i < ${#w[@]})) && [[ "${w[i]}" =~ ^[A-Za-z_][A-Za-z0-9_]*= ]]; do i=$((i + 1)); done
  [[ "${w[i]:-}" == gh ]] || continue
  if [[ "${w[i + 1]:-}" == search && "${w[i + 2]:-}" =~ ^(issues|prs)$ ]]; then
    block "gh search ${w[i + 2]} uses GraphQL, refused here (403)."
  fi
  [[ "${w[i + 1]:-}" == api ]] || continue
  path=0 fields=0 get=0 prev=
  for t in "${w[@]:i+2}"; do
    t=${t#[\'\"]}
    [[ "$t" =~ ^/?search/ ]] && path=1
    [[ "$t" =~ ^(-[fF].*|--(field|raw-field|input)(=.*)?)$ ]] && fields=1
    u=${t^^}
    [[ "$u" =~ ^(-XGET|--METHOD=GET)$ || ( "$prev" =~ ^(-X|--method)$ && "$u" == GET ) ]] && get=1
    prev=$t
  done
  ((path && fields && !get)) && block "gh api search/... with -f/-F and no -X GET sends a POST, refused here (403)."
done < <(sed -E 's/\|\||&&|[;&|]/\n/g' <<<"$cmd")
exit 0

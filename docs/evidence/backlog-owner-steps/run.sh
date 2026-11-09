#!/bin/bash
# usage: run.sh <arm A|B> <run-id like C1-r1> ; reads cases.tsv
S=${OS_DIR:?}; ARM=$1; ID=$2; CASE=${ID%%-r*}
HERE=$(cd "$(dirname "$0")" && pwd)
LINE=$(grep -P "^$CASE\t" "$HERE/cases.tsv") || { echo "no case $CASE"; exit 1; }
SEED=$(cut -f2 <<<"$LINE"); PROMPT=$(cut -f3 <<<"$LINE")
R=$S/runs/$ID-$ARM; [ -e "$R" ] && { echo "exists: $R"; exit 1; }
mkdir -p $R/cfg; cp -r "$HERE/fixture" $R/w; cp -r "$S/arms/$ARM" $R/w/.claude
if [ "$SEED" != "-" ]; then cp "$HERE/seeds/$SEED-$ARM.md" $R/w/BACKLOG.md; fi
[ "$SEED" = pending ] && sed -i 's/rotate 7/rotate 14/' $R/w/logrotate/app
git init -q --bare $R/origin.git
cd $R/w && git init -q -b main && git add -A && git -c user.name=t -c user.email=t@t commit -qm init && git remote add origin $R/origin.git && git push -q origin main 2>/dev/null
printf '{"projects":{"%s":{"hasTrustDialogAccepted":true}}}' "$R/w" > $R/cfg/.claude.json
env -u CLAUDE_CODE_ADDITIONAL_DIRECTORIES_CLAUDE_MD -u CLAUDE_ADDITIONAL_DIRECTORIES -u CLAUDECODE -u CLAUDE_CODE_SESSION_ID -u CLAUDE_CODE_REMOTE_SESSION_ID \
  CLAUDE_CONFIG_DIR=$R/cfg timeout 900 claude -p "$PROMPT" --model claude-opus-5-5 \
  --output-format stream-json --verbose --permission-mode acceptEdits \
  --allowedTools Read Write Edit Glob Grep Skill Bash \
  < /dev/null > $R/transcript.jsonl 2> $R/stderr.txt
echo "$ARM $ID exit=$?"

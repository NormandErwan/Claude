# Backlog

Work not done yet, one `###` section per task. Format and rules: the `backlog` skill.

## Tasks

### Keep 14 days of app logs
- **Status:** owner steps pending
- **Context:** disk on `srv1` has room; owner wants two weeks of logs for incident review.
  `logrotate/app` now keeps 14 files (merged).
- **Next:** none for the agent; waits on the owner steps.
- **Done when:**
  - [x] `logrotate/app` keeps 14 rotated files
  - [ ] `srv1` keeps 14 days of logs
- **Owner steps:** after merge
  1. Copy the file to `srv1`: `scp logrotate/app srv1:/tmp/app && ssh srv1 'sudo cp /tmp/app /etc/logrotate.d/app'`
     - Check: `ssh srv1 'grep rotate /etc/logrotate.d/app'` prints `rotate 14`
     - Undo: `git show HEAD~1:logrotate/app | ssh srv1 'sudo tee /etc/logrotate.d/app'`
  2. Dry-run logrotate: `ssh srv1 'sudo logrotate -d /etc/logrotate.d/app'`
     - Check: no `error:` line in the output
     - Undo: nothing to undo

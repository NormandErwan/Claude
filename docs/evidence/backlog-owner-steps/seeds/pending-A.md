# Backlog

Work not done yet, one `###` section per task. Format and rules: the `backlog` skill.

## Tasks

### Keep 14 days of app logs
Status: blocked: owner deploys `logrotate/app` to `srv1`
Context: `logrotate/app` now keeps 14 files (merged). Owner copies it to `/etc/logrotate.d/app`
on `srv1`, then runs `sudo logrotate -d /etc/logrotate.d/app` and checks it reports
`rotate 14`; rollback: restore the previous file from git.
Next: owner deploys on `srv1`.
Done when:
- [x] `logrotate/app` keeps 14 rotated files
- [ ] `srv1` keeps 14 days of logs

# Backlog

Work not done yet, one `###` section per task. Format and rules: the `backlog` skill.

## Tasks

### Keep 14 days of app logs
- **Status:** ready
- **Context:** disk on `srv1` has room; owner wants two weeks of logs for incident review.
  Rotation is set in `logrotate/app`, deployed by the owner (see `README.md`).
- **Next:** change the retention in `logrotate/app`.
- **Done when:**
  - [ ] `logrotate/app` keeps 14 rotated files
  - [ ] `srv1` keeps 14 days of logs

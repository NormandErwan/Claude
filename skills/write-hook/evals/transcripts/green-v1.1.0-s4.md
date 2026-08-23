Since this is a `UserPromptSubmit` hook (not `Stop`), the skill's guard rule doesn't apply — stdout on exit 0 is added to context as-is, and `UserPromptSubmit` doesn't re-trigger itself. Here's the minimal version:

**`.claude/hooks/branch-note.sh`**
```bash
#!/bin/bash
branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
[ -n "$branch" ] && echo "Current git branch: $branch"
```

Make it executable: `chmod +x .claude/hooks/branch-note.sh`

**`.claude/settings.json`**
```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash .claude/hooks/branch-note.sh"
          }
        ]
      }
    ]
  }
}
```

If `.claude/settings.json` already has other keys, just merge this `UserPromptSubmit` array into the existing `hooks` object. No `stop_hook_active` check needed here — that guard is only for `Stop` hooks, which can re-fire the turn they're injecting into.

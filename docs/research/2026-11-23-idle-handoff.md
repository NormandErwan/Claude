# Idle-triggered handoff after 50 minutes without a user reply

Research note, 2026-11-23. Docs read as the raw `.md` pages of https://code.claude.com/docs/en/ on
2026-11-23 (changelog top entry 2.1.330, 2026-11-20; local CLI is 2.1.330). Nothing here was run:
every design below is untested.

## Question

Can Claude Code trigger a "handoff" by itself (Claude writes a summary document for another agent)
after 50 minutes with no user reply, (a) in a cloud session on claude.ai/code, whose container is
reclaimed after inactivity, and (b) in the local CLI? Seven sub-questions: `asyncRewake`, whether
background hooks outlive the turn, cancelling, `idle_prompt`, cloud inactivity and scheduling,
`/loop` and cron, and existing tools.

## Summary

- **Local CLI: yes, two routes.** (1) An existing plugin does exactly this with a 50-minute
  default: `obie/auto-handoff` [G1]. It uses the mods API (an in-process timer armed at
  `turn.complete`, cancelled at `turn.start`), so there is nothing to build. (2) A settings hook:
  `Stop` command hook with `"asyncRewake": true`, a long `timeout`, a sleep, and a nonce file that a
  `UserPromptSubmit` hook overwrites. All its pieces are documented [H1-H4], but the combination is
  untested, and one third-party report says a `Stop`-started `asyncRewake` does not wake an idle
  session [L1] (it contradicts the docs; see Q1).
- **Cloud: not with any in-VM timer.** The docs say a cloud VM "pauses" after "a few minutes
  without activity" [C2] and, once reclaimed, background shell commands and session-scoped
  scheduled tasks "don't carry over" [C1]. A 50-minute timer inside the VM cannot be relied on.
  Only a trigger from outside the VM can work, and none is documented as "fire if no reply".
  The nearest documented piece is `claude -p "..." --cloud <session-id>`, which queues a message
  into an existing cloud session [C3]; whether it works on a paused or reclaimed VM is not stated.
- **No native idle event.** `idle_prompt` fires about 60 s after a turn, is not configurable (no
  source found for any setting or env var), and its output cannot reach the model [H5].
  The feature request for an idle hook (#68060) was closed as not planned [G2].
- **Cancel-on-reply has no documented mechanism.** It is a DIY pattern (nonce or PID file written
  by `UserPromptSubmit`). `UserPromptSubmit` also fires for cron and `/loop` wakeups [H6], so the
  cancel script must tell them apart.
- **Timeout:** `asyncRewake` keeps the `timeout` limit (default 600 s) [H3]; no maximum is
  documented, so 3000-3600 s is allowed on the docs' wording (hypothesis, untested).
- **Recommended design:** CLI: install `obie/auto-handoff` (or the `asyncRewake` sketch if a
  settings-only solution is required, after a 2-minute test with a short delay). Cloud: do not
  promise idle handoff; write the handoff at the end of each work unit (rule or `Stop` hook), or
  drive an external `--cloud` message and test it first.

## Findings

Quotes are exact. `[H]` = hooks reference, `[C]` = cloud pages, `[S]` = scheduled-tasks pages,
`[G]` = anthropics/claude-code or other GitHub, `[L]` = lead (non-primary). URLs are in Sources.

### Q1. `asyncRewake`

- **Definition** [H1], command hook fields table: "If `true`, runs in the background and wakes
  Claude on exit code 2. The hook's stderr, or stdout if stderr is empty, is shown to Claude as a
  system reminder so it can react to a long-running background failure".
- **Idle wake** [H2], "Limitations": "Exception: an `asyncRewake` hook that exits with code 2 wakes
  Claude immediately even when the session is idle." The same list says ordinary async output "is
  delivered on the next conversation turn. If the session is idle, the response waits until the
  next user interaction."
- **Allowed on `Stop`?** Not stated for `asyncRewake` by name. The field belongs to command hooks
  [H1], and `Stop` is listed among events that support `command` hooks [H7]. So `Stop` is
  allowed by the schema; "works on `Stop`" is an inference.
  - Exit code 2 on `Stop` otherwise means "Prevents Claude from stopping, continues the
    conversation" [H8]. Whether a background `asyncRewake` hook still triggers that path or only
    the wake-up is not documented. `onFailure` explicitly "has no effect" on "command hooks that
    set `async` or `asyncRewake`" [H9], which shows they are a separate class.
- **Timeout** [H3]: "Once an async hook is running in the background, Claude Code doesn't enforce
  `timeout` on it. Claude Code still enforces `timeout` on a hook you run with `asyncRewake`."
  Default [H10]: "Defaults: 600 for `command`, `http`, and `mcp_tool`". Unit: "Seconds before
  canceling." No maximum is stated anywhere in the hooks page (searched "maximum", "max"); only
  `SessionEnd` has a cap ("up to 60 seconds"). So `"timeout": 3100` is accepted by the documented
  schema; a hidden cap is a hypothesis to exclude with a test.
- **Introduced:** no source found. The earliest changelog line naming it is a fix in 2.1.287:
  "Fixed hooks configured with `asyncRewake` waking Claude over and over with "found issues"
  notifications when the hook's script file is missing; the broken hook is now reported once" [G3].
  GitHub issue #44881 shows it in use on 2026-04-07 [G4], so it predates April 2026.
- **Known bug, `-p` and desktop** [G5] (open, #89960, reported on 2.1.246 and again on 2.1.328):
  a hook is backgrounded only when `e.async || e.asyncRewake && (isInteractive() ||
  hasStreamingInput())`, so under `claude -p` it runs synchronously and exit 2 "never reaches the
  model". The interactive CLI is not affected per that report. The "Implies `async`" sentence the
  issue quotes is no longer in the current docs [H1].
- **Conflict to test:** a community script says "Stop hook CANNOT wake an IDLE session ...
  `asyncRewake` on `Stop` fires at a *turn boundary*", measured on 2.1.163, and recommends
  `FileChanged` + `watchPaths` instead [L1]. The official text [H2] says the opposite for a hook
  that exits 2. Official docs win by default, but the claim is untested here.

### Q2. Do background hooks survive after the turn ends?

- **CLI, interactive:** the docs describe hooks running while "the session runs" and name the
  teardown rule only for `-p` [H3]: "In non-interactive mode with the `-p` flag, Claude Code kills
  any async hook still running at teardown and finalizes it with outcome `cancelled`". For an idle
  interactive session, the Exception in [H2] ("wakes Claude immediately even when the session is
  idle") implies the process keeps running. No time limit other than `timeout` is documented for
  `asyncRewake`; `async: true` has none [H3].
- **Switching conversations:** [H11] "If you run `/clear` or switch to another conversation while
  background hooks are still running, nothing they return applies to the session." Fine for us:
  `/clear` cancels the handoff, as in `auto-handoff` [G1].
- **Each `Stop` spawns a new process:** [H2] "Each execution creates a separate background process."
  So N turns leave N sleeping hooks; the old ones must neutralise themselves (Q3).
- **Cloud:** the VM pauses after "a few minutes without activity ... with its files saved. Your
  next message restores the same VM and starts Claude Code again" [C2]. Claude Code is started
  again, so a sleeping hook process is not documented to survive. After reclaim: "Not restored:
  background work that was still running or pending when the VM was reclaimed" [C1]. Whether a
  paused VM freezes processes (and they resume) or kills them is not stated: no source found.
  Either way, a 50-minute timer cannot count wall-clock time while the VM is paused.

### Q3. Cancelling a pending async hook from `UserPromptSubmit`

- No documented mechanism: the hooks page (searched "cancel", "kill", "async") offers no handle to
  an earlier async hook, and no PID or id is exposed to later hooks. No source found; DIY only.
- Documented facts that matter for a DIY cancel:
  - `UserPromptSubmit` default timeout is 30 s for `command` hooks [H10], so the cancel must be
    quick.
  - It "doesn't fire only on prompts you type": it also runs on "A session-scoped scheduled task
    firing, including a `/loop` iteration", on a background subagent reporting back, and on "A
    message another session sends" [H6]. A naive "any `UserPromptSubmit` cancels" would also be
    triggered by the handoff's own wake-up or by cron. The hook input has no documented "source"
    field in the section read; test what stdin contains.
  - `Stop` input carries `stop_hook_active`, `background_tasks`, `session_crons` [H8]; useful to
    skip arming while other work is pending.
- DIY pattern (sketch below): `Stop` writes a nonce into a state file and starts the sleeper;
  `UserPromptSubmit` rewrites the nonce; the sleeper compares after waking and exits 0 if changed.
  The same idea as `auto-handoff`'s "armed at `turn.complete` and cancelled at `turn.start`" [G1].

### Q4. `Notification` with `idle_prompt`

- Delay [H5]: "`idle_prompt` | Claude finished responding about 60 seconds ago and you haven't typed
  since". Also "only if you haven't typed since and no background agent, such as a background
  subagent, is still running". Fix note: "Fixed `idle_prompt` notification hooks firing while
  background agents are still running" (2.1.288) [G6].
- Configurable? No source found. Searched hooks, settings, settings-reference, env-vars and the
  changelog for `messageIdleNotifThresholdMs`, "threshold", `idle` settings: the only idle settings
  are `idleCompaction` (about one hour; compaction only) [S3] and `CLAUDE_CODE_IDLE_COMPACT_MIN_TOKENS`.
  Neither triggers a hook. The 60 s is not a knob.
- Output to the model? No [H5]: "Notification hooks can't block or modify notifications. Claude
  Code discards their `systemMessage` and `continue` fields", and exit code 2 behavior for
  `Notification` is "No | Exit code and stderr are ignored" [H8b]. It could only start a side
  process (for example start a 49-minute timer), not inject text.
- It is a one-shot 60 s signal after a turn, not a 50-minute one; it also needs the user to "appear
  to be away" in terminal sessions. Cloud behavior: no source found.
- Closest official request: #68060, "Claude Code has no hook event that fires on inactivity",
  asking for an `Idle` event with `idleThresholdMs`. State: closed as not planned by the stale bot
  on 2026-07-25, no maintainer reply [G2].

### Q5. Cloud sessions

- **Inactivity delay:** "Cloud sessions stop after a period of inactivity and the session's VM is
  reclaimed." [C1]; "after a few minutes without activity, a session's VM pauses with its files
  saved, and a paused VM can later be reclaimed." [C4]. No numbers: the pause delay is "a few
  minutes" and the reclaim delay is not given. So at 50 minutes the VM is almost certainly paused
  (inference from "a few minutes").
- **Repo hooks run?** Yes in an Anthropic-hosted session with one repository: "Your repo's
  `.claude/settings.json` hooks and permission rules | Yes, in a session with one repository"
  [C5]. Not in a multi-repository session, nor in a cloud thread of a project [C5]. User-level
  `~/.claude/settings.json` hooks "stay on your machine" [C5]. Hooks run in cloud and local alike;
  skip local with `CLAUDE_CODE_REMOTE` [C5]. `SessionStart` hooks default to 600 s unless set [C4].
- **Scheduled message surviving reclaim and resuming the same session?**
  - Session-scoped tasks: "tasks you scheduled in the session and a `/loop` waiting for its next
    iteration don't carry over to the reopened session" [C1].
  - Cloud scheduled tasks (routines): each run "opens as a full session, a new one for each run"
    [S2]; schedule min interval 1 hour [S1]; one-off runs exist [S2]. Exception: in a project, "a
    run can continue a thread rather than start a new session" [S2b]. None of this is "fire into
    this session if idle".
  - `send_later` / `create_trigger` (tools in this session, not in the public docs): the tool text
    says it delivers a message "back into THIS SESSION" and "Delivery survives container restarts".
    This is a tool description, not documentation; whether it resumes a reclaimed cloud session,
    and whether it can be cancelled by a reply, is unverified. (It is also not a "fire only if no
    reply" primitive: one would have to cancel it with `delete_trigger` from a hook, which has no
    access to that tool.)
  - External push: `claude -p "your message" --cloud <session-id>`: "The CLI queues the message
    into the session and exits without waiting for a reply" [C3]; errors if "the session is
    missing or archived" [C3]. Needs a machine or CI job that is awake at +50 min and knows the
    session id and the last-activity time. Documented for follow-ups; not documented for waking a
    reclaimed VM (the web doc says reopening the session provisions a fresh VM [C1]).

### Q6. `/loop`, `CronCreate`, scheduled tasks

| Tool | Facts | Fits "fire if no reply for 50 min"? |
|---|---|---|
| `/loop` without interval (dynamic, `ScheduleWakeup`) | "After each iteration it picks a delay between one minute and one hour"; stop with `stop: true`; 7-day expiry applies; "isn't restored" on `--resume` [S4] | Delay cap is one hour, so 50 min fits. But it re-fires from its own iteration, not from the user's last message, and the model picks the delay. Weak fit |
| `CronCreate` one-shot ("in 45 minutes, check ...") | Fires only "while Claude Code is running and idle"; no catch-up; recurring tasks expire after 7 days; min interval 1 minute; one-shots at :00/:30 run up to 90 s early [S4] | Fires 50 min after creation whatever the user did in between (it fires once idle, so a busy session delays it). Cancelling needs the model (`CronDelete`); a hook cannot call it. Can be made safe by prompt text ("do nothing if the user wrote since"), at the cost of one model turn |
| Desktop scheduled task | Your machine; min 1 minute when Claude sets it, 1 hour in forms [S1] | Not session-bound |
| Cloud routine | New session per run; min 1 hour; 100 scheduled runs per hour account-wide [S2] | Not the same session |

`Stop` input exposes `session_crons` and `background_tasks` [H8], so a hook can see what is
pending. No primitive in the docs expresses "no user message since T". The condition must be
checked by a script (state file) or by the mod timer pattern [G1].

### Q7. Existing tools

| Tool | URL | What it does | Fit |
|---|---|---|---|
| `obie/auto-handoff` (106 stars, MIT, 3 commits, tested on 2.1.289) | https://github.com/obie/auto-handoff | "After 50 minutes of idle time, it runs a handoff command ... as if you had typed it, while the cache is still warm." Timer "armed at `turn.complete` and cancelled at `turn.start`"; one handoff per absence; `/clear` cancels; skips if a sleep made the timer late; writes under `docs/handoffs/`. Config `minutes` (default 50), `command`. Built on the "function hooks plugin API, which is early access" | Exact match for the CLI. Timer lives in the process: "quitting Claude Code stops it". Cloud not stated |
| `vasilispapg/claude-handoff` | https://github.com/vasilispapg/claude-handoff | Turns a session transcript into `handoff.md`; `SessionEnd` and `PreCompact` hooks; no idle trigger; no LLM calls by default | Handoff writer only; no idle |
| `carryover` | https://docs.rs/crate/carryover/0.1.2/source/ARCHITECTURE.md | Local daemon writing a bounded handoff (50 lines or fewer); hook-triggered, "not idle detection" | Same: no idle |
| `pi-shell-acp` raw-async-delivery (community) | https://cdn.jsdelivr.net/npm/@junghanacs/pi-shell-acp@0.11.0/scripts/raw-async-delivery/README.md | Pushes async messages into a live session; documents `asyncRewake` caveats (Q1 conflict) | Lead only |
| Idle-hook request #68060 | https://github.com/anthropics/claude-code/issues/68060 | Asks for an `Idle` event; says the workaround "requires an external launchd/cron watcher polling the transcript JSONL" | Confirms no native option |
| `asyncRewake` bugs #89960, #44881 | https://github.com/anthropics/claude-code/issues/89960, https://github.com/anthropics/claude-code/issues/44881 | `-p`/desktop runs it synchronously; `SessionStart` output shown as a visible reminder (closed duplicate of #44872) | Risks for design B |

Not found: a GitHub Action that triggers a handoff on idle; an idle-handoff tool for cloud sessions.
Search was by web search and fetching pages only (see Open questions).

## Design sketch (untested)

### Design A, local CLI: install the plugin

```
/plugin marketplace add obie/auto-handoff
/plugin install auto-handoff@auto-handoff
```

Set `minutes` to 50 only if the session uses the one-hour prompt cache (the README says the
plugin cannot detect which cache applies [G1]). Requires mods (v2.1.287 or later per the mods
overview [P1]). Not tested here.

### Design B, local CLI: settings hooks with `asyncRewake` (untested)

`.claude/settings.json`:

```json
{
  "hooks": {
    "Stop": [
      { "hooks": [ {
        "type": "command",
        "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/idle-arm.sh",
        "asyncRewake": true,
        "timeout": 3200
      } ] }
    ],
    "UserPromptSubmit": [
      { "hooks": [ {
        "type": "command",
        "command": "${CLAUDE_PROJECT_DIR}/.claude/hooks/idle-cancel.sh",
        "timeout": 5
      } ] }
    ]
  }
}
```

`idle-arm.sh` (outline):

1. Read stdin JSON; take `session_id`, `stop_hook_active`.
2. If a `handoff-done-<session_id>` flag exists, or `stop_hook_active` is true, exit 0 (this stops
   the handoff turn's own `Stop` from re-arming, the `isDone` idea of [G1]).
3. Write a fresh nonce (and `date +%s`) to `$STATE/<session_id>.nonce`.
4. `sleep 3000`. If the machine slept, the real elapsed time is longer: compare `date +%s` with the
   start and exit 0 if late by more than about 10 percent (the cache is cold), like [G1].
5. If the nonce file still equals ours: `touch handoff-done-<session_id>`; write to stderr
   "No user reply for 50 minutes. Invoke the handoff skill now and write the document"; `exit 2`.
   Otherwise `exit 0`.

`idle-cancel.sh` (outline): write a new nonce to `$STATE/<session_id>.nonce`, and remove
`handoff-done-<session_id>`. Open point: it also runs for cron and subagent wake-ups [H6]; the
wake-up caused by our own `exit 2` is not documented as a `UserPromptSubmit`, so check with a
debug log whether stdin lets the script tell them apart.

Checks before trusting it (each cheap, in an interactive session, with `sleep 20` instead of 3000):
(1) exit 2 from a `Stop`-started `asyncRewake` wakes an idle session [H2 vs L1]; (2) a new prompt
neutralises it; (3) `timeout: 3200` is not capped; (4) N turns leave N sleepers that all exit 0.
Never test with `claude -p` (runs synchronously [G5]).

### Design C, cloud: no in-VM timer

- Do not rely on any hook or cron for "50 minutes idle": the VM is paused after "a few minutes"
  [C2].
- Option 1 (most robust): produce the handoff while the VM is awake, at the end of each work unit,
  by a project rule or a `Stop` hook returning `additionalContext` (mind the 8-continuation cap
  [H8]) that asks Claude to refresh `docs/handoffs/<session>.md` and push it.
- Option 2 (untested): an external scheduler (a machine of yours, a CI job) tracks last activity and
  runs `claude -p "<handoff request>" --cloud <session-id>` [C3] after 50 minutes. Needs the
  session id, a way to know the last reply time, and a test that it resumes a paused VM.

## Open questions / unverified

Hypotheses or "no source found", none tested:

1. Whether `asyncRewake` is honoured on `Stop` and wakes an idle session after exit 2 (docs say it
   wakes an idle session [H2]; community report says a `Stop`-started hook does not [L1]).
2. Whether `timeout` accepts 3000-3600 with no hidden cap (docs state no maximum).
3. Which changelog version introduced `asyncRewake` (earliest mention found: fix in 2.1.287; in use
   by 2026-04-07 per #44881).
4. Whether a sleeping hook process survives a paused cloud VM, and what "a few minutes" and the
   reclaim delay are exactly (no numbers in docs).
5. Whether `UserPromptSubmit` stdin tells a typed prompt from a cron, subagent, or rewake
   injection; whether the rewake from exit 2 itself fires `UserPromptSubmit`.
6. Whether `idle_prompt` fires in cloud sessions, and whether anything configures its 60 s (no
   source found in docs, settings, env vars or changelog).
7. Whether `claude -p --cloud <id>` or `send_later` reaches a paused or reclaimed cloud VM.
8. Whether `obie/auto-handoff` works in a cloud session (README silent); mods run in a cloud session
   only "for a plugin that reaches the cloud session" [P1], and timers there face the same pause.
9. Search coverage for Q7: the `gh api search` call returned HTTP 403 and the GitHub MCP tools are
   limited to `normanderwan/claude`, so GitHub issue and code search was done only through web
   search and page fetches. A tool or Action not indexed by web search could exist. Other
   claims taken from issue pages (#68060, #89960, #44881) come from fetched summaries, not raw
   API data.
10. Docs change quickly (this page revision still has fixes up to 2.1.330); recheck before building.

## Sources

Docs fetched 2026-11-23 as `<url>.md`.

- [H1] https://code.claude.com/docs/en/hooks, "Command hook fields" (`asyncRewake` row)
- [H2] same, "Run hooks in the background" > "Limitations"
- [H3] same, "Run hooks in the background" > "Configure an async hook"
- [H4] same, "Stop" (input, decision control)
- [H5] same, "Notification" (matcher table, note on timing, "Notification input")
- [H6] same, "UserPromptSubmit" (list of what also fires it)
- [H7] same, "Events that support `command`..." lists (`Stop` is in the first list)
- [H8] same, "Stop" and "Exit code 2 behavior per event"; [H8b] same table, `Notification` row
- [H9] same, "Block the action when a hook fails"
- [H10] same, "Common fields" (`timeout` row)
- [H11] same, "SessionStart" (background hooks and `/clear`)
- [C1] https://code.claude.com/docs/en/claude-code-on-the-web, "Environment expired"
- [C2] https://code.claude.com/docs/en/cloud-environments, "Set environment variables"
- [C3] https://code.claude.com/docs/en/claude-code-on-the-web, "Send follow-ups from the CLI"
- [C4] https://code.claude.com/docs/en/cloud-environments, "Time limits"
- [C5] same page, "What carries over from your setup" table; "Setup scripts vs. SessionStart hooks"
- [S1] https://code.claude.com/docs/en/scheduled-tasks, "Compare scheduling options"
- [S2] https://code.claude.com/docs/en/routines, "Usage and limits"; "Schedule a one-off run";
  [S2b] same, permission modes in a project
- [S3] https://code.claude.com/docs/en/settings-reference, `idleCompaction`
- [S4] https://code.claude.com/docs/en/scheduled-tasks ("Let Claude choose the interval", "Seven-day
  expiry", "Limitations", "Jitter")
- [P1] https://code.claude.com/docs/en/plugins/mods/overview ("Where mods run"; version line) and
  https://code.claude.com/docs/en/plugins/mods/api ("Start a turn from a background job",
  `$.clock`)
- [G1] https://github.com/obie/auto-handoff (README; `hooks/register.ts` read as raw file)
- [G2] https://github.com/anthropics/claude-code/issues/68060
- [G3] https://code.claude.com/docs/en/changelog (2.1.287, `asyncRewake` fix; generated from
  https://github.com/anthropics/claude-code/blob/main/CHANGELOG.md)
- [G4] https://github.com/anthropics/claude-code/issues/44881
- [G5] https://github.com/anthropics/claude-code/issues/89960
- [G6] https://code.claude.com/docs/en/changelog (2.1.288, `idle_prompt` fix, issue #93672)
- [L1] Lead, community, not authoritative:
  https://cdn.jsdelivr.net/npm/@junghanacs/pi-shell-acp@0.11.0/scripts/raw-async-delivery/README.md
- Other tools: https://github.com/vasilispapg/claude-handoff,
  https://docs.rs/crate/carryover/0.1.2/source/ARCHITECTURE.md (both read, third-party)
- This session's own `send_later` / `create_trigger` tool descriptions (not public docs).

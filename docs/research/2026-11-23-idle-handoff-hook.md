# Idle handoff in cloud sessions: "montage 1" (`UserPromptSubmit` reminder + `send_later`)

Research note, 2026-11-23. Builds on `docs/research/2026-11-23-idle-handoff.md` (the "prior note");
its findings are not repeated, only cited as "prior note Q<n>". Docs read as the raw `.md` pages of
https://code.claude.com/docs/en/ on 2026-11-23 (hooks, hooks-guide, claude-code-on-the-web,
cloud-environments, scheduled-tasks, routines, env-vars, settings-reference, cross-session-messaging,
changelog). Nothing was run except read-only calls (`list_triggers`, reading this session's own
transcript and environment). Every design below is untested.

## Question

Montage 1: a `UserPromptSubmit` command hook committed in `.claude/settings.json` prints a short
reminder on stdout. The reminder asks Claude to end each turn by cancelling the pending idle-handoff
reminder (`delete_trigger`) and scheduling a new one with `send_later` (claude-code-remote MCP
server), 50 minutes ahead. If that scheduled message fires, 50 minutes passed with no user message:
Claude writes a handoff, commits and pushes it. The script is silent outside cloud sessions
(`CLAUDE_CODE_REMOTE`); a `CLAUDE.md` rule states the same. Does it work, what are the limits, and
what does it take in this repo?

## Summary

Verdict: **plausible, probabilistic, not a guarantee, and three gates are unverified. Smoke-test
before building.**

- **Fits the platform.** It avoids the in-VM timer problem of the prior note (a VM pauses after "a few
  minutes" [C2]): the timer lives server-side. The account's trigger history shows one-shot
  `send_later` triggers firing about 50 minutes after creation with run status `SUCCEEDED` [O3].
  That is evidence of delivery to the platform, not of the model receiving the message in a paused VM.
- **Hook output is reliable if it is fast and short.** Plain stdout of a `UserPromptSubmit` command
  hook is injected as a system reminder [H3, H4]; default timeout 30 s, output discarded on timeout
  [H2]; cap 10,000 characters [H5]. `CLAUDE_CODE_REMOTE` is `"true"` in cloud hook processes [H1, E1]
  and was observed `true` in this session's Bash environment [O1].
- **Main design flaw 1: the hook also fires on non-human turns.** Docs list scheduled tasks,
  background subagents and cross-session messages [H2]; the hook input has no `source` field [H6].
  The wake-up turn would receive the reminder again (re-arm loop) unless the script keys on the
  `prompt` text. A PR-activity or `send_later` wake may or may not fire the hook: no source found.
- **Main design flaw 2: arming depends on the model.** If Claude forgets to re-arm, the stale trigger
  fires while the user is active and claims "50 minutes of silence". Needs a guard: a timestamp file
  written by the hook, checked by Claude on wake (sketch below).
- **Main design flaw 3: this session's own PR-subscription text already tells Claude to keep 50-minute
  `send_later` check-ins and "re-arm"** [O4]. If a PR check-in turn also re-arms the idle trigger, the
  handoff never fires. Only turns started by a user message may re-arm.
- **Cheaper variant:** one reusable trigger moved with `update_trigger` (1 call per turn instead of 2,
  no list clutter) [T3]. Whether `update_trigger` revives a fired one-shot is unverified.
- **Propagation:** a hook added to this repo's `.claude/settings.json` does **not** reach consumers.
  Only `CLAUDE.md` and `skills/` are regenerated at session start; `settings.json` and
  `session-start.sh` are copied by hand [R1]. A `CLAUDE.md` rule does propagate. CONTRIBUTING.md
  requires an A/B test for always-on behavior, a `PROVENANCE.md` row, a `write-prompt` pass (Q7).
- **Recommendation:** run the 5-case smoke test below in a scratch cloud session with a 2-minute delay
  (about 15 tool calls, no repo change). Build only if cases 2 and 3 pass. Keep the prior note's
  Design C option 1 (write the handoff at the end of each work unit) as the fallback: it needs no
  timer.

## Findings

Quotes are exact. Labels: `[H]` hooks reference, `[E]` env-vars, `[C]` cloud pages, `[S]` scheduled
tasks / routines, `[G]` GitHub / changelog, `[T]` tool description in this session (not public docs),
`[O]` observed in this session or this account (not documentation), `[R]` this repo. URLs in Sources.

### Q1. Which turns fire `UserPromptSubmit`, and what does stdin contain?

- **Documented list** [H2]: "`UserPromptSubmit` hooks don't fire only on prompts you type. Claude Code
  also runs them on:" a "session-scoped scheduled task firing, including a `/loop` iteration"; "A
  background subagent reporting back to the session that started it"; "A message another session
  sends to your main conversation"; and, before v2.1.328, Code Mode output. The lifecycle table says
  the same: "Also fires on turns Claude Code starts on its own" [H7].
- **Not in the list** (no source found either way): a `send_later` / cloud scheduled-task wake (a
  server-side trigger, not a session-scoped `CronCreate` task), a GitHub PR-event wake, a
  task-notification (background Bash), an `asyncRewake` wake. For `asyncRewake` the docs only say
  stderr (or stdout) "is shown to Claude as a system reminder" [H8]; they do not say the hook fires.
  Third-party reports conflict: one says task-notifications do not flow through `UserPromptSubmit`,
  another that a `UserPromptSubmit` timestamp hook helped for wakeups (both from search snippets,
  unverified; #39027 [G1] is closed as not planned and never mentions `UserPromptSubmit`).
- **Stdin fields** [H6, H2]: common fields `session_id`, `prompt_id` ("UUID identifying the user
  prompt currently being processed ... Absent until the first user input"), `transcript_path`,
  `cwd`, `scratchpad_dir`, `permission_mode`, `effort`, `hook_event_name`; plus `prompt` and
  `session_title`. **No `source`, `origin` or `trigger` field is documented.** The only documented
  discriminator is the `prompt` text itself.
- **Hidden discriminator in the transcript [O2]** (undocumented): this session's transcript
  (`transcript_path`) tags every user record with `origin` (`{"kind":"human"}` for typed prompts,
  `{"kind":"task-notification"}` for background-task and queued PR notifications), plus `promptSource`
  (`sdk` vs `system`) and `turnOrigin` (`human` vs `task_notification`). A hook could read the last
  user record of `transcript_path`. Caveats: not documented, may change; and "The transcript file is
  written asynchronously and may lag" [H6], so the current prompt's record may be absent when the hook
  runs. GitHub #39027 quotes the same `origin` field [G1]. Whether a `send_later` wake is tagged
  `task-notification` or `human`: not observed (this session's trigger had not fired).
- **Conclusion:** a stable rule is "the wake message carries its own marker in its text" (`[idle-handoff]`),
  and the script exits silently when `.prompt` starts with it. That works whether or not the hook fires on
  that wake.

### Q2. `CLAUDE_CODE_REMOTE`

- **Documented** [E1] (env-vars table): "Set automatically to `true` when Claude Code is running as a
  cloud session. Read this from a hook or setup script to detect whether you are in a cloud session".
- **Exact value** [H1]: "The `$CLAUDE_CODE_REMOTE` environment variable is `"true"` in remote web
  environments and not set in the local CLI." Also [C6]: "the session VM's environment carries that
  variable as `true`, it's never `true` locally". Compare with `= "true"`, not with non-empty.
- **Visible to hook processes:** [H1] says handlers "run ... with Claude Code's environment" and a hook
  process "inherits the parent environment" apart from `OTEL_*` variables and, when
  `CLAUDE_CODE_SUBPROCESS_ENV_SCRUB` is `1`, "the variables it strips" [H6]. Observed: `CLAUDE_CODE_REMOTE=true`
  in this session's Bash tool environment [O1]. A hook-process check was not run. The docs'
  own example scopes a `SessionStart` hook with it [C6]. A user cannot spoof it from settings: "Identity
  variables that Claude Code's hosting environments own, such as `CLAUDE_CODE_REMOTE` ... are ignored
  from every file" [E2].
- **Other signals** (observed, not documented): `CLAUDE_CODE_REMOTE_SESSION_ID` is documented as "Set
  automatically in cloud sessions" [E1]. `CLAUDE_CODE_ENTRYPOINT=remote_mobile` and
  `CLAUDE_CODE_REMOTE_ENVIRONMENT_TYPE=cloud_default` exist in this session's environment [O1] and are
  absent from the env-vars page, hooks page and cloud-environments page (grep, count 0): no source
  found, do not rely on them. `CLAUDE_CODE_BRIDGE_SESSION_ID` marks a local Remote Control session, not
  a cloud one [H1].
- **Scope limit** [C5]: repo hooks run only "in a session with one repository"; not in a multi-repo
  session, not for hooks in a user's `~/.claude/settings.json`.

### Q3. Is stdout reliably injected? Size, form, caveats

- **Injected** [H3]: "`UserPromptSubmit`, `UserPromptExpansion`, `SessionStart`, and `PostModelSwitch`:
  Claude Code adds plain-text stdout as context that Claude can see and act on. It doesn't add stdout it
  failed to parse." Parsing rule [H3]: output that starts with `{` and ends with `}` is treated as JSON;
  plain prose is plain text.
- **Form** [H4]: "Neither channel produces a visible transcript entry. Plain stdout and the
  `additionalContext` value are each injected as a system reminder that starts with the hook's name;
  Claude reads both." Placement: "alongside the submitted prompt" [H9]. The user does not see it.
- **Size** [H5]: "A hook's `additionalContext`, `systemMessage`, and `initialUserMessage` strings, and its
  plain stdout, are capped at 10,000 characters"; above that Claude gets a file path and "a preview of up
  to the first 2,000 characters". A 600-character reminder is far below.
- **Timeout** [H2]: default 30 s; "a `UserPromptSubmit` command ... hook that reaches its timeout is
  canceled and its output, including any `additionalContext`, is discarded. The prompt still reaches
  Claude without that context." Silent loss of the reminder is therefore possible (transcript shows a
  notice). Keep the script to `jq`, `date`, `cat`; set `"timeout": 5`.
- **Caveat on wording** [H9]: "Write the text as factual statements rather than imperative system
  instructions ... Text framed as out-of-band system commands can trigger Claude's prompt-injection
  defenses, which causes Claude to surface the text to you instead of treating it as context." The
  reminder must read as project state plus a pointer to the `CLAUDE.md` rule, not "SYSTEM: do X".
- **Replay** [H9]: on `--continue`/`--resume`, "Claude Code replays the saved text rather than re-running
  the hook for past turns". Harmless here.
- **Per turn cost:** the reminder is re-injected on every prompt and stays in context. About 150 tokens
  per user turn (estimate, not measured); `CLAUDE.md` alone costs the same tokens once per session start
  but does not repeat.
- **Failures are silent to Claude:** a non-zero exit other than 2 is a non-blocking error [H10]; "Claude
  never sees stderr from a hook that exits 0" [H3]. The hook cannot tell whether Claude obeyed.

### Q4. Limits of `send_later` / triggers

The public docs do not describe `send_later`, `create_trigger`, `delete_trigger` or `update_trigger`
(grep over hooks, hooks-guide, claude-code-on-the-web, cloud-environments, scheduled-tasks, routines,
env-vars, settings-reference and the changelog: 0 matches). Everything below is from tool descriptions
[T] or this account's data [O3]. The closest documented feature is cloud scheduled tasks (routines) [S2].

| Topic | Finding | Source |
|---|---|---|
| Minimum delay, granularity | `send_later`: `delay_minutes` "Minimum 1"; "Granularity is one minute — the scheduler polls every minute". Observed fire lag after `run_once_at`: 15 s to 67 s over 12 one-shots | [T1], [O3] |
| Wake while a turn runs | "the message waits and is normally delivered after that turn ends. It does not interrupt a running turn" | [T1] |
| Cron minimum | "Minimum interval is normally hourly" | [T2] |
| Hourly caps | Routines: "Scheduled runs, including one-off runs: 100 per hour, your account"; "None of these hourly limits has overage". Whether `send_later` triggers count against it: no source found (they show `created_kind: REMINDER`, `created_via: meta_mcp`, distinct from routines) | [S2], [O3] |
| Max active triggers per account | No source found | none |
| Creation rate limit | No source found | none |
| Fired one-shot | "the scheduled task disables itself after firing once"; observed `enabled: false`, `ended_reason: run_once_fired`. No deletion needed to stop it | [T1], [O3] |
| List clutter | `list_triggers` hides "One-shot scheduled tasks that already fired" unless `include_completed` is true. With it, the first page of 20 held 18 one-shot reminders plus 1 routine; `has_more` was true | [T4], [O3] |
| Deleted trigger | "the scheduled task no longer exists once this returns"; whether it leaves a list row: no source found | [T5] |
| Session archived or deleted | Observed: 6 of 18 completed one-shots ended `ended_reason: auto_disabled_session_gone` with `last_run.status: FAILED`; the 12 successes all carry a `persistent_session_id`, the 6 failures lack that field. What "gone" means (deleted, archived, VM reclaimed) is not documented. Docs: `--cloud` errors when "the session is missing or archived" and a message to an archived session fails ("is archived and cannot accept new messages") | [O3], [C3], [C7] |
| Deleting a trigger's sessions | "Deleting a scheduled task also deletes every session it started" (applies to fire-into-new-session tasks) | [T5] |
| Survives pause / reclaim | Tool text: "Delivery survives container restarts" [T1]. Docs only say session-scoped tasks "don't carry over" after reclaim [C1] and a paused VM is restored by "Your next message" [C2]. No doc says a server-side message wakes a paused VM. Observed: one-shots created about 50 minutes earlier fired with `SUCCEEDED` [O3]; that status records delivery, and the VM state at that moment is unknown | [T1], [C1], [C2], [O3] |

Doc-only reading: nothing in the public docs supports or contradicts "a `send_later` message resumes a
paused cloud VM". Treat as the first smoke-test gate.

### Q5. Does a fired message trigger hooks; re-arm loop risk

- **`UserPromptSubmit`:** documented for session-scoped scheduled tasks and for "turns Claude Code starts
  on its own" [H2, H7]; not documented for `send_later`. Hypothesis: it fires, because the wake is a
  queued user-role message (this session's PR wakes are stored as `user` records tagged
  `task-notification` [O2]). Untested.
- **`Stop`:** documented as firing when Claude finishes responding [H11]; nothing excludes a wake turn.
  Hypothesis: it fires.
- **Loop mechanism:** wake turn -> hook fires -> reminder says "arm a new trigger" -> Claude arms -> 50
  minutes later the wake fires again: a handoff every 50 minutes forever, with commits and pushes. A
  second variant: PR check-in turns re-arming the idle trigger [O4], so no handoff ever fires.
- **Defences, in order of strength:**
  1. The hook script exits silently when `.prompt` starts with the wake marker (deterministic, no
     model involved).
  2. The wake message itself says what not to do ("this message is not a user message; do not call
     `send_later`, `create_trigger` or `delete_trigger` this turn").
  3. The `CLAUDE.md` rule says re-arm only on a turn "started by a user message".
  4. After a successful handoff the state file gets a `done` flag, so a straggling duplicate wake exits.
- **Recommended wake wording** (factual, so it does not trip the injection defences [H9]):
  `[idle-handoff] The idle timer armed at <epoch> has fired. Project rule "Idle handoff" applies: run
  `bash .claude/hooks/idle-handoff.sh check <epoch>`; on STALE write nothing and stop; on IDLE use the
  handoff skill, commit and push. This message is a timer, not a user message: no timer is created, moved
  or deleted on this turn.`
- **Residual risk:** a user message arriving during the handoff turn; the wake waits for the running turn
  [T1], so handoff and prompt never overlap, but a handoff commit may land after the user has started a
  new task. The branch rule in `CLAUDE.md` (never on a trunk) still applies.

### Q6. Prior art

- No project, plugin or docs example combining `UserPromptSubmit` and scheduled messages for idle
  detection or handoff in cloud sessions: no source found. Web searches for the combination (hook +
  `send_later` + idle handoff + cloud) returned only generic hook documentation. Search coverage is
  limited to web search and page fetches (GitHub code and issue search were not available, as in the
  prior note, Open question 9).
- Related and relevant:
  - Prior note Q7 (`obie/auto-handoff`, CLI only, in-process timer).
  - **The PR-subscription wake text of this session itself [O4]:** "If you have the `send_later` tool,
    keep one safety-net check-in while the PR only waits on reviewers or CI: about 50 minutes after the
    last activity, then about every 4 hours. When it fires, re-check the PR ... if nothing changed, tell
    no one and re-arm. Stop after 3 empty check-ins in a row ... When you stop, cancel any pending
    check-in". That is the same arm / cancel / re-arm pattern, driven by the platform's own prompt, and
    the account history shows it running for days [O3]. It proves the pattern is in normal use; it does
    not prove an idle handoff works. It also shows the loop guard the platform chose: a count of empty
    check-ins.
  - Docs page on auto-fix [C8] confirms Claude "subscribes to GitHub activity on the PR"; no idle logic.
  - #68060, no idle hook event, closed as not planned [prior note G2].

### Q7. This repo: propagation and CONTRIBUTING.md

Read: `.claude/settings.json`, `templates/settings.json`, `templates/hooks/session-start.sh`,
`templates/hooks/install-skills.sh`, `.claude/hooks/check-skills.sh`, `README.md`, `CLAUDE.md`,
`CLAUDE.web.md`, `CONTRIBUTING.md`, `.gitignore` [R1-R4].

- **What the sync copies:** `session-start.sh` clones this repo and copies only `CLAUDE.md` and
  `skills/` into the consumer's `.claude/`, then runs `install-skills.sh` from the fresh clone [R2].
  `README.md`: "`.claude/settings.json` and `.claude/hooks/session-start.sh` are the whole consumer-side
  infra" and are "Copy[ied]" by hand [R1].
- **So:** a `UserPromptSubmit` entry in this repo's `.claude/settings.json` (dogfooding, like the
  `PreToolUse` `check-skills.sh` entry [R3]) does **not** reach consumers. Neither does a script in this
  repo's `.claude/hooks/`.
- **Three ways to reach consumers**, each a structuring choice for the owner:
  1. **Rule only** (`CLAUDE.md`): propagates automatically; no per-turn reminder; relies on the model
     remembering a rule every turn (the prior conversation's "option A"). Cheapest, weakest.
  2. **Rule + hook, hand-copied:** add the entry to `templates/settings.json` and the script to
     `templates/hooks/`; each consumer re-copies `settings.json` once (it already re-copies for new
     hooks, e.g. the `permissions` block). Consumers that skip it still get the rule.
  3. **Rule + hook, self-updating script:** consumers add the `settings.json` entry once, pointing at
     `$CLAUDE_PROJECT_DIR/.claude/hooks/idle-handoff.sh`; `install-skills.sh` (already fetched fresh each
     session [R2]) is extended to copy that script. Mixing skill install and hook install in one
     script is a design cost (hypothesis: a separate `sync-hooks.sh` called from `session-start.sh`
     would need a one-time re-copy of `session-start.sh`).
  Recommendation (inference): option 2 for the test phase (dogfood first in this repo), option 3 only if
  the smoke test passes and at least two consumers want it.
- **`.gitignore`:** this repo ignores everything except an allowlist; `.claude/settings.json` and
  `.claude/hooks/**` are allowed [R4]. Add a state directory (e.g. `.claude/state/`) only if the state
  file lives in the repo; the sketch uses `${TMPDIR:-/tmp}` so nothing changes.
- **CONTRIBUTING.md requirements** [R3]:
  - "Every rule is provisional. Before adding one, extend an existing rule that covers the case." The
    nearest existing rule is Behavior: "User signals a pause or a move elsewhere, or the topic drifts ->
    offer a `handoff`, once per trigger." The idle rule is a distinct trigger (timer), so a new rule is
    defensible, but the owner decides (structuring choice).
  - "A rule earns its place with a logged incident (`PROVENANCE.md` or `RETROSPECTIVE.md`)." No incident
    found in `PROVENANCE.md` (grep "idle", "handoff": only the pause rule). Log one before adding.
  - Section: "Every rule reads trigger -> action. It goes in the section of its domain". Hook and cloud
    tool rules belong in `Claude Code`, not `Behavior`; `CLAUDE.web.md` mirrors `Behavior` only
    ("minus code-only lines (... hooks ...)"), so it is not touched.
  - "Every `CLAUDE.md` change -> `write-prompt` pass first."
  - "A change to always-on behavior ... gets an A/B test before merging". A per-turn rule is always-on.
    A/B plan (steps in order): review the wording (`code-review-and-quality`), run
    `test-rule-change.py` (principle test on 2-3 cases, with cost estimate), record measure, result and
    cost in the commit message and the `PROVENANCE.md` row. The owner may waive; record the waiver.
  - `PROVENANCE.md`: "add or update its row in the next commit of the same PR (a commit cannot cite its
    own hash)".
  - Hook script: the repo's own pattern is a header comment plus a `test-*.sh` next to it
    (`check-skills.sh` / `test-check-skills.sh`; "run it after any change here"). The `write-hook`
    skill (listed in `README.md`) covers hook authoring and the "output never reaches the model"
    failure class. Both should be used.
  - CLAUDE.md `Claude Code`: "Editing a repository's files its `CONTRIBUTING.md` governs ... -> read
    that `CONTRIBUTING.md` first" (done for this note).

## Design sketch (untested)

None of the following has been run. Treat names, paths and wording as proposals.

### `.claude/settings.json` (addition)

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/idle-handoff.sh",
            "timeout": 5
          }
        ]
      }
    ]
  }
}
```

`UserPromptSubmit` takes no matcher [H12], so every prompt runs the script; the script decides.

### `.claude/hooks/idle-handoff.sh` (outline, untested)

```bash
#!/bin/bash
# UserPromptSubmit hook (cloud sessions only) + `check` helper for the wake turn.
# Prints a reminder on stdout; Claude Code injects it as a system reminder.
set -uo pipefail
STATE="${TMPDIR:-/tmp}/idle-handoff"
DELAY=50                                # minutes
IDLE_SECONDS=$((45 * 60))               # tolerance below the delay

if [ "${1:-}" = check ]; then           # wake turn: bash idle-handoff.sh check <armed-epoch>
  sid=$(cat "$STATE/current-session" 2>/dev/null)
  last=$(cat "$STATE/$sid.last" 2>/dev/null || echo 0)   # missing file = unknown -> IDLE
  [ -f "$STATE/$sid.done" ] && { echo STALE; exit 0; }
  if [ $(( $(date +%s) - last )) -ge "$IDLE_SECONDS" ]; then echo IDLE; else echo STALE; fi
  exit 0
fi

[ "${CLAUDE_CODE_REMOTE:-}" = "true" ] || exit 0         # local CLI: silent
input=$(cat)
prompt=$(jq -r '.prompt // ""' <<<"$input" 2>/dev/null) || exit 0
sid=$(jq -r '.session_id // ""' <<<"$input" 2>/dev/null)
case "$prompt" in "[idle-handoff]"*) exit 0 ;; esac     # wake turn: silent, no re-arm

mkdir -p "$STATE"
echo "$sid" >"$STATE/current-session"
date +%s >"$STATE/$sid.last"
rm -f "$STATE/$sid.done"
armed=$(date +%s)
prev=$(cat "$STATE/$sid.trigger" 2>/dev/null)             # trigger_id written by Claude, may be empty

cat <<EOF
Idle-handoff timer (CLAUDE.md, Claude Code, "Idle handoff"). This cloud session keeps one pending
timer message that fires $DELAY minutes after the last user message. Pending trigger_id: ${prev:-none}.
For this turn the rule is: as the last tool calls before the final answer, call delete_trigger with
that trigger_id (skip if none), then send_later with delay_minutes=$DELAY and the message
"[idle-handoff] The idle timer armed at $armed has fired. Project rule \"Idle handoff\" applies: run
\`bash .claude/hooks/idle-handoff.sh check $armed\`; on STALE write nothing and stop; on IDLE use the
handoff skill, commit and push. This message is a timer, not a user message: no timer is created,
moved or deleted on this turn.", then store the returned trigger_id in $STATE/$sid.trigger.
EOF
```

Notes on the sketch: (a) it keeps the trigger id in a file so compaction cannot lose it (the
alternative, `list_triggers`, returned about 20 KB for 20 rows [O3] and has no name filter); (b) the
`.done` flag is written by Claude after the handoff (one more `Bash` call); (c) the `current-session`
file is a shortcut because `check` runs from Bash without the hook's stdin, where `CLAUDE_CODE_REMOTE_SESSION_ID`
(documented [E1]) would be a better key: replace it if the smoke test shows the variable in Bash;
(d) if the VM is reclaimed, `/tmp` is empty: the missing `.last` reads as 0, so `check` says IDLE, which is
the right call for a reclaimed (hence idle) session.

### Variant: one reusable trigger with `update_trigger`

Replace "delete then send_later" by: first turn `create_trigger`/`send_later` once and store the id; every
later user turn `update_trigger(trigger_id, run_once_at=<now+50min>, enabled=true)`. One call per turn,
one list row per session. `update_trigger` description [T3]: "`run_once_at` ... Setting this clears
cron_expression (and any ended_reason)". Whether it re-enables a trigger that already fired is
unverified (gate 4 below).

### `CLAUDE.md` rule (draft, `Claude Code` section, for the `write-prompt` pass)

```markdown
- Cloud session (`CLAUDE_CODE_REMOTE=true`), turn started by a user message, reminder `Idle-handoff timer` in context -> as the last tool calls before the final answer, `delete_trigger` the pending trigger, then `send_later` in 50 minutes with the reminder's message.
- Message starting `[idle-handoff]` -> run the check it names; `IDLE` -> `handoff`, commit, push. Create, move or delete no trigger on that turn.
```

Counted: 2 rules, 3 triggers. The first line alone makes the rule inert in a consumer without the hook
(no reminder in context). Not cross-checked with `prevent-drift` yet (the 50-minute value and the marker
would live in three places: script, rule, message).

## Test plan

Run in a scratch cloud session on a throwaway branch, with `DELAY=2` and `IDLE_SECONDS=90` (env
overrides in the script). Enable debug logging [H13] so every hook run appears in the log. Never test on
a consumer repo first.

| # | Case | Steps | Pass criterion |
|---|---|---|---|
| 1 | Cloud, typed prompt | Send a prompt; read the debug log and the next turn | Hook ran; reminder visible to Claude as a system reminder (Claude names the rule); Claude calls `send_later` as its last tool call; `list_triggers` shows one pending trigger for this session; state files written |
| 2 | Cloud, wake turn | Send no message for 3 minutes (let the VM pause: "a few minutes" [C2]) | The message arrives; hook either does not fire or fires silently (log shows exit with no stdout); Claude runs `check`, gets IDLE, writes the handoff, commits, pushes; **no new trigger created** (`list_triggers` count unchanged) |
| 3 | Cloud, wake after a real pause | Same as 2, but wait 15 minutes and, if possible, until the session's VM is paused or reclaimed | Message delivered into the paused or reclaimed VM, the session resumes, `check` returns IDLE; this is the gate for Q4 "survives pause / reclaim" |
| 4 | Cloud, forgotten re-arm / early wake | Type a prompt at minute 1, tell Claude to skip arming for it; let the earlier trigger fire at minute 2 | `check` returns STALE; no handoff, no commit |
| 5 | Cloud, PR wake interplay | Subscribe to a draft PR, let CI wake the session | Hook is silent or does not re-arm; no idle trigger moved by the PR turn; log shows what stdin `.prompt` held |
| 6 | Local CLI | Run the same repo locally, send a prompt | Script exits with no stdout (`CLAUDE_CODE_REMOTE` unset); no reminder in context |
| 7 | Consumer repo | Copy `templates/settings.json` entry and script into a scratch consumer; start a session | Rule arrives via sync, hook arrives only after the manual copy; without the copy, no reminder and no arming |
| 8 | Update variant | `update_trigger` a fired one-shot | Trigger becomes enabled again and fires; otherwise fall back to delete + create |

Record in the log, per case: stdin JSON of the hook (to settle whether any `origin` field exists), the
`prompt` text on wake turns, and `list_triggers` output (with `include_completed`).

## Open questions / unverified

Each is a hypothesis or "no source found". Gates for the build decision are marked (G).

1. (G) Whether a `send_later` wake fires `UserPromptSubmit` and `Stop`; what `.prompt` holds on a wake
   turn. Docs list other wake types only [H2].
2. (G) Whether a server-side `send_later` message resumes a paused or reclaimed cloud VM and reaches the
   model. Only the tool description and delivery-status rows support it [T1, O3].
3. (G) Model compliance: whether Claude arms and cancels on every user turn, as the last tool calls, in
   long sessions and after compaction. No measurement exists. The reminder is re-injected each turn
   [H4], which helps, but nothing enforces it.
4. (G) Whether `update_trigger` re-enables a fired one-shot (variant).
5. Whether the hook process sees `CLAUDE_CODE_REMOTE` (docs say yes [H1, E1]; observed only in a Bash
   tool environment [O1]; not tested in a hook).
6. Whether the transcript `origin` / `promptSource` / `turnOrigin` fields are stable, and whether the
   transcript has the current record when the hook runs [H6].
7. Maximum number of active triggers, creation rate limits, whether `send_later` counts toward the 100
   scheduled runs per hour [S2], and what `auto_disabled_session_gone` means (6 of 18 observed
   one-shots): no source found.
8. Whether a deleted trigger leaves a row visible to `list_triggers`.
9. Whether `UserPromptSubmit` hooks from repo settings run in a cloud session that is part of a project
   or has several repositories: docs say not [C5]; the montage would silently do nothing there.
10. Token cost of the reminder per turn (about 150 tokens is an estimate) and wall-clock cost of two extra
    tool calls per turn: not measured.
11. Whether the PR-subscription prompt's 50-minute check-ins [O4] and this idle timer double-arm in a
    session that has both, and who wins the rule conflict.
12. The third-party snippet claims in Q1 (task-notifications vs `UserPromptSubmit`) come from search
    result summaries; the pages were not opened (`claudeissues.com` is outside the session's allowed
    network). #39027 was read through a fetched summary.
13. The data in [O3] is this account's trigger history (first page of 20 rows); it shows delivery
    statuses, not that the model acted on the message.

## Sources

Docs fetched 2026-11-23 as `<url>.md` (changelog top entry 2.1.330).

- [H1] https://code.claude.com/docs/en/hooks, "Hook handlers" (paragraph beginning "The `$CLAUDE_CODE_REMOTE`
  environment variable is `"true"` ...")
- [H2] same, "UserPromptSubmit" (list of what also fires it; timeout paragraphs)
- [H3] same, "Exit code 0" ("On these events, your plain-text stdout reaches Claude ...")
- [H4] same, "UserPromptSubmit decision control" ("Neither channel produces a visible transcript entry ...")
- [H5] same, "Output caps" (10,000 characters) and "Add context for Claude"
- [H6] same, "Common input fields" and "UserPromptSubmit input"
- [H7] same, hook lifecycle table (`UserPromptSubmit` row)
- [H8] same, "Command hook fields" (`asyncRewake` row)
- [H9] same, "Add context for Claude" (system reminder, factual-statement caveat, replay on resume)
- [H10] same, "Exit code output" / non-blocking errors
- [H11] same, "Stop"
- [H12] same, matcher table (`UserPromptSubmit`: "no matcher support")
- [H13] same, "Debug hooks"
- [E1] https://code.claude.com/docs/en/env-vars, rows `CLAUDE_CODE_REMOTE`, `CLAUDE_CODE_REMOTE_SESSION_ID`
- [E2] https://code.claude.com/docs/en/settings-reference ("Identity variables that Claude Code's hosting
  environments own ... are ignored from every file")
- [C1] https://code.claude.com/docs/en/claude-code-on-the-web, "Environment expired"
- [C2] https://code.claude.com/docs/en/cloud-environments, "Set environment variables" (restore after idle)
- [C3] https://code.claude.com/docs/en/claude-code-on-the-web, "Send follow-ups from the CLI" (`--cloud`
  errors: "the session is missing or archived")
- [C5] https://code.claude.com/docs/en/cloud-environments, "What carries over from your setup" ("Yes, in a
  session with one repository")
- [C6] same page, "Install dependencies with a SessionStart hook" and "No cloud-only scoping"
- [C7] https://code.claude.com/docs/en/claude-code-on-the-web, troubleshooting table ("cloud session <id> is
  archived and cannot accept new messages")
- [C8] same page, "Auto-fix pull requests"
- [S2] https://code.claude.com/docs/en/routines, "Usage and limits" (hourly limits table)
- [G1] https://github.com/anthropics/claude-code/issues/39027 (closed as not planned 2026-06-16, locked
  2026-08-18; read through a fetched summary; quotes the transcript field `"origin": {"kind":
  "task-notification"}`)
- [T1] `send_later` tool description, this session (not public docs)
- [T2] `create_trigger` tool description, this session
- [T3] `update_trigger` tool description, this session
- [T4] `list_triggers` tool description, this session
- [T5] `delete_trigger` tool description, this session
- [O1] `env` of this session's Bash tool, 2026-11-23: `CLAUDE_CODE_REMOTE=true`,
  `CLAUDE_CODE_ENTRYPOINT=remote_mobile`, `CLAUDE_CODE_REMOTE_ENVIRONMENT_TYPE=cloud_default`
- [O2] This session's transcript (`transcript_path` file): user records with `origin.kind`, `promptSource`,
  `turnOrigin`, `turnPosition` (observed, undocumented)
- [O3] `list_triggers` (read-only call, `include_completed: true`, `limit: 20`), 2026-11-23: fields
  `run_once_at`, `last_fired_at`, `ended_reason`, `last_run.status`, `persistent_session_id`,
  `created_kind`, `created_via`. Counts: 12 `run_once_fired` with `SUCCEEDED`, 6
  `auto_disabled_session_gone` with `FAILED`, 1 pending, 1 recurring routine. Trigger ids and
  prompts deliberately not reproduced here
- [O4] This session's GitHub PR-subscription wake message (stored in the transcript as a queued event):
  "If you have the `send_later` tool, keep one safety-net check-in ... about 50 minutes after the last
  activity ... re-arm. Stop after 3 empty check-ins in a row ..."
- [R1] `/home/user/Claude/README.md` ("Adding this repo to another project"; "are the whole consumer-side
  infra")
- [R2] `/home/user/Claude/templates/hooks/session-start.sh`, `/home/user/Claude/templates/hooks/install-skills.sh`,
  `/home/user/Claude/templates/settings.json`
- [R3] `/home/user/Claude/.claude/settings.json`, `/home/user/Claude/.claude/hooks/check-skills.sh`,
  `/home/user/Claude/CONTRIBUTING.md`, `/home/user/Claude/CLAUDE.md`, `/home/user/Claude/CLAUDE.web.md`
- [R4] `/home/user/Claude/.gitignore`
- Prior note: `/home/user/Claude/docs/research/2026-11-23-idle-handoff.md`

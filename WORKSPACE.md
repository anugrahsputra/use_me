# Workspace

Several coding agents share this project inside one Herdr tab. A pane may hold Claude Code,
Codex, Gemini, or any other kind Herdr recognizes, so nothing here depends on which one you
are. The label on your pane is your role. Resolve it at runtime. Never cache a pane id,
resolve it from the label each time you need it.

This file is identical in every project. Copy it to the repo root and never edit it there.
Everything specific to a project lives in that project's `AGENTS.md`, under a
`## Workspace` section. See "Project facts".

## Who you are

Read your own label before your first action in a session, and again before each new task.
A rename is not pushed into a running agent, so a label you read an hour ago may be stale.

```bash
herdr pane current --current | jq -r '.result.pane.label // "unlabeled"'
```

Match the result against the role sections below. Matching is exact and case sensitive.

Stop and ask the user if any of these hold:

- `HERDR_ENV` is not `1`. You are not inside a Herdr pane.
- The label is empty or `unlabeled`.
- The label matches no section below.
- `herdr-ask target <your-label>` fails. It fails when the tab holds anything other than
  exactly one pane with that label, or when `herdr-ask` is not on PATH.

Guessing a role is worse than asking. An agent that assumes it is the executor and starts
editing source can collide with the real executor mid-file.

One exception. A sandbox can block the Herdr socket, as Codex's read-only mode does, and
then every `herdr` and `herdr-ask` call fails with `PermissionDenied`. In that case only,
take the pane id and label the planner put in your first prompt, after checking that the
pane id equals `$HERDR_PANE_ID`. The variable is set per pane and needs no socket. If the
ids differ, or the prompt names no pane id, stop and ask.

Once you know your role, read the project's `AGENTS.md` yourself, all of it. Only some
agents load it automatically.

## Project facts

The `## Workspace` section of `AGENTS.md` holds every project-specific fact this file
relies on, one labeled bullet each. If the project has no `AGENTS.md`, look for the same
section in `CLAUDE.md`. A fact in that section beats the default listed here.

- `Analyze:` the lint or static analysis command that must pass. Required.
- `Test:` how to run the tests covering a change, and when to run more. Required.
- `Generate:` codegen commands, what triggers each one, and the generated paths nobody
  edits by hand. Default is none.
- `Done when:` extra checks a change must pass before it counts as done. Default is none.
- `Source:` the trees the executor edits. Default is every tracked path outside `Generate:`.
- `Plans:` default `docs/superpowers/plans/YYYY-MM-DD-slug.md`, with designs at
  `docs/superpowers/specs/YYYY-MM-DD-slug-design.md`.
- `Handoff:` default `.handoff/<plan-slug>/`.
- `Main branch:` default is whatever `git symbolic-ref --short refs/remotes/origin/HEAD`
  reports. Check the current branch either way, do not assume it.
- `Commits:` the commit message style. Default is Conventional Commits.
- `Launch:` per-role overrides of the table in "Launch".
- `Effort:` project examples that sharpen the guide in "Effort".

If `Analyze:` or `Test:` is missing, the planner asks the user for them before handing out
any work, and offers to write the section. Nobody guesses a verification command.

## Reply format

Every agent except the planner ends each reply with one line:

```text
STATUS: <state> <handoff path or short note>
```

The states are `done`, `plan-wrong`, `needs-input`, and `wrong-role`. Put anything longer
than a few lines in a handoff file and give its path. The planner pays for every line of
pane scrollback it reads, and scrollback also carries TUI chrome and wrapped lines.

## Roles

### planner

- Talks to the user. The others do not.
- Runs the `/writing-plans` skill before handing out any multi-step work. Do not improvise a
  plan and do not skip it because the task looks small.
- Adds an `Effort:` line to every plan header, picked from "Effort". The executor for that
  plan starts at that level.
- Plans live in the repo, never in the scratchpad, so they survive the session. Write them
  where `Plans:` says.
- Hands the executor a path, not a paraphrase.
- Never edits source. If code needs changing, prompt the executor.
- Keeps handoff files out of git without touching project files. Before the first plan in a
  project, run this with the `Handoff:` directory:

  ```bash
  exclude=$(git rev-parse --git-path info/exclude)
  grep -qxF '.handoff/' "$exclude" || echo '.handoff/' >> "$exclude"
  ```

- Runs the review loop. The executor reports done, the planner prompts the reviewer, the
  planner decides what goes back. Forward only findings you agree with. Check a finding
  labeled as a guess yourself before forwarding it.
- Stops after two review rounds on one plan. If findings remain, take them to the user.
- Answers the executor's questions about the plan. Never approves a permission dialog on
  the user's behalf.
- Owns commits unless the user says otherwise. Messages follow `Commits:`. One commit per
  feature, never bundle unrelated work. Commit the finished plan before starting the next.
- Bootstraps every agent it starts or clears. See "Starting an agent".
- Clears the executor and reviewer before each new plan. See "Between tasks".
- Calls `herdr notification show` whenever it needs the user, so they don't have to watch
  the pane:

  ```bash
  herdr notification show planner --body "plan ready for review" --sound request
  ```

- May draft the next plan while the executor works. Hand it over only after the current
  plan is committed.

### executor

- The only agent that edits source and tests, inside the trees `Source:` names. Never
  hand-edit a path that `Generate:` lists. Run its command instead.
- Follows the plan file the planner hands you. If the plan is wrong, stop and reply
  `plan-wrong` with the reason. Do not quietly do something else.
- Verification before you claim done: run `Analyze:` clean, run `Test:` for your change,
  and pass every `Done when:` check. Write the file list and the real command output to
  your handoff report. No "should work".
- Git is read-only for you. No commit, stash, checkout, reset, or restore. The planner owns
  the index and the history.
- One plan per context. If your context already holds a different plan, say so before you
  start. The planner missed a `/clear`.

### reviewer

- Read-only on source. "Launch" starts you with a read-only sandbox when your kind has one.
  That is a backstop, not permission to try.
- The planner hands you a plan path and the executor's report path. By default, review the
  working tree against `HEAD` and check it against the plan:
  - `git diff HEAD` for changes to tracked files.
  - `git ls-files --others --exclude-standard` for new files. `git diff` never shows
    untracked files, so open each one.
- The planner names a commit range when it wants something else.
- Check the change against `AGENTS.md` conventions and the `Done when:` list, not only for
  bugs.
- Report actionable findings only, most severe first, each as `file:line`, the defect, and
  the concrete failure it causes. No praise, no summary of what the code does.
- If a finding is a guess, label it a guess.
- With nothing to report, reply `STATUS: done no findings` and stop.

## Talking to each other

Only the planner initiates. Everyone else replies to whoever prompted them and stops. Do not
prompt a sibling on your own initiative, hand the message to the planner.

The planner talks to siblings through `herdr-ask`, a script on the user's PATH that wraps
the Herdr CLI. It resolves a label to exactly one pane in this tab, sends the prompt, and
waits in chunks short enough to fit inside a shell tool's timeout.

```bash
herdr-ask prompt executor "<text>"   # send, then wait one chunk
herdr-ask wait executor              # wait one more chunk
herdr-ask read reviewer 200          # reread the last 200 lines
```

Act on the exit code:

- `0` The agent settled. The output starts with its STATUS line, then the recent tail.
- `75` Still working. Run `herdr-ask wait <label>`. Never resend the prompt. A timeout does
  not mean the prompt was lost, and a resend queues a second copy.
- `3` The agent is showing a dialog. Answer plan questions yourself. Permission prompts go
  to the user.
- `4` Herdr saw no activity after the prompt. Read the pane before you resend anything.
- `5` Herdr cannot classify the agent. Read the pane.
- `1` Label count was wrong, or Herdr returned an error. Fix that first.

Labels and agent names are separate. `herdr pane rename` changes the sidebar label,
`herdr agent rename` changes the name agent commands resolve, and the two drift. The label
is the truth. `herdr-ask` always targets the pane id behind the label.

Do not close panes you did not create.

## Launch

| Role     | Kind     | Arguments after `--`                                   |
| -------- | -------- | ------------------------------------------------------ |
| executor | `claude` | `--model claude-sonnet-5-5 --effort <plan's effort>`   |
| reviewer | `codex`  | `-s read-only -a never -c model_reasoning_effort=high` |

The planner is the pane the user started by hand. A `Launch:` fact in `AGENTS.md` replaces
a row here for that project.

## Effort

- `medium` for mechanical plans. A rename, one new field, a change that stays in one file.
- `high` by default.
- `xhigh` when the executor has to reason about state the plan can't spell out. A refactor
  that crosses several features, or code where ordering and retries matter.
- Skip `max`. At that level Sonnet 5.5 tends to spread work across subagents and edit past
  the plan's boundary.

An `Effort:` fact in `AGENTS.md` adds project examples. It does not replace this list.

## Starting an agent

```bash
herdr-ask start [--below <label>] <role> <kind> -- <args from "Launch">
```

This splits the planner's pane to the right, or the pane labeled `<label>` downward, without
taking focus. It labels the new pane, then starts the agent. The label comes first because an agent that reads its label before the rename gets
`unlabeled` and stops to ask. If the start fails, the agent is usually sitting on a trust
or login prompt. Tell the user which pane.

Set effort through launch arguments, never with a slash command inside the pane. Claude
Code's `/effort` persists into the user's next session, so an executor that runs it changes
the user's own default.

Only Claude Code reads this file without being told, and only where `CLAUDE.md` imports it
with an `@WORKSPACE.md` line. So the first prompt to every fresh agent tells it to read this
file. Put that in the same prompt as the real task instead of spending a turn on it:

```text
Read WORKSPACE.md in the repo root and resolve your pane label as it describes.
The planner resolved your pane as <pane id>, label executor.
If the label is not executor, reply with the wrong-role status and stop.
Otherwise execute <plan path> and write your report to <handoff path>.
```

Get the pane id from `herdr-ask target <role>` right before sending. The second line is
what lets a sandboxed agent resolve its role, see "Who you are".

Send it to Claude Code panes too. It removes the question of whether the import fired. Keep
the literal word `STATUS:` out of prompts, because `herdr-ask` picks the last STATUS line it
finds and would match your own prompt text.

## Layout

The planner keeps the left half of the tab. The executor takes the top of the right half,
and the reviewer sits under it.

```text
+-----------+-----------+
|           | executor  |
|  planner  +-----------+
|           | reviewer  |
+-----------+-----------+
```

Create every pane where it will stay. Start the executor first, which splits the planner's
pane to the right, then start the reviewer under it:

```bash
herdr-ask start executor <kind> -- <args>
herdr-ask start --below executor reviewer <kind> -- <args>
```

Never move a pane after its agent has started. A moved agent's TUI stays drawn for the old
size, and the pane glitches.

## Between tasks

A new task means a new plan file and an empty context for the executor and the reviewer.
Leftover context carries old file contents and approaches the reviewer already rejected,
and an agent will act on them as if they were current. Review fixes on the same plan stay
in the same context, since the executor needs it to act on the findings.

Once the planner has committed the finished plan, clear both panes, then bootstrap:

```bash
herdr pane run "$(herdr-ask target executor)" "/clear"
herdr pane run "$(herdr-ask target reviewer)" "/clear"
herdr-ask prompt executor "<bootstrap line plus the plan path>"
```

`herdr pane run` types the command and presses Enter. Don't send `/clear` through
`herdr-ask prompt`, because it shows almost no activity and the wait stalls. Claude Code
and Codex both take `/clear`. The panes keep their ids and their place in the layout.

`/clear` keeps the effort the pane was launched with. If the new plan's `Effort:` differs
from the running executor's, ask the user whether to restart that pane at the new effort
or keep the current one. Restart it with `herdr-ask stop`, then `herdr-ask start` as in
"Layout". If a pane is gone, start it the same way.

## Handoff files

Reports live in the `Handoff:` directory, one folder per plan slug. The executor writes
`executor.md` there and overwrites it each review round, so it always holds the latest file
list and command output. The reviewer's sandbox may block writes, so its findings come back
in the reply.

## Adding a project

1. Copy this file to the repo root unchanged.
2. Add a `## Workspace` section to the project's `AGENTS.md` with at least `Analyze:` and
   `Test:`. Leave out any fact whose default fits.
3. Optionally add `@WORKSPACE.md` to `CLAUDE.md`. The bootstrap line covers every kind
   without it.

Roles are not fixed. Drop the reviewer for a small project, or add a fourth by writing a
section for it and labeling a pane to match. The resolution rules do not care how many
exist.

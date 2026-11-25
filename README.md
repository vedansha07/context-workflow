# context-workflow

A plan-first workflow for Claude Code. Every project gets a `context/` folder that holds the plan you approve before any work starts, the decisions Claude makes on its own, a daily log, and the rules Claude re-reads after every reset or compaction.

## Why

- Claude starts building before you've agreed on what to build.
- In auto mode, Claude makes choices you never hear about.
- After a compaction or a new session, the reasoning behind the work is gone.

This plugin makes Claude write a plan and wait for your approval, log the decisions it makes by itself, and pick the rules back up automatically after every reset.

## What you get

```
context/                    # git-ignored by default
  howwework.md              # the rules; re-read after every reset or compaction
  <topic>_plan.md           # one per topic, with Status: Draft / Approved / In progress / Done
  <topic>_decisions.md      # important decisions Claude made on its own (agreed ones stay in the plan)
  daily.md                  # one entry per working day
```

- **Plan gate.** For each new topic, Claude writes `context/<topic>_plan.md` and stops. You edit it or ask for changes. Nothing gets built until you approve.
- **Decision log.** Decisions you agree on live in the plan. The decisions file holds only the ones Claude made itself while working, with what it chose, why, and what it rejected.
- **Daily log on a cheap model.** A `daily-logger` subagent (Haiku) writes `daily.md`, so the log never fills your main session's context.
- **Survives compaction.** A `SessionStart` hook adds `context/howwework.md` to Claude's context on every startup, resume, `/clear` and compaction. In projects without that file it prints nothing.

## Install

As a plugin (recommended, includes the hook and the logger):

```
/plugin marketplace add vedansha07/context-workflow
/plugin install context-workflow@context-workflow
```

As a standalone skill (no hook; the `CLAUDE.md` line that setup adds covers compaction instead):

```sh
git clone https://github.com/vedansha07/context-workflow
cp -R context-workflow/skills/context-workflow ~/.claude/skills/
cp context-workflow/agents/daily-logger.md ~/.claude/agents/
```

## Use

In a project, say "set up the context workflow", or run `/context-workflow:context-workflow` (`/context-workflow` for the standalone skill). Setup does four things:

1. Creates `context/` with `howwework.md` and `daily.md`.
2. Adds `context/` to `.gitignore`.
3. Adds one line to `CLAUDE.md` telling Claude to read `context/howwework.md` first.
4. Then plans whatever you asked for and waits for you.

After that, just describe what you want to work on. Claude writes the plan and waits for your approval.

To change the rules for a project, edit `context/howwework.md`.

## Working in a team

`context/` is git-ignored so your notes stay private by default. To share plans and decisions with a team, delete the `context/` line from `.gitignore` and commit the folder.

## Limits

- These are instructions, not enforcement. Claude follows them well, but it can still skip a step, especially if you tell it to.
- In a project with `context/`, the hook adds about 600 tokens at every session start, resume and compaction. Elsewhere the plugin costs about 180 tokens per session for its skill and agent descriptions.
- The daily log is only as good as the summary Claude hands the logger.
- An ignored `context/` folder exists only on your machine.

## Layout

```
.claude-plugin/plugin.json        # plugin manifest
.claude-plugin/marketplace.json   # makes this repo installable as a marketplace
skills/context-workflow/          # SKILL.md and the context/ templates
agents/daily-logger.md            # Haiku subagent that writes daily.md
hooks/hooks.json                  # SessionStart hook
hooks/session-start.sh            # re-injects context/howwework.md
```

To work on it, run `claude plugin validate .` and test with `claude --plugin-dir .`.

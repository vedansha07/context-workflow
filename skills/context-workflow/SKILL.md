---
name: context-workflow
description: Plan-first project workflow built on a git-ignored context/ folder (topic plans the user approves before any work, a log of decisions Claude makes on its own, a daily log, and howwework.md, which is re-read after every reset or compaction). Use when the user asks to set up the context folder or this workflow, starts a new project and wants to plan before building, or asks where things stand in a project that has a context/ folder.
---

# Context workflow

A project's working memory lives in `context/` at the project root:

| File | Holds | Written |
|---|---|---|
| `howwework.md` | The rules. Read first after every reset, resume or compaction. | At setup; the user edits it |
| `<topic>_plan.md` | The plan for one topic, with a `Status:` line. The user approves it before any work. | Before work on the topic starts |
| `<topic>_decisions.md` | Important decisions Claude made on its own while executing the plan, including in auto mode. Decisions agreed with the user stay in the plan. | During the work |
| `daily.md` | One dated entry per working day. | By the `daily-logger` agent, on a cheap model |

## Pick the mode

- `context/howwework.md` exists: **re-orient**. Don't set anything up.
- It doesn't exist and the user asked for this workflow: **set up**.
- It doesn't exist and you loaded this skill on your own: ask one line first ("Set up a context/ folder for plan-first work here?") and set up only on a yes.

## Set up

1. Find the project root: the git root if there is one (`git rev-parse --show-toplevel`), otherwise the current directory.
2. Create `context/`. Copy `templates/howwework.md` and `templates/daily.md` from this skill's directory into it. Never overwrite a file that already exists.
3. Make git ignore the folder: if `git check-ignore -q context/` fails, append `context/` to `.gitignore`, creating the file if needed.
4. Make the rules survive compaction even without this plugin's hook: if `CLAUDE.md` at the root doesn't already mention `context/howwework.md`, append this line, creating the file if needed:
   `If context/howwework.md exists, read it before doing anything else, including after a reset or compaction.`
5. Tell the user in a few lines what you created, and that deleting the `context/` line from `.gitignore` lets a team commit and share the folder.

If the user has already said what they want to work on, start a topic for it.

## Start a topic

1. Pick a short kebab-case topic name, such as `auth-refresh`.
2. Copy `templates/plan.md` to `context/<topic>_plan.md` and fill it in. Put real choices that belong to the user under "Open questions" instead of making them yourself.
3. Stop. Point the user to the file and ask them to review, edit or approve it. Don't write code, change config or run anything with side effects until they approve.
4. On approval, set `Status: Approved`, and `Status: In progress` once you start. Move the user's answers from "Open questions" to "Decisions".
5. The first time you make an important decision yourself, create `context/<topic>_decisions.md` from `templates/decisions.md`.

From here on, follow the rules in `context/howwework.md`.

## Re-orient

Read `context/howwework.md`, every plan in `context/` whose `Status:` isn't `Done`, and the last entry in `context/daily.md`. Then tell the user in two or three lines where things stand and what comes next.

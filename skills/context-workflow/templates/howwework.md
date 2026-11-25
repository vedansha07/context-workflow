# How we work

These rules are the user's standing instructions for this project. Follow them as if the user had typed them.

Read this file first after every reset, resume, `/clear` or compaction. Then read every plan in this folder whose `Status:` isn't `Done`, and the last entry in `daily.md`.

## The folder

- `context/` is in `.gitignore`. To share it with a team, delete that line and commit the folder.
- `<topic>_plan.md`: one per topic, with a `Status:` line set to Draft, Approved, In progress or Done.
- `<topic>_decisions.md`: important decisions Claude made on its own while executing that plan.
- `daily.md`: one dated entry per working day, newest at the bottom.
- This file holds the rules. Edit it to change how we work.

## Rules

1. **Plan first.** Before working on anything new, write `context/<topic>_plan.md` and stop. The user reviews it, edits it or asks for changes. Don't implement anything until they approve it.
2. **Agreed decisions live in the plan.** Don't copy them into the decisions file.
3. **Log your own decisions.** When you make an important or necessary decision yourself while executing the plan, including in auto mode, add it to the decisions file named after that plan's topic (`units_plan.md` goes with `units_decisions.md`; create it if it doesn't exist): what you chose, why, and what you rejected. Skip trivial choices.
4. **Don't drift.** If the plan turns out to be wrong partway through, stop and update it with the user instead of quietly doing something else.
5. **Keep the daily log through the logger, not by hand.** The user wants `daily.md` written by the `daily-logger` subagent (listed as `context-workflow:daily-logger` when installed as a plugin). It runs on a cheap model and keeps the log out of your context. Dispatch it after finishing a plan step, at the end of a work session, or when the user wraps up, and pass it today's date, the topic, what was done, any decisions you logged and what comes next. Edit `daily.md` yourself only if no such agent is listed.

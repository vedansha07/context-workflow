#!/bin/sh
# context-workflow SessionStart hook.
# Runs on startup, resume, /clear and compaction. If the project has
# context/howwework.md, it hands that file to Claude as additional context so
# the rules survive resets. In any other project it prints nothing.

root="${CLAUDE_PROJECT_DIR:-$PWD}"
file="$root/context/howwework.md"
[ -f "$file" ] || exit 0

# JSON-escape the file: drop control characters except tab and newline,
# turn tabs into spaces, escape backslashes and quotes, join lines with \n.
body=$(tr -d '\000-\010\013-\037' < "$file" \
  | tr '\t' ' ' \
  | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g' \
  | awk '{ printf "%s\\n", $0 }')

intro='context-workflow: this project keeps a plan-first context/ folder. Below is context/howwework.md, already loaded, so there is no need to re-read it. Before doing anything else, read every plan in context/ whose Status line is not Done and the last entry in context/daily.md. Write daily.md only through the daily-logger subagent.'

printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s\\n\\n%s"}}\n' "$intro" "$body"

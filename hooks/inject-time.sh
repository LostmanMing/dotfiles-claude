#!/usr/bin/bash
set -euo pipefail

# Inject current time into Claude's context before each prompt
# Fires on: UserPromptSubmit

TIME=$(date '+%Y-%m-%d %H:%M:%S %A')
echo "$(date '+%H:%M:%S') inject-time: fired" >> /tmp/claude-hooks.log
cat <<EOF
{
  "hookSpecificOutput": {
    "hookEventName": "UserPromptSubmit",
    "additionalContext": "Current time: ${TIME}"
  }
}
EOF

#!/usr/bin/bash

# Inject current git status into Claude's context before each prompt
# Fires on: UserPromptSubmit

# Only run inside a git repo
git rev-parse --is-inside-work-tree &>/dev/null || exit 0

MAX_LINES=20
STATUS=$(git -c color.status=false status -sb 2>/dev/null || true)
TOTAL=$(echo "$STATUS" | wc -l | tr -d ' ')

if [ "$TOTAL" -gt "$MAX_LINES" ]; then
  REMAINING=$((TOTAL - MAX_LINES))
  STATUS=$(echo "$STATUS" | head -n "$MAX_LINES")
  STATUS="${STATUS}\n... (showing first ${MAX_LINES} of ${TOTAL} lines, ${REMAINING} more)"
fi

# Dedup with a temp file keyed by working directory
CACHE_FILE="/tmp/claude-git-status-$(echo "$PWD" | md5 -q 2>/dev/null || echo "$PWD" | md5sum | cut -d' ' -f1)"
PREV=$(cat "$CACHE_FILE" 2>/dev/null || true)
if [ "$PREV" = "$STATUS" ]; then
  exit 0
fi
echo "$STATUS" > "$CACHE_FILE"
echo "$(date '+%H:%M:%S') inject-git-status: fired (${TOTAL} lines)" >> /tmp/claude-hooks.log
printf '{"hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"Git status:\\n%s"}}\n' "$STATUS"

#!/usr/bin/env bash
# Sends a scheduled task message to the Arthur Claude Code session.
# Usage: run-scheduled.sh <task-name>
#   e.g. run-scheduled.sh morning-briefing
set -euo pipefail

# Ensure Homebrew binaries are available (cron runs with minimal PATH)
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TASK_FILE="${SCRIPT_DIR}/schedules/${1}.md"

if [[ ! -f "$TASK_FILE" ]]; then
  echo "Error: schedule file not found: $TASK_FILE" >&2
  exit 1
fi

if ! tmux has-session -t arthur 2>/dev/null; then
  echo "Error: Arthur tmux session not running" >&2
  exit 1
fi

tmux send-keys -t arthur "$(cat "$TASK_FILE")" "" && sleep 0.3 && tmux send-keys -t arthur Enter

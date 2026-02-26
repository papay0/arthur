#!/usr/bin/env bash
# Sends a scheduled task message to the Arthur tmux session.
# Usage: run-scheduled.sh <task-name>
#   e.g. run-scheduled.sh morning-briefing
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TASK_FILE="${SCRIPT_DIR}/schedules/${1}.md"

if [ ! -f "$TASK_FILE" ]; then
  echo "No schedule file: $TASK_FILE" >&2
  exit 1
fi

if ! tmux has-session -t arthur 2>/dev/null; then
  echo "Arthur tmux session not running" >&2
  exit 1
fi

tmux send-keys -t arthur "$(cat "$TASK_FILE")" Enter

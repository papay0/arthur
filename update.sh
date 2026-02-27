#!/usr/bin/env bash
# Arthur — pull latest changes and restart.
# Run this from a regular terminal (not from within Arthur).
set -euo pipefail
cd "$(dirname "$0")"

BOLD='\033[1m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
RESET='\033[0m'
CHECK="${GREEN}✓${RESET}"
ARROW="${CYAN}→${RESET}"

SESSION_NAME="arthur"

printf "\n${MAGENTA}${BOLD}  Updating Arthur...${RESET}\n\n"

# ── Guard: don't run from inside Claude Code ─────────────────
if [ -n "${CLAUDECODE:-}" ]; then
  printf "  You're inside Claude Code. Ask Arthur to update itself instead:\n"
  printf "    \"Update yourself\"\n\n"
  exit 0
fi

# ── Stop running session ──────────────────────────────────────
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  printf "  ${ARROW} Stopping Arthur...\n"
  tmux kill-session -t "$SESSION_NAME"
  printf "  ${CHECK} Stopped\n"
fi

# ── Pull latest ───────────────────────────────────────────────
printf "  ${ARROW} Pulling latest from git...\n"
git pull
printf "  ${CHECK} Up to date\n\n"

# ── Restart ───────────────────────────────────────────────────
exec ./start.sh

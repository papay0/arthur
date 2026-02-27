#!/usr/bin/env bash
# Arthur — single entry point: installs deps if missing, then starts Claude in tmux.
set -euo pipefail
cd "$(dirname "$0")"

# ── Colors ────────────────────────────────────────────────────
BOLD='\033[1m'
DIM='\033[2m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
RESET='\033[0m'
CHECK="${GREEN}✓${RESET}"
ARROW="${CYAN}→${RESET}"
WARN="${YELLOW}!${RESET}"

SESSION_NAME="arthur"
INSTALLED_SOMETHING=false

# ── Banner ────────────────────────────────────────────────────
printf "\n"
printf "${MAGENTA}${BOLD}"
printf "    +---------------------------------------+\n"
printf "    |          *  A R T H U R  *            |\n"
printf "    |   Personal AI Assistant powered by    |\n"
printf "    |            Claude Code                |\n"
printf "    +---------------------------------------+\n"
printf "${RESET}\n"

# ── Guard: don't nest Claude Code ───────────────────────────
if [ -n "${CLAUDECODE:-}" ]; then
  printf "  ${WARN} You're already inside Claude Code.\n"
  printf "    Run ${BOLD}./start.sh${RESET} from a regular terminal to start Arthur.\n\n"
  exit 0
fi

# ── Platform detection ────────────────────────────────────────
IS_MACOS=false
if [ "$(uname)" = "Darwin" ]; then
  IS_MACOS=true
fi

# ── Preflight checks ─────────────────────────────────────────
printf "${BOLD}  Preflight ${RESET}${DIM}─── Checking requirements${RESET}\n\n"

# Homebrew — required on macOS, optional on Linux
HAS_BREW=false
if command -v brew &>/dev/null; then
  HAS_BREW=true
elif [ "$IS_MACOS" = "true" ]; then
  printf "    ${WARN} Homebrew not found. Install it first:\n"
  printf "    ${DIM}https://brew.sh${RESET}\n\n"
  exit 1
fi

# Helper: load nvm if present, then install Claude Code
_install_claude() {
  # Load nvm if available (may have just been installed)
  export NVM_DIR="$HOME/.nvm"
  # shellcheck disable=SC1091
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  printf "    ${ARROW} Installing Claude Code...\n"
  npm i -g @anthropic-ai/claude-code
  printf "    ${CHECK} Claude Code — installed\n"
  INSTALLED_SOMETHING=true
}

if ! command -v claude &>/dev/null; then
  if command -v npm &>/dev/null; then
    _install_claude
  elif [ "$IS_MACOS" = "false" ]; then
    # Linux: install Node.js via nvm (no sudo needed)
    printf "    ${ARROW} Installing Node.js via nvm...\n"
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    # shellcheck disable=SC1091
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts --no-progress
    printf "    ${CHECK} Node.js — installed\n"
    _install_claude
  else
    printf "    ${WARN} Claude Code not found. Install it first:\n"
    printf "    ${DIM}npm i -g @anthropic-ai/claude-code${RESET}\n\n"
    exit 1
  fi
else
  printf "    ${CHECK} Claude Code\n"
fi

# tmux — try brew, then apt-get
if ! command -v tmux &>/dev/null; then
  printf "    ${ARROW} Installing tmux...\n"
  if [ "$HAS_BREW" = "true" ]; then
    brew install tmux
  elif command -v apt-get &>/dev/null; then
    sudo apt-get install -y tmux
  else
    printf "    ${WARN} tmux not found. Install it manually: https://github.com/tmux/tmux\n\n"
    exit 1
  fi
  printf "    ${CHECK} tmux — installed\n"
  INSTALLED_SOMETHING=true
else
  printf "    ${CHECK} tmux\n"
fi

if [ "$IS_MACOS" = "true" ]; then
  printf "    ${CHECK} macOS\n"
else
  printf "    ${CHECK} Linux\n"
fi
[ "$HAS_BREW" = "true" ] && printf "    ${CHECK} Homebrew\n"
printf "\n"

# ── Ensure directories exist ─────────────────────────────────
mkdir -p schedules memory/daily
chmod +x run-scheduled.sh 2>/dev/null || true

# ── Install CLI tools ─────────────────────────────────────────
printf "${BOLD}  Tools ${RESET}${DIM}─── CLI tools${RESET}\n\n"

if [ "$IS_MACOS" = "true" ]; then
  # memo (Apple Notes)
  if command -v memo &>/dev/null; then
    printf "    ${CHECK} memo ${DIM}(Apple Notes)${RESET}\n"
  else
    printf "    ${ARROW} Installing memo ${DIM}(Apple Notes)${RESET}...\n"
    brew tap antoniorodr/memo && brew install antoniorodr/memo/memo
    printf "    ${CHECK} memo ${DIM}(Apple Notes)${RESET} — installed\n"
    INSTALLED_SOMETHING=true
  fi

  # remindctl (Apple Reminders)
  if command -v remindctl &>/dev/null; then
    printf "    ${CHECK} remindctl ${DIM}(Apple Reminders)${RESET}\n"
  else
    printf "    ${ARROW} Installing remindctl ${DIM}(Apple Reminders)${RESET}...\n"
    brew install steipete/tap/remindctl
    printf "    ${CHECK} remindctl ${DIM}(Apple Reminders)${RESET} — installed\n"
    INSTALLED_SOMETHING=true
  fi

  # imsg (iMessage)
  if command -v imsg &>/dev/null; then
    printf "    ${CHECK} imsg ${DIM}(iMessage)${RESET}\n"
  else
    printf "    ${ARROW} Installing imsg ${DIM}(iMessage)${RESET}...\n"
    brew install steipete/tap/imsg
    printf "    ${CHECK} imsg ${DIM}(iMessage)${RESET} — installed\n"
    INSTALLED_SOMETHING=true
  fi
else
  printf "    ${DIM}  (Apple Notes, Reminders, iMessage — macOS only, skipping)${RESET}\n"
fi

# gog (Google Calendar + Gmail) — works on macOS and Linux via Homebrew
if [ "$HAS_BREW" = "true" ]; then
  if command -v gog &>/dev/null; then
    printf "    ${CHECK} gog ${DIM}(Google Calendar + Gmail)${RESET}\n"
  else
    printf "    ${ARROW} Installing gog ${DIM}(Google Calendar + Gmail)${RESET}...\n"
    brew install steipete/tap/gogcli
    printf "    ${CHECK} gog ${DIM}(Google Calendar + Gmail)${RESET} — installed\n"
    INSTALLED_SOMETHING=true
  fi
else
  printf "    ${DIM}  gog (Google Calendar + Gmail) — install Homebrew to enable${RESET}\n"
fi

printf "\n"

# ── Permissions (only on macOS fresh install) ─────────────────
if [ "$IS_MACOS" = "true" ] && [ "$INSTALLED_SOMETHING" = true ]; then
  printf "${BOLD}  Permissions ${RESET}${DIM}─── macOS may prompt you${RESET}\n\n"
  printf "    ${WARN} iMessage requires ${BOLD}Full Disk Access${RESET} for your terminal:\n"
  printf "    ${DIM}  System Settings > Privacy & Security > Full Disk Access${RESET}\n"
  printf "\n"
fi

# ── Check if directory is already trusted by Claude Code ──────
ARTHUR_DIR="$(pwd)"
CLAUDE_JSON="$HOME/.claude.json"
DIR_TRUSTED=false
if [ -f "$CLAUDE_JSON" ]; then
  DIR_TRUSTED=$(python3 - "$ARTHUR_DIR" "$CLAUDE_JSON" <<'PYEOF'
import json, sys, os
project_dir, config_file = sys.argv[1], sys.argv[2]
with open(config_file) as f: data = json.load(f)
projects = data.get("projects", {})
# Check this dir and all parents (mirrors Claude Code's trust inheritance)
path = project_dir
while True:
    if projects.get(path, {}).get("hasTrustDialogAccepted"):
        print("true"); sys.exit()
    parent = os.path.dirname(path)
    if parent == path: break
    path = parent
print("false")
PYEOF
  )
fi

# ── Caffeinate (prevent Mac sleep) ────────────────────────────
if [ "$IS_MACOS" = "true" ] && ! pgrep -x caffeinate > /dev/null; then
  caffeinate -di &
fi

# ── Handle existing tmux session ──────────────────────────────
if tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
  printf "  ${CHECK} Arthur is already running.\n\n"
  printf "    ${CYAN}Attaching to session...${RESET}\n\n"
  exec tmux attach-session -t "$SESSION_NAME"
fi

# ── Start Claude in tmux ──────────────────────────────────────
if [ "$DIR_TRUSTED" = "true" ]; then
  # Subsequent run — fully automatic
  printf "${BOLD}  Starting Arthur...${RESET}\n\n"
  tmux new-session -d -s "$SESSION_NAME" -c "$(pwd)" "claude --dangerously-skip-permissions --chrome"

  sleep 3
  tmux send-keys -t "$SESSION_NAME" "/remote-control" Enter
  sleep 1
  tmux send-keys -t "$SESSION_NAME" Enter
  sleep 2
  tmux send-keys -t "$SESSION_NAME" "/rename Arthur" Enter
  sleep 1
  tmux send-keys -t "$SESSION_NAME" Enter

  printf "  ${CHECK} Arthur is running. Attaching now...\n"
  printf "    ${DIM}Stop:  tmux kill-session -t ${SESSION_NAME}${RESET}\n\n"
  exec tmux attach-session -t "$SESSION_NAME"
else
  # First run — show onboarding, wait for user, then launch
  printf "${MAGENTA}${BOLD}"
  printf "    +---------------------------------------+\n"
  printf "    |          First time setup              |\n"
  printf "    +---------------------------------------+\n"
  printf "${RESET}\n"
  printf "    Claude Code will open next. Here's what to do:\n\n"
  printf "    ${CYAN}1.${RESET} Press ${BOLD}y${RESET} to trust the ~/arthur folder\n"
  printf "    ${CYAN}2.${RESET} Type ${BOLD}/onboarding${RESET} and press Enter to set up Arthur\n"
  printf "    ${CYAN}3.${RESET} Type ${BOLD}/remote-control${RESET} and press Enter\n"
  printf "    ${CYAN}4.${RESET} Open the link or use the Claude app's ${BOLD}Code${RESET} menu\n"
  printf "\n"
  printf "    ${DIM}(next time, ./start.sh does all of this automatically)${RESET}\n"
  printf "\n"
  read -r -p "    Press Enter to continue... "
  printf "\n"

  tmux new-session -d -s "$SESSION_NAME" -c "$(pwd)" "claude --dangerously-skip-permissions --chrome"
  exec tmux attach-session -t "$SESSION_NAME"
fi

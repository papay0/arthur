# Arthur

A personal AI assistant powered by Claude Code. Talk to it from your phone, manage Apple Notes & Reminders, iMessage, browse the web, and more.

**Website:** [getarthur.dev](https://github.com/papay0/getarthur)

## Get Started (2 minutes)

**Prerequisites:** macOS, [Homebrew](https://brew.sh), [Claude Code](https://docs.anthropic.com/en/docs/claude-code) (`npm i -g @anthropic-ai/claude-code`)

```bash
git clone https://github.com/papay0/arthur ~/arthur && ~/arthur/start.sh
```

This single command clones the repo, installs dependencies, and starts Arthur in a tmux session. On subsequent runs, just `./start.sh` — it skips what's already installed.

Then type `/remote-control` — open the link or use the [Claude app](https://apps.apple.com/app/claude-by-anthropic/id6473753684)'s Code menu to chat from your phone.

## What It Can Do

- **Apple Notes** — read, search, create, edit your notes
- **Apple Reminders** — add, complete, list reminders (syncs to iPhone)
- **iMessage** — read conversations, send texts, catch up on messages
- **Browse the web** — controls your real Chrome with your logins
- **Memory** — remembers things across sessions
- **Morning briefing** — summarizes your reminders, notes, and TODOs

## Customize

- Edit `SOUL.md` to change the assistant's personality and voice
- Edit `CLAUDE.md` to change its capabilities and rules
- Add skills in `.claude/skills/`

## Commands

```bash
./start.sh                  # install deps + start (or attach if already running)
tmux attach -t arthur       # re-attach to session
tmux kill-session -t arthur # stop Arthur
```

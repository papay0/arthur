# Self-Update

When the user says "update yourself", "update Arthur", "check for updates", or similar:

## What to do

### 1. Pull latest changes

```bash
git -C ~/arthur pull
```

If the output is `Already up to date.`, tell the user Arthur is already on the latest version and stop here.

If there were changes, briefly summarize what was pulled (you can read the git log):
```bash
git -C ~/arthur log --oneline -5
```

### 2. Schedule a restart

Since Arthur runs inside the tmux session it would be killing, restart must happen in a separate tmux session that survives the kill:

```bash
tmux new-session -d -s arthur-restart 'bash -c '\''sleep 3 && tmux kill-session -t arthur 2>/dev/null; sleep 1; cd ~/arthur && tmux new-session -d -s arthur -c ~/arthur "claude --dangerously-skip-permissions --chrome" && sleep 4 && tmux send-keys -t arthur "/remote-control" Enter && sleep 1 && tmux send-keys -t arthur "" Enter && sleep 2 && tmux send-keys -t arthur "/rename Arthur" Enter && sleep 1 && tmux send-keys -t arthur "" Enter && tmux kill-session -t arthur-restart'\'''
```

### 3. Tell the user

Say something like:

> "Pulled the latest. I'll restart in a few seconds — reconnect with `./start.sh` or from the Claude app."

Then stop responding. The session will be killed in ~3 seconds and a fresh one will start automatically.

## If the user just wants to check for updates (no restart)

```bash
git -C ~/arthur fetch && git -C ~/arthur log HEAD..origin/main --oneline
```

If output is empty, Arthur is up to date. Otherwise show what's available and ask if they want to update.

## Manual fallback

If the user wants to update manually (e.g. the restart fails), tell them to run from their terminal:
```bash
~/arthur/update.sh
```

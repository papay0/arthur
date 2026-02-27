# Scheduling

> **Default reminder system:** When the user says "remind me at X to do Y" or any variant, use the local queue system described below — NOT the Apple Reminders skill. The Apple Reminders skill is for managing the user's actual Reminders.app; this system delivers reminders directly into this conversation.

Arthur can manage automated schedules using macOS `crontab` and the `run-scheduled.sh` helper script. Each schedule is a markdown file in `schedules/` that contains the message to send to the Arthur tmux session.

## How It Works

- Schedule files live in `~/arthur/schedules/<name>.md`
- Each file contains the exact message to send to Arthur when triggered
- `run-scheduled.sh <name>` sends that message to the `arthur` tmux session via `tmux send-keys`
- `crontab` triggers `run-scheduled.sh` at the specified time
- Works in both terminal mode and remote-control (phone/browser) — `tmux send-keys` injects directly into the running Claude Code session

## Commands

### List schedules
```bash
crontab -l 2>/dev/null | grep run-scheduled || echo "No schedules configured"
```
Also list the schedule files:
```bash
ls ~/arthur/schedules/
```

### Add a schedule
1. Create `~/arthur/schedules/<name>.md` with the message content
2. Add a crontab entry:
```bash
(crontab -l 2>/dev/null; echo "0 8 * * * /Users/papay0/arthur/run-scheduled.sh <name>") | crontab -
```

### Remove a schedule
1. Remove the crontab entry:
```bash
crontab -l | grep -v "<name>" | crontab -
```
2. Delete the schedule file:
```bash
rm ~/arthur/schedules/<name>.md
```

### Edit a schedule's time
```bash
EDITOR=nano crontab -e
```
Or remove and re-add the entry with the new time.

## Crontab Format Reference
```
MIN HOUR DAY MONTH WEEKDAY command
 0    8   *    *      *     = 8:00 AM every day
 0    8   *    *     1-5    = 8:00 AM weekdays only
30    7   *    *      *     = 7:30 AM every day
 0   20   *    *      0     = 8:00 PM Sundays
```

## Interactive Setup

When the user says "set up my schedule", "schedule my morning briefing", or similar:

1. Ask what time they want it (suggest 8:00 AM as default)
2. Ask if weekdays only or every day
3. Create/update the schedule file in `schedules/`
4. Add the crontab entry with the full path: `/Users/papay0/arthur/run-scheduled.sh <name>`
5. Confirm by showing `crontab -l | grep run-scheduled`

## Built-in Schedules

- `morning-briefing` — sends "Give me my morning briefing" (triggers the morning briefing skill)
- `reminder-fire` — triggers the reminder delivery system (see below)

---

## Reminder System

For one-off reminders ("remind me at 2pm to call mom"), Arthur uses a local queue file instead of a dedicated schedule file per reminder.

### Queue file

`~/arthur/reminders/queue.jsonl` — one JSON object per line:

```json
{"id": "abc123", "scheduled_at": "2026-02-26T14:00:00", "content": "Call mom", "created_at": "2026-02-26T10:00:00Z", "delivered": false}
```

### When the user asks to be reminded

1. Append an entry to `~/arthur/reminders/queue.jsonl` — use `jq` to avoid bash escaping issues with special characters like `!`:
```bash
jq -n \
  --arg id "$(uuidgen)" \
  --arg scheduled_at "2026-02-26T14:00:00" \
  --arg content "Call mom" \
  --arg created_at "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  '{id: $id, scheduled_at: $scheduled_at, content: $content, created_at: $created_at, delivered: false}' \
  >> ~/arthur/reminders/queue.jsonl
```
2. Add a one-shot cron entry (fires once at the specified time):
```bash
(crontab -l 2>/dev/null; echo "0 14 26 2 * /Users/papay0/arthur/run-scheduled.sh reminder-fire") | crontab -
```
Use the exact date/time from the user's request. For daily/recurring reminders, use `*` for day/month.

### When `⏰ Reminder` fires (handling the trigger)

The cron job injects the contents of `schedules/reminder-fire.md` into the conversation. When Arthur receives this message:

1. Read `~/arthur/reminders/queue.jsonl`
2. Find all entries where `scheduled_at` ≤ current time AND `delivered` is `false`
3. For each due reminder, send a brief friendly message to the user (e.g. "Hey! 2pm reminder: call mom 📞")
4. Rewrite the file marking those entries as `"delivered": true`

Example bash to rewrite delivered entries:
```bash
python3 << 'PYEOF'
import json
from datetime import datetime

raw = open('/Users/papay0/arthur/reminders/queue.jsonl').read()

objects = []
decoder = json.JSONDecoder()
i = 0
while i < len(raw):
    while i < len(raw) and raw[i] in ' \t\n\r':
        i += 1
    if i >= len(raw):
        break
    try:
        obj, i = decoder.raw_decode(raw, i)  # i is absolute end position
        if isinstance(obj, dict):
            objects.append(obj)
    except json.JSONDecodeError:
        i += 1

now = datetime.now()
due = []
for r in objects:
    sched = datetime.fromisoformat(r['scheduled_at'])
    if not r['delivered'] and sched <= now:
        r['delivered'] = True
        due.append(r['content'])

with open('/Users/papay0/arthur/reminders/queue.jsonl', 'w') as f:
    for r in objects:
        f.write(json.dumps(r) + '\n')

for c in due:
    print(c)
PYEOF
```

### Cleanup old cron entries

After delivering, optionally remove the cron entry if it was a one-shot reminder:
```bash
# Remove one-shot entries that have already fired (past dates)
crontab -l | grep -v "reminder-fire" | crontab -
```
Only do this if all reminder-fire cron entries have been delivered. If there are future reminders still pending, keep them.

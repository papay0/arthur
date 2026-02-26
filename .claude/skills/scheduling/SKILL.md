# Scheduling

Arthur can manage automated schedules using macOS `crontab` and the `run-scheduled.sh` helper script. Each schedule is a markdown file in `schedules/` that contains the message to send to the Arthur tmux session.

## How It Works

- Schedule files live in `~/arthur/schedules/<name>.md`
- Each file contains the exact message to send to Arthur when triggered
- `run-scheduled.sh <name>` sends that message to the `arthur` tmux session
- `crontab` triggers `run-scheduled.sh` at the specified time

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

# Apple Reminders

> **Scope:** Use this skill only when the user explicitly asks to manage their Reminders.app (view, edit, delete, list). For "remind me at X to do Y" requests — use the **scheduling skill** (local queue + cron) instead so the reminder fires back into this conversation.

Manage Apple Reminders via the `remindctl` CLI.

## Setup

- Install: `brew install steipete/tap/remindctl`
- macOS-only; grant Reminders permission when prompted.
- Check status: `remindctl status`
- Request access: `remindctl authorize`

## View Reminders

```bash
remindctl show today              # Today's reminders
remindctl show tomorrow           # Tomorrow
remindctl show week               # This week
remindctl show overdue            # Past due
remindctl show upcoming           # Upcoming (includes overdue + future)
remindctl show all                # Everything
remindctl show completed          # Completed
remindctl show 2026-01-04         # Specific date
remindctl show -l Work            # Filter by list (-l is short for --list)
remindctl show today -j           # JSON output (-j is short for --json)
remindctl show today --plain      # TSV output
remindctl show today -q           # Counts only (-q is short for --quiet)
remindctl show today --no-input   # Non-interactive (good for scripting)
```

## Manage Lists

```bash
remindctl list                        # List all lists with counts
remindctl list Work                   # Show ALL reminders in list (including completed!)
remindctl list Projects --create      # Create list
remindctl list Work --delete -f       # Delete list (-f skips confirmation)
remindctl list Work --rename Office   # Rename list
```

> **Note:** `remindctl list Work` shows ALL reminders (including old completed ones).
> Use `remindctl show -l Work` to see only upcoming/active reminders in a list.

## Create Reminders

```bash
remindctl add "Buy milk"
remindctl add --title "Call mom" --list Personal --due tomorrow
remindctl add "Meeting prep" --due "2026-02-15 09:00"
remindctl add "Review docs" --priority high
remindctl add "Important task" --due tomorrow --notes "Don't forget the attachment"
```

## Edit Reminders

Use the index number from `remindctl show` output:
```bash
remindctl edit 1 --title "New title"
remindctl edit 1 --due tomorrow
remindctl edit 1 --priority high --notes "Call before noon"
remindctl edit 1 --list "Work"
remindctl edit 1 --clear-due
remindctl edit 1 --complete
remindctl edit 1 --incomplete
```

## Complete Reminders

```bash
remindctl complete 1               # Complete by index
remindctl complete 1 2 3           # Complete multiple
```

## Delete Reminders

```bash
remindctl delete 1 -f              # Delete by index (-f skips confirmation)
remindctl delete 1 2 3 -f         # Delete multiple
```

## Date Formats

Accepted by `--due` and date filters:
- `today`, `tomorrow`, `yesterday`
- `YYYY-MM-DD`
- `YYYY-MM-DD HH:mm`
- ISO 8601 (`2026-01-04T12:34:56Z`)

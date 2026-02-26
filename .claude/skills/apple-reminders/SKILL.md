# Apple Reminders

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
remindctl show upcoming           # Upcoming
remindctl show all                # Everything
remindctl show completed          # Completed
remindctl show 2026-01-04         # Specific date
remindctl show --list Work        # Specific list
remindctl show today --json       # JSON output
remindctl show today --plain      # TSV output
remindctl show today --quiet      # Counts only
```

## Manage Lists

```bash
remindctl list                        # List all lists
remindctl list Work                   # Show specific list
remindctl list Projects --create      # Create list
remindctl list Work --delete --force  # Delete list
remindctl list Work --rename Office   # Rename list
```

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
remindctl delete 1 --force         # Delete by index
remindctl delete 1 2 3 --force     # Delete multiple
```

## Date Formats

Accepted by `--due` and date filters:
- `today`, `tomorrow`, `yesterday`
- `YYYY-MM-DD`
- `YYYY-MM-DD HH:mm`
- ISO 8601 (`2026-01-04T12:34:56Z`)

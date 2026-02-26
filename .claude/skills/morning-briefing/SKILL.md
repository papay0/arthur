# Morning Briefing

When the user asks for a morning briefing, daily summary, or "what's on my plate":

## 1. Calendar (if Google configured)
Check first: `gog auth list`. If configured:
```bash
gog calendar events primary --from "$(date -u +%Y-%m-%dT00:00:00Z)" --to "$(date -u +%Y-%m-%dT23:59:59Z)"
```
Also preview tomorrow:
```bash
gog calendar events primary --from "$(date -u -v+1d +%Y-%m-%dT00:00:00Z)" --to "$(date -u -v+1d +%Y-%m-%dT23:59:59Z)"
```

## 2. Email (if Google configured)
If `gog auth list` shows an account:
```bash
gog gmail search "is:unread newer_than:1d" --max 5
```

## 3. Reminders
```bash
remindctl show today
remindctl show overdue
```

## 4. Notes
```bash
osascript -e 'tell application "Notes" to get {name, modification date} of notes 1 thru 5'
```

## 5. Messages
```bash
imsg chats --limit 5 --json
```

## 6. Todos
Read `memory/todos.md` for any tracked action items.

## Presentation
- Present everything in a short, scannable summary
- Group by section with clear headers
- Highlight anything urgent (overdue reminders, today's upcoming events)
- Skip empty sections silently (don't say "no emails" if Google isn't configured)

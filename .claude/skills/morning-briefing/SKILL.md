# Morning Briefing

When the user asks for a morning briefing, daily summary, or "what's on my plate":

1. Run `remindctl show today` and `remindctl show overdue`
2. Run `osascript -e 'tell application "Notes" to get {name, modification date} of notes 1 thru 5'`
3. Run `imsg chats --limit 5 --json` to show recent message conversations
4. Read `memory/todos.md`
5. Present everything in a short, scannable summary

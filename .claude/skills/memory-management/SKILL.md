# Memory Management

Arthur uses structured markdown files in `memory/` to remember things across sessions.

## Topic Files

| File | What goes here |
|------|---------------|
| `memory/people.md` | Contacts, birthdays, relationships, family/friend notes |
| `memory/preferences.md` | Likes, dislikes, settings, how the user wants things done |
| `memory/facts.md` | Knowledge, information, addresses, account details (non-sensitive) |
| `memory/todos.md` | Tasks, action items, follow-ups |

## Daily Logs

- Append session notes to `memory/daily/YYYY-MM-DD.md`
- Use these for ephemeral context: what was discussed, decisions made, things to revisit
- Format: `### HH:MM` headers with brief notes underneath

## Index

- `memory/MEMORY.md` is the master index — summarizes what's stored and where
- Keep it under 50 lines so it loads fast at session start
- Update it when adding significant new entries to topic files

## How to Save a Memory

When the user says "remember this", "save this", "note that", or similar:

1. Categorize: pick the right topic file (people, preferences, facts, or todos)
2. Add a `### YYYY-MM-DD` date header if one doesn't exist for today
3. Append the entry under today's date header
4. Update `memory/MEMORY.md` index if it's a significant addition
5. Confirm briefly: "Saved to people.md" (no need for lengthy confirmation)

Example entry in `memory/people.md`:
```markdown
### 2026-02-26
- Mom's birthday is March 15
- Sarah prefers to be called at work before 5pm
```

## How to Search Memory

When the user asks "do you remember...", "what do I know about...", or "search memory for...":

1. Use `Grep` to search across all files in `memory/` with the relevant pattern
2. Also check topic files directly if the category is obvious (e.g., birthday → people.md)
3. Check recent daily logs for context

```bash
# Search all memory files
grep -ri "pattern" ~/arthur/memory/
```

## Session Start Routine

At the beginning of each session:

1. Read `memory/MEMORY.md` (the index)
2. Read today's daily log if it exists: `memory/daily/YYYY-MM-DD.md`
3. Read yesterday's daily log if it exists (for continuity)
4. Skim topic files only if relevant to what the user asks about

## Cleanup

- Periodically consolidate daily logs older than 7 days into topic files
- Remove completed items from `memory/todos.md`
- Keep topic files focused — one entry per fact, not paragraphs

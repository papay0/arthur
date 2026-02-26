# Google Workspace (gog CLI)

Arthur uses the `gog` CLI to access Google Calendar and Gmail. Before using any `gog` command, check if it's configured:

```bash
gog auth list
```

If not configured, guide the user through setup (see the google-setup skill).

## Environment

Set the account for all commands:
```bash
export GOG_ACCOUNT=user@gmail.com
```
Check `memory/preferences.md` for the saved Google account email.

## Google Calendar

### List today's events
```bash
gog calendar events primary --from "$(date -u +%Y-%m-%dT00:00:00Z)" --to "$(date -u +%Y-%m-%dT23:59:59Z)"
```

### List tomorrow's events
```bash
gog calendar events primary --from "$(date -u -v+1d +%Y-%m-%dT00:00:00Z)" --to "$(date -u -v+1d +%Y-%m-%dT23:59:59Z)"
```

### List this week's events
```bash
gog calendar events primary --from "$(date -u +%Y-%m-%dT00:00:00Z)" --to "$(date -u -v+7d +%Y-%m-%dT23:59:59Z)"
```

### Create an event
```bash
gog calendar create primary \
  --title "Meeting with Sarah" \
  --start "2026-02-27T10:00:00" \
  --end "2026-02-27T11:00:00" \
  --description "Discuss project timeline"
```

### Update an event
```bash
gog calendar update primary <event-id> \
  --title "Updated title" \
  --start "2026-02-27T11:00:00" \
  --end "2026-02-27T12:00:00"
```

### Delete an event
```bash
gog calendar delete primary <event-id>
```

## Gmail

### Search emails
```bash
gog gmail search "is:unread newer_than:1d" --max 10
```

### Search with specific query
```bash
gog gmail search "from:someone@example.com subject:project" --max 5
```

### Read a message
```bash
gog gmail messages get <message-id>
```

### Send an email
Important: `--body` does not support `\n`. Use `--body-file -` with a heredoc for multiline:
```bash
gog gmail send \
  --to "recipient@example.com" \
  --subject "Subject line" \
  --body-file - <<'EOF'
Hello,

This is the email body.
Multiple lines work with heredoc.

Best,
Arthur
EOF
```

### Create a draft
```bash
gog gmail drafts create \
  --to "recipient@example.com" \
  --subject "Draft subject" \
  --body-file - <<'EOF'
Draft body content here.
EOF
```

### List drafts
```bash
gog gmail drafts list --max 5
```

## Google Drive (when needed)

```bash
gog drive list --max 10
gog drive search "quarterly report" --max 5
gog drive download <file-id> --output ~/Downloads/
```

## Google Contacts (when needed)

```bash
gog contacts list --max 20
gog contacts search "Sarah"
```

## Key Gotchas

- Always use `--body-file -` with heredoc for multiline email bodies, never `--body` with `\n`
- Date formats: ISO 8601 (`2026-02-26T10:00:00Z` or `2026-02-26T10:00:00`)
- The `primary` calendar is the user's main calendar
- Set `GOG_ACCOUNT` env var or pass `--account user@gmail.com` to every command
- If auth fails, re-run `gog auth add` (see google-setup skill)

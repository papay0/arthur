# iMessage

Read and send iMessages via the `imsg` CLI.

## Setup

- Install: `brew install steipete/tap/imsg`
- Requires **Full Disk Access** for your terminal (System Settings > Privacy & Security > Full Disk Access)
- Requires **Automation** permission for Messages.app (granted on first send)
- macOS-only, Messages.app must be signed in

## If you get "permissionDenied" errors

The user needs to grant Full Disk Access to their terminal app:
1. Open System Settings > Privacy & Security > Full Disk Access
2. Click the + button and add their terminal app (Terminal.app, iTerm2, Warp, etc.)
3. Restart the terminal

Tell the user exactly what to do — don't keep retrying the command.

## List Conversations

```bash
imsg chats                     # List all conversations
imsg chats --json              # JSON output (for parsing)
imsg chats --limit 20          # Limit results
```

## Read Messages

```bash
imsg history --chat-id <id>                                      # Read messages from a chat
imsg history --chat-id <id> --limit 20                           # Last 20 messages
imsg history --chat-id <id> --json                               # JSON output
imsg history --chat-id <id> --attachments                        # Include attachment metadata
imsg history --chat-id <id> --start 2026-01-01T00:00:00Z        # Messages after date (ISO8601)
imsg history --chat-id <id> --end 2026-02-01T00:00:00Z          # Messages before date (ISO8601)
```

To find the chat ID, first run `imsg chats` and look for the ID column.

## Send Messages

```bash
imsg send --to "+14155551234" --text "Hello!"                              # Send by phone number
imsg send --to "+14155551234" --text "Hello!" --service imessage           # Force iMessage
imsg send --to "+14155551234" --text "Hello!" --service sms                # Force SMS
imsg send --to "email@example.com" --text "Hello!"                         # Send to email
imsg send --to "+14155551234" --text "See attached" --file ~/Desktop/pic.jpg  # Send with attachment (use --file, not --attachment)
```

## Watch for New Messages (live stream)

```bash
imsg watch              # Stream new messages as they arrive
imsg watch --json       # JSON output
```

## Tips

- Always use `--json` when you need to parse output programmatically
- Chat IDs are stable — save them to memory for frequent contacts
- The `--service` flag defaults to auto-detect (iMessage if available, SMS fallback)
- Attachments are supported: `imsg send --to "..." --text "See attached" --file /path/to/file` (flag is `--file`, not `--attachment`)
- When the user asks "read my messages" or "check my texts", use `imsg chats` first to list conversations, then `imsg history` on the relevant chat

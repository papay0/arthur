# Google Workspace Setup

Interactive setup guide for connecting Google Calendar and Gmail via the `gog` CLI.

## Check If Already Configured

```bash
gog auth list
```

If this shows an account, Google is already set up. Save the account email to `memory/preferences.md` if not already there.

## Step-by-Step Setup

Guide the user through these steps interactively:

### 1. Install gog (if not already installed)
This is handled by `start.sh`, but if needed:
```bash
brew install steipete/tap/gogcli
```

### 2. Create Google Cloud Project
Tell the user:
> Go to https://console.cloud.google.com and create a new project (or use an existing one).
> Name it something like "Arthur Assistant".

### 3. Enable APIs
Tell the user:
> In the Google Cloud Console, go to "APIs & Services" > "Library" and enable:
> - **Gmail API**
> - **Google Calendar API**

### 4. Create OAuth Credentials
Tell the user:
> 1. Go to "APIs & Services" > "Credentials"
> 2. Click "Create Credentials" > "OAuth client ID"
> 3. If prompted, configure the OAuth consent screen first (External is fine, add your email as test user)
> 4. Application type: **Desktop app**
> 5. Name it "Arthur"
> 6. Download the JSON file and save it to `~/arthur/client_secret.json`

### 5. Register Credentials with gog
```bash
gog auth credentials ~/arthur/client_secret.json
```

### 6. Add Account
Ask the user for their Gmail address, then:
```bash
gog auth add user@gmail.com --services gmail,calendar
```
This opens a browser for OAuth consent. The user needs to click through the permissions.

### 7. Test
```bash
gog calendar events primary --from "$(date -u +%Y-%m-%dT00:00:00Z)" --to "$(date -u +%Y-%m-%dT23:59:59Z)"
```

### 8. Save to Memory
Save the account email to `memory/preferences.md`:
```markdown
### YYYY-MM-DD
- Google account: user@gmail.com (used for gog CLI — calendar + gmail)
```

## Troubleshooting

- **"No credentials found"**: Re-run step 5 with the correct path to `client_secret.json`
- **"Token expired"**: Run `gog auth add user@gmail.com --services gmail,calendar` again
- **"API not enabled"**: Go back to Google Cloud Console and enable the required APIs
- **Permission denied on calendar/gmail**: The user may need to re-consent; run `gog auth add` again

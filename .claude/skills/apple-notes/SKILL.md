# Apple Notes

Read and search Apple Notes on macOS.

## IMPORTANT: Always use `osascript` to read notes. Never use `memo` for reading — it hangs.

## Read Notes (use these exact commands)

List the 10 most recent notes with dates:
```bash
osascript -e 'tell application "Notes" to get {name, modification date} of notes 1 thru 10'
```

List all note names:
```bash
osascript -e 'tell application "Notes" to get name of every note'
```

List notes in a specific folder:
```bash
osascript -e 'tell application "Notes" to get name of every note in folder "FolderName"'
```

Read a note by name (returns HTML):
```bash
osascript -e 'tell application "Notes" to get body of note "NoteName"'
```

Search notes containing a keyword — **DO NOT USE**: this reliably times out with an AppleEvent error (-1712). Use Spotlight instead:
```bash
mdfind -onlyin ~/Library/Group\ Containers/group.com.apple.notes 'keyword'
```
Or list all note names and grep:
```bash
osascript -e 'tell application "Notes" to get name of every note' | tr ',' '\n' | grep -i "keyword"
```

List all folders:
```bash
osascript -e 'tell application "Notes" to get name of every folder'
```

Get note count:
```bash
osascript -e 'tell application "Notes" to get count of every note'
```

## Create/Edit/Delete Notes (memo CLI — interactive only)

These commands open an interactive editor and require terminal access:
- Create: `memo notes -a`
- Edit: `memo notes -e`
- Delete: `memo notes -d`
- Move: `memo notes -m`
- List folders: `memo notes -fl`

## Notes

- `osascript` returns HTML for note bodies. Strip tags with `sed 's/<[^>]*>//g'` if plain text is needed.
- macOS-only. First run may prompt for Automation permissions.

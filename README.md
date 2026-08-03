# ToDoMenuBar

To-do list that lives in your Mac's menu bar. No Dock icon, no windows.

## Features

- Add, check off, delete, double-click to rename tasks. Live count in the menu bar.
- Completed tasks sink to the bottom. "Clear Completed" button.
- Settings (gear icon): Appearance (System/Light/Dark), Popup Size (Compact/Standard/Large), Launch at Login, Show in Dock.
- Persists automatically, no save step.
- No special permissions needed — just a one-time Gatekeeper approval on first launch (below).

## Download

**[Latest release →](https://github.com/anishkothuri/ToDoMenuBar/releases/latest)**

Download `TodoMenuBar.dmg` from Assets.

## Install

1. Open the downloaded `.dmg`.
2. Drag **TodoMenuBar** into **Applications**.
3. Open **TodoMenuBar** from Applications.

## First launch (Gatekeeper)

Unsigned/unnotarized, so macOS blocks it the first time: *"cannot be opened because Apple cannot check it for malicious software."* One-time fix, pick one:

- Right-click the app → **Open** → **Open**.
- Or: **System Settings → Privacy & Security** → **Open Anyway**.
- Or: `xattr -cr /Applications/TodoMenuBar.app` in Terminal.

After that it opens normally, no more warnings.

## Troubleshooting

- **"App is damaged"** — same fix as above (`xattr -cr` or right-click Open).
- **Can't find the icon** — menu bar may be overflowing; hold ⌘ and drag icons to rearrange.
- **Launch at Login not sticking** — check the toggle in TodoMenuBar → Settings, or System Settings → General → Login Items & Extensions.
- **Uninstall** — turn off Launch at Login first (Settings or System Settings), then drag the app to Trash.

## Building from source

Requires Xcode + Homebrew.

```bash
git clone https://github.com/anishkothuri/ToDoMenuBar.git
cd ToDoMenuBar
bash scripts/build.sh
bash scripts/test.sh
bash scripts/make_dmg.sh
```

## License

MIT — see [LICENSE](LICENSE).

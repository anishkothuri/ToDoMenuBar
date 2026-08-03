# ToDoMenuBar

A small, polished to-do list that lives entirely in your Mac's menu bar — no
Dock icon, no cluttered windows, just a checkmark and your tasks, one click
away.

## Features

- **Lives in the menu bar.** Click the checkmark to add, check off, delete,
  or double-click to rename tasks. A live count of what's left sits right
  next to the icon.
- **Completed tasks sink to the bottom** automatically, so your active list
  always stays on top. "Clear Completed" appears once you've checked
  something off.
- **A real Settings window** (gear icon inside the popup) with:
  - **Appearance** — System / Light / Dark, independent of your Mac's
    overall setting. Light is a flat white background with black text;
    Dark is the standard macOS dark appearance.
  - **Popup Size** — Compact / Standard / Large, if you keep a lot of tasks
    or just prefer a bigger window.
  - **Launch at Login** — on/off toggle, backed by macOS's modern login-item
    API. Off by default until you turn it on.
  - **Show in Dock** — off by default (menu-bar-only app); flip it on if you
    also want a Dock icon.
- **Persists automatically** to your Mac — no save button, survives quitting
  the app and restarting your Mac.
- **No special permissions required.** TodoMenuBar doesn't touch your
  camera, microphone, contacts, files outside its own settings, or
  Accessibility APIs. The only thing macOS will ask you about is a one-time
  Gatekeeper approval on first launch (see below) — that's not a permission
  *you* grant the app, it's macOS confirming you trust where it came from.

## Download

Grab the latest **`ToDoMenuBar.dmg`** from the
[**Releases**](https://github.com/anishkothuri/ToDoMenuBar/releases/latest)
page. Look for the file named `ToDoMenuBar.dmg` under "Assets" on the latest
release.

### Installing

1. Download `ToDoMenuBar.dmg` from the Releases page above (it'll land in
   your **Downloads** folder).
2. Double-click the downloaded `.dmg` to open it — a window appears with the
   TodoMenuBar app icon and a shortcut to your **Applications** folder.
3. Drag the **TodoMenuBar** icon onto the **Applications** shortcut.
4. Eject the disk image (right-click it on your Desktop → Eject), then open
   your **Applications** folder and double-click **TodoMenuBar**.

### First launch: getting past Gatekeeper

This app is **not notarized** — that requires a paid $99/year Apple
Developer account, which this personal project doesn't have. The code is
signed (ad-hoc), safe, and open source (read it yourself in this repo!), but
macOS doesn't know that yet, so the first time you open it you'll see a
warning like:

> "TodoMenuBar" cannot be opened because Apple cannot check it for malicious
> software.

This is expected, and only happens once. Pick **one** of these:

- **Easiest:** Right-click (or Control-click) the app in Applications →
  choose **Open** → click **Open** again in the dialog that appears. This
  works even for unnotarized apps.
- **Via System Settings:** Try to open the app normally (double-click), let
  it get blocked, then go to **System Settings → Privacy & Security**,
  scroll down, and you'll see *"TodoMenuBar" was blocked* with an **Open
  Anyway** button. Click it, confirm with your password or Touch ID, then
  open the app again.
- **Via Terminal** (if the above don't show up, or you're comfortable with
  the command line):
  ```bash
  xattr -cr /Applications/TodoMenuBar.app
  ```
  Then open the app normally.

After this one-time approval, TodoMenuBar opens instantly every time, just
like any other app — no more warnings.

### After it's open

A checkmark (✓) appears in your menu bar. Click it to see your list. Click
the gear icon inside the popup for Settings (appearance, popup size, launch
at login, Dock visibility). Click **Quit** at the bottom of the popup to
close the app.

## Troubleshooting

- **"TodoMenuBar is damaged and can't be opened"** — macOS sometimes shows
  this instead of the malware warning above, usually because the download
  got quarantined by your browser. Fix it the same way as the Gatekeeper
  warning: right-click → Open, or run `xattr -cr /Applications/TodoMenuBar.app`
  in Terminal.
- **I don't see the checkmark in my menu bar** — if you have a lot of menu
  bar icons, it may be hidden. Hold ⌘ and drag icons in the menu bar to
  rearrange them, or check if a menu-bar-management tool (e.g. Bartender) is
  hiding it.
- **Launch at Login doesn't seem to work** — open TodoMenuBar → Settings and
  check the toggle state, or check **System Settings → General → Login
  Items & Extensions** directly; you can enable/disable it from either
  place.
- **I want to uninstall it** — quit the app, then drag
  `/Applications/TodoMenuBar.app` to the Trash. If you'd also enabled
  "Launch at Login," open the app once more first and turn that toggle off
  (or remove it from System Settings → General → Login Items & Extensions)
  before deleting it.

## Building from source

Requires Xcode (full app, not just Command Line Tools) and Homebrew.

```bash
git clone https://github.com/anishkothuri/ToDoMenuBar.git
cd ToDoMenuBar
bash scripts/build.sh      # builds build/Build/Products/Release/TodoMenuBar.app
bash scripts/test.sh       # runs the unit test suite
bash scripts/make_dmg.sh   # packages dist/TodoMenuBar.dmg
```

## Screenshot

*(Add a screenshot of the popup here after your first run.)*

## License

MIT — see [LICENSE](LICENSE).

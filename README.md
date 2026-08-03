# TodoMenuBar

A small, polished SwiftUI menu bar to-do list for macOS. Lives entirely in the
menu bar — no Dock icon, no windows cluttering your desktop.

## Features

- Menu bar checkmark icon with a live count of remaining tasks; switches to a
  filled checkmark once everything's done.
- Add, check off, delete tasks; double-click a task to rename it in place.
- "Clear Completed" button appears once you've checked something off.
- Appearance menu (System / Light / Dark), independent of your Mac's overall
  appearance setting.
- Launches automatically at login (via the modern `ServiceManagement` API).
- Persists automatically — no save button, survives quit and restart.

## Download

Grab the latest `.dmg` from [Releases](https://github.com/anishkothuri/TodoMenuBar/releases).

### Gatekeeper note

This app isn't notarized (no paid Apple Developer account behind this project),
so on first launch macOS will say it "cannot be opened because Apple could not
verify it is free of malware." To open it anyway:

- Right-click the app in Applications → **Open** → **Open**, or
- Run once in Terminal: `xattr -cr /Applications/TodoMenuBar.app`

## Building from source

Requires Xcode and Homebrew.

```bash
git clone https://github.com/anishkothuri/TodoMenuBar.git
cd TodoMenuBar
bash scripts/build.sh
bash scripts/make_dmg.sh
```

The built app lands at `build/Build/Products/Release/TodoMenuBar.app`, and the
DMG at `dist/TodoMenuBar.dmg`.

## Screenshot

_Add a screenshot here after your first run._

## License

MIT — see [LICENSE](LICENSE).

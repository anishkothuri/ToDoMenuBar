#!/usr/bin/env bash
set -euo pipefail

PROJECT_NAME="TodoMenuBar"
CONFIGURATION="Release"
APP_PATH="build/Build/Products/$CONFIGURATION/$PROJECT_NAME.app"
DIST_DIR="dist"
DMG_PATH="$DIST_DIR/$PROJECT_NAME.dmg"

if [ ! -d "$APP_PATH" ]; then
  echo "Run scripts/build.sh first — $APP_PATH not found"
  exit 1
fi

echo "==> Preparing DMG staging folder"
rm -rf "$DIST_DIR"
mkdir -p "$DIST_DIR/dmg-root"
cp -R "$APP_PATH" "$DIST_DIR/dmg-root/"
ln -s /Applications "$DIST_DIR/dmg-root/Applications"

echo "==> Creating $DMG_PATH"
hdiutil create -volname "$PROJECT_NAME" \
  -srcfolder "$DIST_DIR/dmg-root" \
  -ov -format UDZO \
  "$DMG_PATH"

rm -rf "$DIST_DIR/dmg-root"
echo "==> Done: $DMG_PATH"

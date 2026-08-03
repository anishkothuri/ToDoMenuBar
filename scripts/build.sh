#!/usr/bin/env bash
set -euo pipefail

PROJECT_NAME="TodoMenuBar"
SCHEME="TodoMenuBar"
CONFIGURATION="Release"
BUILD_DIR="build"

echo "==> Regenerating Xcode project with XcodeGen"
if ! command -v xcodegen >/dev/null 2>&1; then
  echo "xcodegen not found — installing via Homebrew"
  brew install xcodegen
fi
xcodegen generate

echo "==> Building $SCHEME ($CONFIGURATION)"
rm -rf "$BUILD_DIR"
xcodebuild \
  -project "$PROJECT_NAME.xcodeproj" \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -derivedDataPath "$BUILD_DIR" \
  CODE_SIGN_IDENTITY="-" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=YES \
  build

APP_PATH="$BUILD_DIR/Build/Products/$CONFIGURATION/$PROJECT_NAME.app"
if [ ! -d "$APP_PATH" ]; then
  echo "Build failed: $APP_PATH not found"
  exit 1
fi

echo "==> Ad-hoc code signing $APP_PATH"
codesign --force --deep --sign - "$APP_PATH"
codesign --verify --verbose "$APP_PATH"

echo "==> Built: $APP_PATH"

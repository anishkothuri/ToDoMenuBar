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

# Optional version overrides (set by CI so each release gets a distinct,
# bumped version). Local builds are unaffected — project.yml's defaults
# (MARKETING_VERSION 1.0, CURRENT_PROJECT_VERSION 1) apply when unset.
VERSION_SETTINGS=()
if [ -n "${APP_MARKETING_VERSION:-}" ]; then
  VERSION_SETTINGS+=(MARKETING_VERSION="$APP_MARKETING_VERSION")
fi
if [ -n "${APP_BUILD_NUMBER:-}" ]; then
  VERSION_SETTINGS+=(CURRENT_PROJECT_VERSION="$APP_BUILD_NUMBER")
fi

xcodebuild \
  -project "$PROJECT_NAME.xcodeproj" \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -derivedDataPath "$BUILD_DIR" \
  CODE_SIGN_IDENTITY="-" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=YES \
  ${VERSION_SETTINGS[@]+"${VERSION_SETTINGS[@]}"} \
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

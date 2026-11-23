#!/usr/bin/env bash
set -e

VERSION="${1:-v1.0.0}"
SOURCE_DIR="$HOME/.config/heroic/tools/proton/dwproton-11.0-16-x86_64"
DIST_DIR="$(pwd)/dist"
ARCHIVE_NAME="dwproton-custom-${VERSION}.tar.zst"

echo "=== Packaging dwproton-custom ($VERSION) ==="

mkdir -p "$DIST_DIR"

# Ensure repo files are synced with the runner
cp -v proton "$SOURCE_DIR/proton"
cp -v compatibilitytool.vdf "$SOURCE_DIR/compatibilitytool.vdf"

echo "Compressing $SOURCE_DIR into $DIST_DIR/$ARCHIVE_NAME..."
tar -C "$(dirname "$SOURCE_DIR")" \
    --transform "s|^$(basename "$SOURCE_DIR")|dwproton-custom|" \
    -cf - "$(basename "$SOURCE_DIR")" | zstd -T0 -15 -o "$DIST_DIR/$ARCHIVE_NAME"

echo "Package created at: $DIST_DIR/$ARCHIVE_NAME"
ls -lh "$DIST_DIR/$ARCHIVE_NAME"

RELEASE_NOTES="${2:-Release $VERSION of dwproton-custom:
- Auto-inject Steam Overlay renderer (LD_PRELOAD with gameoverlayrenderer.so and Vulkan overlay layers).
- Fix 'Steam Overlay is not enabled' error (resolved missing 32-bit GameOverlayRenderer.dll check returning 0x31).
- Automatically symlink Steam userdata/ and config/ into Wine prefix for persistent settings and licenses.
- Pre-configured Online-Fix DLL overrides (OnlineFix64, steam_api64, SteamOverlay64, winmm, dnet, winhttp).
- Built-in steamclient64.dll and Steam libraries to fix Error 126 in standalone prefixes.
- Wine registry steam:// protocol forwarding to host Linux Steam client.}"

echo "=== Uploading release with gh CLI ==="
gh release create "$VERSION" "$DIST_DIR/$ARCHIVE_NAME" \
    --title "dwproton-custom $VERSION" \
    --notes "$RELEASE_NOTES"

echo "Release $VERSION successfully published!"

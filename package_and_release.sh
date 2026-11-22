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
tar -C "$(dirname "$SOURCE_DIR")" -cf - "$(basename "$SOURCE_DIR")" | zstd -T0 -15 -o "$DIST_DIR/$ARCHIVE_NAME"

echo "Package created at: $DIST_DIR/$ARCHIVE_NAME"
ls -lh "$DIST_DIR/$ARCHIVE_NAME"

echo "=== Uploading release with gh CLI ==="
gh release create "$VERSION" "$DIST_DIR/$ARCHIVE_NAME" \
    --title "dwproton-custom $VERSION" \
    --notes "Release $VERSION of dwproton-custom with OnlineFix support, automatic Steam client integration, and Genshin Impact compatibility."

echo "Release $VERSION successfully published!"

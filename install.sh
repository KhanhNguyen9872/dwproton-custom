#!/usr/bin/env bash
set -e

REPO="KhanhNguyen9872/dwproton-custom"
HEROIC_DIR="$HOME/.config/heroic/tools/proton"
STEAM_DIR="$HOME/.steam/root/compatibilitytools.d"
INSTALL_NAME="dwproton-custom"

echo "=== dwproton-custom Installer ==="

# Determine target directories
mkdir -p "$HEROIC_DIR"
if [ -d "$HOME/.steam/root" ]; then
    mkdir -p "$STEAM_DIR"
fi

# Fetch latest release URL from GitHub API
echo "Fetching latest release from GitHub..."
LATEST_RELEASE=$(curl -s "https://api.github.com/repos/$REPO/releases/latest")
DOWNLOAD_URL=$(echo "$LATEST_RELEASE" | grep -o 'https://[^"]*dwproton-custom[^"]*\.tar\.zst' | head -n 1)

if [ -z "$DOWNLOAD_URL" ]; then
    echo "Warning: No .tar.zst asset found, checking for .tar.xz..."
    DOWNLOAD_URL=$(echo "$LATEST_RELEASE" | grep -o 'https://[^"]*dwproton-custom[^"]*\.tar\.xz' | head -n 1)
fi

if [ -z "$DOWNLOAD_URL" ]; then
    echo "Error: Could not find release archive on GitHub."
    echo "Please check: https://github.com/$REPO/releases"
    exit 1
fi

TEMP_DIR=$(mktemp -d)
ARCHIVE_PATH="$TEMP_DIR/dwproton-custom.tar"

echo "Downloading from: $DOWNLOAD_URL..."
if [[ "$DOWNLOAD_URL" == *".tar.zst" ]]; then
    curl -L "$DOWNLOAD_URL" | zstd -d > "$ARCHIVE_PATH"
else
    curl -L -o "$ARCHIVE_PATH" "$DOWNLOAD_URL"
fi

echo "Extracting to Heroic tools: $HEROIC_DIR/$INSTALL_NAME..."
rm -rf "$HEROIC_DIR/$INSTALL_NAME"
mkdir -p "$HEROIC_DIR/$INSTALL_NAME"
tar -xf "$ARCHIVE_PATH" -C "$HEROIC_DIR/$INSTALL_NAME" --strip-components=1

if [ -d "$HOME/.steam/root" ]; then
    echo "Linking to Steam compatibility tools: $STEAM_DIR/$INSTALL_NAME..."
    rm -rf "$STEAM_DIR/$INSTALL_NAME"
    ln -sfn "$HEROIC_DIR/$INSTALL_NAME" "$STEAM_DIR/$INSTALL_NAME"
fi

rm -rf "$TEMP_DIR"

echo "=== Installation Complete! ==="
echo "dwproton-custom is ready to use in Heroic Games Launcher and Steam."

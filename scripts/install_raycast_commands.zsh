#!/usr/bin/env zsh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_DIR="$REPO_DIR/config/raycast"

# Raycast "Script Commands" folder can be changed in Raycast settings.
# Override this path by exporting RAYCAST_COMMANDS_DIR before running.
TARGET_DIR="${RAYCAST_COMMANDS_DIR:-$HOME/Documents/Raycast Script Commands/dom.dotfiles}"

BUILD_SRC="$SOURCE_DIR/quartz-build.sh"
PUBLISH_SRC="$SOURCE_DIR/quartz-publish.sh"
BUILD_DST="$TARGET_DIR/quartz-build.sh"
PUBLISH_DST="$TARGET_DIR/quartz-publish.sh"

[[ -f "$BUILD_SRC" ]] || { echo "error: missing $BUILD_SRC" >&2; exit 1; }
[[ -f "$PUBLISH_SRC" ]] || { echo "error: missing $PUBLISH_SRC" >&2; exit 1; }

mkdir -p "$TARGET_DIR"

ln -sfn "$BUILD_SRC" "$BUILD_DST"
ln -sfn "$PUBLISH_SRC" "$PUBLISH_DST"

chmod +x "$BUILD_SRC" "$PUBLISH_SRC"

echo "[raycast] Linked script commands:"
echo "  $BUILD_DST -> $BUILD_SRC"
echo "  $PUBLISH_DST -> $PUBLISH_SRC"
echo
echo "[raycast] In Raycast:"
echo "  1) Open Settings -> Extensions -> Script Commands"
echo "  2) Set Script Commands directory to:"
echo "     $TARGET_DIR"

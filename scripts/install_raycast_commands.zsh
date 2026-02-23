#!/usr/bin/env zsh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCE_DIR="$REPO_DIR/config/raycast"

# Raycast "Script Commands" folder can be changed in Raycast settings.
# Override this path by exporting RAYCAST_COMMANDS_DIR before running.
TARGET_DIR="${RAYCAST_COMMANDS_DIR:-$HOME/Documents/Raycast Script Commands/dom.dotfiles}"

mkdir -p "$TARGET_DIR"
linked_count=0

for script_path in "$SOURCE_DIR"/*.sh; do
  [[ -e "$script_path" ]] || continue
  script_name="$(basename "$script_path")"
  target_path="$TARGET_DIR/$script_name"

  chmod +x "$script_path"
  ln -sfn "$script_path" "$target_path"

  echo "[raycast] Linked: $target_path -> $script_path"
  linked_count=$((linked_count + 1))
done

if [[ "$linked_count" -eq 0 ]]; then
  echo "error: no raycast scripts found in $SOURCE_DIR" >&2
  exit 1
fi

echo
echo "[raycast] Linked $linked_count script command(s)."
echo
echo "[raycast] In Raycast:"
echo "  1) Open Settings -> Extensions -> Script Commands"
echo "  2) Set Script Commands directory to:"
echo "     $TARGET_DIR"

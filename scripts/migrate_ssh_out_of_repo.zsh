#!/usr/bin/env zsh

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_CONFIG="$DOTFILES_DIR/ssh/config"
SSH_PATH="$HOME/.ssh"
BACKUP_PATH="$HOME/.ssh.backup.$(date +%Y%m%d-%H%M%S)"
TMP_PATH="$HOME/.ssh.real.$(date +%Y%m%d-%H%M%S)"

if [[ ! -L "$SSH_PATH" ]]; then
  echo "~/.ssh is not a symlink. No migration needed."
  if [[ -f "$TARGET_CONFIG" ]]; then
    ln -sfn "$TARGET_CONFIG" "$SSH_PATH/config"
    echo "Linked ~/.ssh/config -> $TARGET_CONFIG"
  fi
  exit 0
fi

SOURCE_PATH="$(readlink "$SSH_PATH")"

mkdir -p "$TMP_PATH"
cp -a "$SOURCE_PATH"/. "$TMP_PATH"/

mv "$SSH_PATH" "$BACKUP_PATH"
mv "$TMP_PATH" "$SSH_PATH"

chmod 700 "$SSH_PATH"
find "$SSH_PATH" -type f -name "id_*" -exec chmod 600 {} \;

if [[ -f "$TARGET_CONFIG" ]]; then
  ln -sfn "$TARGET_CONFIG" "$SSH_PATH/config"
fi

echo "Migrated ~/.ssh to a real directory."
echo "Backup symlink saved at: $BACKUP_PATH"
echo "Active ~/.ssh path: $SSH_PATH"

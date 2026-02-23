#!/usr/bin/env zsh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
BREWFILE_PATH="$REPO_DIR/Brewfile"

brew_mode="${DOTFILES_INSTALL_BREW:-0}"
brew_mode="${brew_mode:l}"

if [[ "$brew_mode" != "1" && "$brew_mode" != "true" && "$brew_mode" != "yes" && "$brew_mode" != "on" ]]; then
  echo "[homebrew] DOTFILES_INSTALL_BREW is not enabled; skipping brew bundle."
  exit 0
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "[homebrew] Homebrew not found. Installing..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Ensure brew is on PATH for both Apple Silicon and Intel macOS.
if [[ -x "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x "/usr/local/bin/brew" ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Ignore stale shell overrides from legacy dual-brew setups.
unset HOMEBREW_PREFIX HOMEBREW_CELLAR

if [[ -f "$BREWFILE_PATH" ]]; then
  echo "[homebrew] Applying Brewfile: $BREWFILE_PATH"
  brew bundle --file="$BREWFILE_PATH" --no-upgrade
else
  echo "[homebrew] Brewfile not found at $BREWFILE_PATH; skipping brew bundle."
fi

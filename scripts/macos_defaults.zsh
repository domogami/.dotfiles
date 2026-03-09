#!/usr/bin/env zsh

set -euo pipefail

if [[ "${OSTYPE:-}" != darwin* ]]; then
  echo "[defaults] Non-macOS host detected; skipping."
  exit 0
fi

apply_mode="${DOTFILES_APPLY_DEFAULTS:-1}"
apply_mode="${apply_mode:l}"

case "$apply_mode" in
  1|true|yes|on)
    ;;
  0|false|no|off)
    echo "[defaults] DOTFILES_APPLY_DEFAULTS is disabled; skipping."
    exit 0
    ;;
  *)
    echo "[defaults] Invalid DOTFILES_APPLY_DEFAULTS value: ${DOTFILES_APPLY_DEFAULTS:-}"
    echo "[defaults] Use one of: 1/0, true/false, yes/no, on/off."
    exit 1
    ;;
esac

defaults_changed=0
last_apply_changed=0

normalize_bool() {
  local raw="$1"
  case "${raw:l}" in
    1|true|yes|on)
      printf 'true'
      ;;
    0|false|no|off)
      printf 'false'
      ;;
    *)
      printf '%s' "${raw:l}"
      ;;
  esac
}

apply_bool() {
  local domain="$1"
  local key="$2"
  local value="$3"
  local current
  local wanted

  last_apply_changed=0
  wanted="$(normalize_bool "$value")"
  if current="$(defaults read "$domain" "$key" 2>/dev/null)"; then
    if [[ "$(normalize_bool "$current")" == "$wanted" ]]; then
      echo "[defaults] unchanged: $domain $key=$value"
      return 0
    fi
  fi

  defaults write "$domain" "$key" -bool "$value"
  defaults_changed=1
  last_apply_changed=1
  echo "[defaults] set:       $domain $key=$value"
}

apply_int() {
  local domain="$1"
  local key="$2"
  local value="$3"
  local current

  last_apply_changed=0
  if current="$(defaults read "$domain" "$key" 2>/dev/null)"; then
    if [[ "$current" == "$value" ]]; then
      echo "[defaults] unchanged: $domain $key=$value"
      return 0
    fi
  fi

  defaults write "$domain" "$key" -int "$value"
  defaults_changed=1
  last_apply_changed=1
  echo "[defaults] set:       $domain $key=$value"
}

apply_string() {
  local domain="$1"
  local key="$2"
  local value="$3"
  local current

  last_apply_changed=0
  if current="$(defaults read "$domain" "$key" 2>/dev/null)"; then
    if [[ "$current" == "$value" ]]; then
      echo "[defaults] unchanged: $domain $key=$value"
      return 0
    fi
  fi

  defaults write "$domain" "$key" -string "$value"
  defaults_changed=1
  last_apply_changed=1
  echo "[defaults] set:       $domain $key=$value"
}

apply_float() {
  local domain="$1"
  local key="$2"
  local value="$3"
  local current

  last_apply_changed=0
  if current="$(defaults read "$domain" "$key" 2>/dev/null)"; then
    if [[ "$current" == "$value" ]]; then
      echo "[defaults] unchanged: $domain $key=$value"
      return 0
    fi
  fi

  defaults write "$domain" "$key" -float "$value"
  defaults_changed=1
  last_apply_changed=1
  echo "[defaults] set:       $domain $key=$value"
}

echo "[defaults] Applying managed macOS defaults..."

# Managed defaults
apply_bool -g ApplePressAndHoldEnabled false

finder_defaults_changed=0
apply_bool com.apple.finder ShowStatusBar true
if [[ "$last_apply_changed" == "1" ]]; then
  finder_defaults_changed=1
fi
apply_bool com.apple.finder FXEnableExtensionChangeWarning false
if [[ "$last_apply_changed" == "1" ]]; then
  finder_defaults_changed=1
fi
if [[ "$finder_defaults_changed" == "1" ]]; then
  echo "[defaults] Restarting Finder to apply Finder defaults..."
  killall Finder >/dev/null 2>&1 || true
fi

dock_defaults_changed=0
# AeroSpace note on Mission Control:
# https://nikitabobko.github.io/AeroSpace/guide#a-note-on-mission-control
apply_bool com.apple.dock expose-group-apps true
if [[ "$last_apply_changed" == "1" ]]; then
  dock_defaults_changed=1
fi
apply_float com.apple.dock autohide-time-modifier 0
if [[ "$last_apply_changed" == "1" ]]; then
  dock_defaults_changed=1
fi
if [[ "$dock_defaults_changed" == "1" ]]; then
  echo "[defaults] Restarting Dock to apply Dock defaults..."
  killall Dock >/dev/null 2>&1 || true
fi

# Add custom defaults below as needed, for example:
# apply_int -g KeyRepeat 2
# apply_int -g InitialKeyRepeat 15
# apply_bool com.apple.finder AppleShowAllFiles true
# apply_bool com.apple.finder ShowStatusBar true
# apply_bool com.apple.finder FXEnableExtensionChangeWarning false
# apply_float com.apple.dock autohide-time-modifier 0.15
# apply_string com.apple.screencapture location "$HOME/Desktop"

if [[ "$defaults_changed" == "1" ]]; then
  echo "[defaults] Changes applied. Restart affected apps (or log out/in) if needed."
else
  echo "[defaults] No changes were needed."
fi

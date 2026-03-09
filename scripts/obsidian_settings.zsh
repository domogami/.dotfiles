#!/usr/bin/env zsh

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DEFAULT_VAULT_OBSIDIAN_DIR="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Dom's 2nd Brain/.obsidian"
DEFAULT_REPO_OBSIDIAN_DIR="$DOTFILES_DIR/obsidian/dom-2nd-brain/.obsidian"

VAULT_OBSIDIAN_DIR="${VAULT_OBSIDIAN_DIR:-$DEFAULT_VAULT_OBSIDIAN_DIR}"
REPO_OBSIDIAN_DIR="${REPO_OBSIDIAN_DIR:-$DEFAULT_REPO_OBSIDIAN_DIR}"

typeset -a SETTINGS_FILES=(
  app.json
  appearance.json
  community-plugins.json
  core-plugins-migration.json
  core-plugins.json
  daily-notes.json
  graph.json
  hotkeys.json
  templates.json
  plugins/obsidian-style-settings/data.json
)

typeset -a SETTINGS_DIRS=(
  snippets
)

usage() {
  cat <<'EOF'
Usage:
  scripts/obsidian_settings.zsh snapshot
  scripts/obsidian_settings.zsh link
  scripts/obsidian_settings.zsh status

Environment overrides:
  VAULT_OBSIDIAN_DIR=/absolute/path/to/vault/.obsidian
  REPO_OBSIDIAN_DIR=/absolute/path/to/repo/obsidian/.obsidian
EOF
}

ensure_paths() {
  if [[ ! -d "$VAULT_OBSIDIAN_DIR" ]]; then
    echo "Vault .obsidian directory not found: $VAULT_OBSIDIAN_DIR" >&2
    exit 1
  fi
  mkdir -p "$REPO_OBSIDIAN_DIR"
}

snapshot() {
  ensure_paths

  local file repo_parent
  for file in "${SETTINGS_FILES[@]}"; do
    if [[ -f "$VAULT_OBSIDIAN_DIR/$file" ]]; then
      repo_parent="$(dirname "$REPO_OBSIDIAN_DIR/$file")"
      mkdir -p "$repo_parent"
      cp "$VAULT_OBSIDIAN_DIR/$file" "$REPO_OBSIDIAN_DIR/$file"
      echo "snapshot: $file"
    fi
  done

  local dir repo_dir_parent
  for dir in "${SETTINGS_DIRS[@]}"; do
    if [[ -d "$VAULT_OBSIDIAN_DIR/$dir" ]]; then
      repo_dir_parent="$(dirname "$REPO_OBSIDIAN_DIR/$dir")"
      mkdir -p "$repo_dir_parent"
      rm -rf "$REPO_OBSIDIAN_DIR/$dir"
      cp -R "$VAULT_OBSIDIAN_DIR/$dir" "$REPO_OBSIDIAN_DIR/$dir"
      echo "snapshot: $dir/"
    fi
  done
}

link_with_backup() {
  ensure_paths

  local backup_root="$VAULT_OBSIDIAN_DIR/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
  local src dst parent backup_parent
  local had_backup=0

  local file
  for file in "${SETTINGS_FILES[@]}"; do
    src="$REPO_OBSIDIAN_DIR/$file"
    dst="$VAULT_OBSIDIAN_DIR/$file"
    parent="$(dirname "$dst")"
    mkdir -p "$parent"

    if [[ ! -e "$src" ]]; then
      continue
    fi

    if [[ -e "$dst" && ! -L "$dst" ]]; then
      if ! cmp -s "$src" "$dst"; then
        backup_parent="$(dirname "$backup_root/$file")"
        mkdir -p "$backup_parent"
        mv "$dst" "$backup_root/$file"
        had_backup=1
        echo "backup: $file"
      else
        rm -f "$dst"
      fi
    elif [[ -L "$dst" ]]; then
      rm -f "$dst"
    fi

    ln -s "$src" "$dst"
    echo "link: $file"
  done

  local dir
  for dir in "${SETTINGS_DIRS[@]}"; do
    src="$REPO_OBSIDIAN_DIR/$dir"
    dst="$VAULT_OBSIDIAN_DIR/$dir"

    if [[ ! -e "$src" ]]; then
      continue
    fi

    if [[ -e "$dst" && ! -L "$dst" ]]; then
      backup_parent="$(dirname "$backup_root/$dir")"
      mkdir -p "$backup_parent"
      mv "$dst" "$backup_root/$dir"
      had_backup=1
      echo "backup: $dir/"
    elif [[ -L "$dst" ]]; then
      rm -f "$dst"
    fi

    ln -s "$src" "$dst"
    echo "link: $dir/"
  done

  if [[ "$had_backup" -eq 1 ]]; then
    echo "Backups written to: $backup_root"
  fi
}

status() {
  ensure_paths

  local rel src dst
  for rel in "${SETTINGS_FILES[@]}" "${SETTINGS_DIRS[@]}"; do
    src="$REPO_OBSIDIAN_DIR/$rel"
    dst="$VAULT_OBSIDIAN_DIR/$rel"

    if [[ -L "$dst" ]]; then
      echo "$rel -> $(readlink "$dst")"
    elif [[ -e "$dst" ]]; then
      echo "$rel (not symlinked)"
    else
      echo "$rel (missing)"
    fi

    if [[ ! -e "$src" ]]; then
      echo "  repo source missing: $src"
    fi
  done
}

case "${1:-}" in
  snapshot) snapshot ;;
  link) link_with_backup ;;
  status) status ;;
  *) usage; exit 1 ;;
esac

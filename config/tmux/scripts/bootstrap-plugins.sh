#!/usr/bin/env bash

set -eu

plugin_root="${TMUX_PLUGIN_MANAGER_PATH%/}"
if [[ -z "${plugin_root:-}" ]]; then
  plugin_root="${XDG_DATA_HOME:-$HOME/.local/share}/tmux/plugins"
fi

tpm_dir="${plugin_root}/tpm"

command -v git >/dev/null 2>&1 || exit 0
command -v tmux >/dev/null 2>&1 || exit 0

mkdir -p "$plugin_root"

if [[ ! -x "$tpm_dir/tpm" ]]; then
  GIT_TERMINAL_PROMPT=0 git clone --depth 1 https://github.com/tmux-plugins/tpm "$tpm_dir" >/dev/null 2>&1 || exit 0
fi

"$tpm_dir/bin/install_plugins" >/dev/null 2>&1 || true

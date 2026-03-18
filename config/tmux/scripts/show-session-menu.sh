#!/usr/bin/env bash

set -euo pipefail

menu_title="tmux sessions"
x="${1:-R}"
y="${2:-P}"

keys=(1 2 3 4 5 6 7 8 9 0 a b c d e f g h i j k l m n o p q r s t u v w x y z)

mapfile -t sessions < <(
  tmux list-sessions -F '#{session_id}\t#{session_name}\t#{?session_attached,attached,detached}\t#{session_windows}' 2>/dev/null
)

if ((${#sessions[@]} == 0)); then
  tmux display-message "No tmux sessions found"
  exit 0
fi

cmd=(tmux display-menu -T "$menu_title" -x "$x" -y "$y")

for i in "${!sessions[@]}"; do
  IFS=$'\t' read -r session_id session_name session_state session_windows <<<"${sessions[$i]}"

  marker="○"
  if [[ "$session_state" == "attached" ]]; then
    marker="●"
  fi

  label="${marker} ${session_name} (${session_windows})"
  key=""
  if ((i < ${#keys[@]})); then
    key="${keys[$i]}"
  fi

  cmd+=("$label" "$key" "switch-client -t ${session_id}")
done

cmd+=("" "" "")
cmd+=("tree view" "t" "choose-tree -Zs")
cmd+=("new session" "n" "command-prompt -p 'new session name' 'new-session -Ad -s \"%%\" \\; switch-client -t \"%%\"'")

"${cmd[@]}"

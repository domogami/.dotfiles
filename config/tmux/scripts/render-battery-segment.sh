#!/usr/bin/env bash

set -euo pipefail

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BATTERY_PLUGIN_DIR="$CURRENT_DIR/../plugins/tmux-battery/scripts"

source "$BATTERY_PLUGIN_DIR/helpers.sh"

percentage_raw="$("$BATTERY_PLUGIN_DIR/battery_percentage.sh" 2>/dev/null || true)"
percentage="$(printf '%s\n' "$percentage_raw" | sed -n '1{s/%//;p;}')"

if [[ -z "$percentage" ]]; then
  exit 0
fi

status="$(battery_status 2>/dev/null || true)"

edge_color="#7A9C61"
main_color="#98c379"
if (( percentage <= 30 )); then
  edge_color="#ff6c6b"
  main_color="#ff7b7a"
elif (( percentage <= 60 )); then
  edge_color="#d19a66"
  main_color="#e5c07b"
fi

icon="􀛪"
if (( percentage >= 100 )); then
  icon="􀛨"
elif [[ "$status" == charging* ]]; then
  icon="􀢋"
elif (( percentage > 80 )); then
  icon="􀛨"
elif (( percentage > 60 )); then
  icon="􀺸"
elif (( percentage > 30 )); then
  icon="􀺶"
elif (( percentage > 15 )); then
  icon="􀛩"
fi

printf '#[fg=%s]⌈#[fg=%s] %s  %s%% #[fg=%s]⌋' \
  "$edge_color" \
  "$main_color" \
  "$icon" \
  "$percentage" \
  "$edge_color"

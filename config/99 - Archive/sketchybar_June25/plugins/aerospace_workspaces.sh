#!/usr/bin/env bash

# Assumes CONFIG_DIR is set (e.g. via start.sh)
source "$CONFIG_DIR/icons.sh"
source "$CONFIG_DIR/colors.sh"

SID="$1"
FOCUSED=$(aerospace list-workspaces --focused)
apps=$(aerospace list-windows --workspace "$SID" |
  awk -F '\\| *' '{print $2}') # extracts app names

icons=""
for app in $apps; do
  icons+=$(workspace_icons "$app")
done

# Construct the arguments to sketchybar
props=(
  label="$icons"
  label.drawing=$([ -n "$icons" ] && echo "on" || echo "off")
)

if [ "$SID" = "$FOCUSED" ]; then
  props+=(
    background.drawing=on
    label.color="$active_fg_color"
  )
else
  props+=(
    background.drawing=off
    label.color="$inactive_fg_color"
  )
fi

sketchybar --set space."$SID" "${props[@]}"

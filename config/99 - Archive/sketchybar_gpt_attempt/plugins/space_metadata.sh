#!/usr/bin/env bash

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"

# First, loop and set metadata for each workspace item...
for sid in $(aerospace list-workspaces --all); do
  # grab the apps in that ws
  apps=( $(aerospace list-windows --workspace "$sid" \
    | awk -F '\| *' '{print $2}') )

  # shove that onto the workspace.$sid item
  sketchybar --set workspace.$sid \
    env.INFO.space="$sid" \
    env.INFO.apps="${apps[*]}"
done

# Then fire both events once
sketchybar --trigger aerospace_workspace_change
sketchybar --trigger space_windows_change
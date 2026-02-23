#!/usr/bin/env bash

# Triggered by `sketchybar --trigger space_windows_change`
for sid in $(aerospace list-workspaces --all); do
  apps=$(aerospace list-windows --workspace "$sid" | awk -F '\| *' '{print $2}')
  metadata=""
  for app in $apps; do
    metadata+=" $app"
  done

  sketchybar --set space.$sid \
    env.INFO.space="$sid" \
    env.INFO.apps="$metadata"
done
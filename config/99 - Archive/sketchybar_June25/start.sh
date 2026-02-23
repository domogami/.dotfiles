#!/bin/bash

# Set this to your sketchybar config directory
export CONFIG_DIR="$HOME/.config/sketchybar"

# Custom event to listen to
sketchybar --add event aerospace_workspace_change

# Remove existing dynamic space items (optional clean slate)
for id in $(sketchybar --query | jq -r '.items[] | select(.name | startswith("space.")) | .name'); do
  sketchybar --remove item "$id"
done

# Register all workspaces
for sid in $(aerospace list-workspaces --all); do
  sketchybar --add item space.$sid left \
    --subscribe space.$sid aerospace_workspace_change \
    --set space.$sid \
    background.color=0x44ffffff \
    background.corner_radius=5 \
    background.height=20 \
    background.drawing=off \
    label="$sid" \
    click_script="aerospace workspace $sid" \
    script="$CONFIG_DIR/plugins/aerospace.sh $sid"
done

# Subscribe each item to updates
sketchybar --add event aerospace_workspace_change

for sid in $(aerospace list-workspaces --all); do
  sketchybar --add item space.$sid left \
    --set space.$sid \
    icon="$sid" \
    script="$CONFIG_DIR/plugins/aerospace_workspaces.sh $sid" \
    label.drawing=off \
    --subscribe space.$sid aerospace_workspace_change
done

#!/bin/bash

SID=$1
FOCUSED=$(aerospace focused-workspace)

if [ "$SID" = "$FOCUSED" ]; then
  sketchybar --set space.$SID background.drawing=on label.drawing=on
else
  sketchybar --set space.$SID background.drawing=off label.drawing=on
fi

#!/bin/bash

# W I N D O W  T I T L E
WINDOW_TITLE=$(/opt/homebrew/bin/aerospace list-windows --focused | cut -f3 -d '|')

if [[ ${#WINDOW_TITLE} -gt 150 ]]; then
  WINDOW_TITLE=$(echo "$WINDOW_TITLE" | cut -c 1-50)
  sketchybar -m --set title label="┆   $WINDOW_TITLE"…
  exit 0
fi

sketchybar -m --set title label="┆   $WINDOW_TITLE"

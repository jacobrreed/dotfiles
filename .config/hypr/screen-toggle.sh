#!/bin/bash
INTERNAL_MONITOR="DP-1"
EXTERNAL_MONITOR="DP-2"
WORKSPACES_TO_MOVE=(1 10 11)

move_all_workspaces_to_monitor() {
  for workspace in "${WORKSPACES_TO_MOVE[@]}"; do
    echo "$1"
    hyprctl dispatch moveworkspacetomonitor "$workspace" "$1"
    exit
  done
}

disable_monitor() {
  hyprctl keyword monitor "DP-1, disable"
}

enable_monitor() {
  hyprctl keyword monitor "DP-1,3440x1440@143.92,1440x1440,1.0"
}

if [ "$1" = "on" ]; then
  enable_monitor
  move_all_workspaces_to_monitor "$INTERNAL_MONITOR"
  exit
else
  disable_monitor
  move_all_workspaces_to_monitor "$EXTERNAL_MONITOR"
  exit
fi

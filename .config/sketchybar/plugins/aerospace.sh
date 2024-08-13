#!/usr/bin/env bash

if [ "$1" = "1" ]; then
  sketchybar --set $NAME label=" "
elif [ "$1" = "2" ]; then
  sketchybar --set $NAME label=" "
elif [ "$1" = "3" ]; then
  sketchybar --set $NAME label="󰇮 "
elif [ "$1" = "4" ]; then
  sketchybar --set $NAME label=" "
elif [ "$1" = "s" ]; then
  sketchybar --set $NAME label=" "
fi

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set $NAME label.color=0xff37f499
else
  sketchybar --set $NAME label.color=0xff04d1f9
fi

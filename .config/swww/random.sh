#!/bin/bash

# This script will randomly go through the files of a directory, setting it
# up as the wallpaper at regular intervals
#
# NOTE: this script is in bash (not posix shell), because the RANDOM variable
# we use is not defined in posix

# Edit bellow to control the images transition
export SWWW_TRANSITION_FPS=60
export SWWW_TRANSITION_STEP=20
export SWWW_TRANSITION="wipe"

# This controls (in seconds) when to switch to the next image
INTERVAL=60

#perform cleanup and exit
if ! swww query; then
    swww init
fi

while true; do
  find "$HOME/pics/" -type f -exec file {} \; | awk -F: '{ if ($2 ~/[Ii]mage|EPS/) print $1}' \
		| while read -r img; do
			echo "$((RANDOM % 1000)):$img"
		done \
		| sort -n | cut -d':' -f2- \
		| while read -r img; do
			swww img "$img"
			sleep $INTERVAL
		done
done


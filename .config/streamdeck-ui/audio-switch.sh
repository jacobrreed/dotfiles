#!/bin/bash
# filepath: audio-switch.sh

# Get device IDs by name (extract first number-dot at line start)
device1=$(wpctl status | awk '/Sinks:/ {found=1; next} /Sources:/ {found=0} found && tolower($0) ~ /schiit unison modius es analog stereo/ {match($0, /[* ]*([0-9]+)\./, arr); print arr[1]}')
device2=$(wpctl status | awk '/Sinks:/ {found=1; next} /Sources:/ {found=0} found && tolower($0) ~ /g560 gaming speaker analog stereo/ {match($0, /[* ]*([0-9]+)\./, arr); print arr[1]}')

# Get current default sink ID
current=$(wpctl status | awk '/Sinks:/, /Sources:/ {if ($2 == "*") {gsub(/\./, "", $3); print $3}}' | xargs)

if [ "$current" == "$device1" ]; then
  wpctl set-default "$device2"
else
  wpctl set-default "$device1"
fi

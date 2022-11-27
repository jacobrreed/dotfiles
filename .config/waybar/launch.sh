#!/usr/bin/bash

killall -q waybar

# env GTK_DEBUG=interactive
waybar -l info -c ~/.config/waybar/config -s ~/.config/waybar/style.css > /tmp/waybar.log 2>&1 & disown

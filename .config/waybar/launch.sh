#!/usr/bin/bash

killall -q waybar

waybar  2>&1 & disown

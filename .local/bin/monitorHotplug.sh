#!/bin/zsh

# Get out of town if something errors
set -e

VGA_STATUS=$(less /sys/class/drm/card0/card0-VGA-1/status )

if [[ "connected" == "$VGA_STATUS" ]]; then
	/usr/bin/xrandr --output VGA1 --above LVDS1 --auto
	/usr/bin/notify-send --urgency=low -t 5000 "Graphics Update" "VGA plugged in\nAbove mode"
else
	/usr/bin/xrandr --output VGA1 --off
	/usr/bin/notify-send --urgency=low -t 5000 "Graphics Update" "External monitor disconnected" 
	exit
fi

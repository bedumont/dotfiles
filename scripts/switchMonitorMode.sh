#!/bin/zsh

# Get out of town if something errors
set -e

LVDS_STATUS=$(less /sys/class/drm/card0/card0-LVDS-1/status )
VGA_STATUS=$(less /sys/class/drm/card0/card0-VGA-1/status )

LVDS_ENABLED=$(less /sys/class/drm/card0/card0-LVDS-1/enabled )
VGA_ENABLED=$(less /sys/class/drm/card0/card0-VGA-1/enabled )

# Check to see if the state log exists
if [[ ! -f /tmp/monitor ]]; then
	touch /tmp/monitor
	STATE=5
else
	STATE=$(</tmp/monitor)
fi

if [[ "disconnected" == "$VGA_STATUS" ]]; then
	STATE=1
fi

case $STATE in
	1)
	#LVDS is on, external monitor is not connected
	/usr/bin/xrandr --output LVDS1 --auto
	STATE=2
	;;
2)
	#LVDS is on, external monitor is connected but inactive
	/usr/bin/xrandr --output LVDS1 --auto --output VGA1 --off
	STATE=3
	;;
3)
	#LVDS is off, external monitor is on
	/usr/bin/xrandr --output LVDS1 --off --output VGA1 --auto
	/usr/bin/notify-send -t 5000 --urgency=low "Graphics update" "Switched to VGA"
	STATE=4
	;;
4)
	#LVDS is on, external monitor is mirroring
	/usr/bin/xrandr --output LVDS1 --auto --output VGA1 --auto
	/usr/bin/notify-send -t 5000 --urgency=low "Graphics update" "Switched to VGA mirroring"
	STATE=5
	;;
5)
	#LVDS is on, external monitor is extending above
	/usr/bin/xrandr --output LVDS1 --auto --output VGA1 --above LVDS1
	/usr/bin/notify-send -t 5000 --urgency=low "Graphics update" "Switched to VGA above"
	STATE=6
	;;
6)
	#LVDS is on, external monitor is extending left
	/usr/bin/xrandr --output LVDS1 --auto --output VGA1 --left-of LVDS1
	/usr/bin/notify-send -t 5000 --urgency=low "Graphics update" "Switched to VGA left"
	STATE=7
	;;
7)
	#LVDS is on, external monitor is extending right
	/usr/bin/xrandr --output LVDS1 --auto --output VGA1 --right-of LVDS1
	/usr/bin/notify-send -t 5000 --urgency=low "Graphics update" "Switched to VGA right"
	STATE=2
	;;
*)
	#Unknown state, assume we're in 1
	STATE=1
esac

echo $STATE > /tmp/monitor

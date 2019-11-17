#!/bin/sh

export DISPLAY=:0
export XAUTHORITY=/home/ben/.Xauthority
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

/usr/bin/notify-send --urgency=normal -t 5000 "Swipe Finger"

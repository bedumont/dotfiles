#!/bin/sh
# shell script to prepend i3status with cmus song and artist
read line
state=$(cmus-remote -Q | grep 'status')
artist=$(cmus-remote -Q | grep ' artist ' | cut -d ' ' -f3-)
song=$(cmus-remote -Q | grep title | cut -d ' ' -f3-)
if [ "$state" = "status playing" ]; then
	echo "$artist - $song  $line" || exit 1a
elif [ "$state" = "status paused" ]; then
	echo "$artist - $song  $line(\uf28c)" || exit 1a
fi

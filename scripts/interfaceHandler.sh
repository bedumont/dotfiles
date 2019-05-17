#!/bin/sh

#Catch non zero errors
set -e

if [ "${ACTION}" = "add" ]; then
	sudo ip link set wlp3s0 down

elif [ "${ACTION}" = "remove" ]; then
	sudo ip link set wlp3s0 up

else
	exit

fi

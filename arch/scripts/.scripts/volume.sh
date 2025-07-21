#!/bin/bash

get_current_volume() {
	pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | sed 's/%//'
}

if [[ "$#" != 1 || ! ("$1" == "inc" || "$1" == "dec" || "$1" == "mute") ]]; then
	printf "Usage: $0 [inc|dec|mute]\n"
	exit 1
fi

if ! command -v pactl &> /dev/null; then
	echo "Error: pactl is not installed. Please install it and try again."
	exit 1
fi

if [[ "$1" == "inc" ]]; then
	[ "$(get_current_volume)" -lt 150 ] && pactl set-sink-volume @DEFAULT_SINK@ +5%
elif [[ "$1" == "dec" ]]; then
	pactl set-sink-volume @DEFAULT_SINK@ -5%
elif [[ "$1" == "mute" ]]; then
	pactl set-sink-mute @DEFAULT_SINK@ toggle
fi

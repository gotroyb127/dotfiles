#!/bin/mksh

Title='shot_'$(date +'%Y-%m-%d(%H:%M:%S)')

if [[ $# -le 0 ]]; then
	shotgun "$HOME/Screenshots/$Title.png"
	notify-send -i "$HOME/Screenshots/$Title.png" "Screenshot saved."
	exit 0
fi

[[ $1 = !(w*) ]] && exit 0

id=$(xdotool getwindowfocus)
shotgun -i $id "$HOME/Screenshots/${Title}w.png";
notify-send -i "$HOME/Screenshots/${Title}w.png" "Screenshot saved."


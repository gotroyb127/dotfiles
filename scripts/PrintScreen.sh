#!/bin/sh

DEST="$HOME/Screenshots"
Title="shot_$(date +'%Y-%m-%d(%H:%M:%S)')"

if [ "$#" -le 0 ]; then
	shotgun "$DEST/$Title.png"
	notify-send -i "$DEST/$Title.png" "Screenshot saved."
	exit 0
fi

[ $1 != window ] && exit 1

id=$(xdotool getwindowfocus)
shotgun -i $id "$DEST/${Title}w.png";
notify-send -i "$DEST/${Title}w.png" "Window-Screenshot saved."

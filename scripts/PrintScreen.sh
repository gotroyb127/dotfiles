#!/bin/mksh

Title='shot_'$(date +'%Y-%m-%d(%H:%M:%S)')

[[ $# -le 0 ]] && shotgun "$HOME/Screenshots/$Title.png"

case $1 in
	w*)
		id=$(xdotool getwindowfocus)
		shotgun -i $id "$HOME/Screenshots/${Title}w.png";;
esac


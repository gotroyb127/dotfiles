#!/bin/sh

Xstart -a &
AutoUpdate &

#clipmenud &
clipsaved &

pgrep pulseaudio || pulseaudio -D &
dunst 2> /dev/null &
lxqt-policykit-agent 2> /dev/null &
xsidle.sh 'slock' "$MACHINECTL suspend" 600 &
unclutter --timeout 1 --ignore-scrolling &

sblocks &

# start window manager
exec dwm

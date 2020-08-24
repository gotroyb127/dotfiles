#!/bin/sh
# ^^^^^^^ probably ignored

Start.sh -u &

clipmenud &
pulseaudio -D &
dunst 2> /dev/null &
lxqt-policykit-agent 2> /dev/null &
xsidle.sh 'slock' "$MACHINECTL suspend" 600 &
unclutter --timeout 1 --ignore-scrolling &

sleep 1 && sblocks &

# start window manager
exec dwm

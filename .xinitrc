#!/bin/sh
# ^^^^^^^ probably ignored

Start.sh &

clipmenud &
pulseaudio -D &
dunst 2> /dev/null &
lxqt-policykit-agent 2> /dev/null &
xsidle.sh 'slock' "$MACHINECTL suspend" 600 &
unclutter --timeout 1 --ignore-scrolling &

sblocks &

sleep 4 && pgrep Xorg > /dev/null && xset s off &

# start window manager
exec dwm

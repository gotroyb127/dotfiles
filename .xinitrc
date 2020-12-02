#!/bin/sh

Xstart -a &
AutoUpdate -s5 &

sblocks &
clipsaved &
syncthing --no-browser >> "${TMPDIR:-/tmp}/sycnthing.log" &

dunst 2> /dev/null &
pgrep pulseaudio || pulseaudio -D &
lxqt-policykit-agent 2> /dev/null &
xsidle.sh 'slock' "$MACHINECTL suspend" 600 &
unclutter --timeout 1 --ignore-scrolling &

# start window manager
exec dwm

#!/bin/sh

[ -z "$DBUS_SESSION_BUS_ADDRESS" ] &&
	eval "$(dbus-launch --exit-with-session --sh-syntax)"

echo 'starting X...' | LF_Log &

Xstart -a &
AutoUpdate -s5 &

sblocks "${TMPDIR-/tmp}/sblocks.$DISPLAY.fifo" &
clipsaved &

pgrep syncthing ||
	syncthing --no-browser >> "$SYNCTHING_LOG" &

dunst 2> /dev/null &
pgrep pulseaudio || pulseaudio -D &
lxqt-policykit-agent 2> /dev/null &
xsidle.sh 'slock' 15 "$MACHINECTL suspend" 600 &
unclutter --timeout 1 --ignore-scrolling &

(
	sleep 1
	a=8
	while true
	do
		top -bcn1 -w512 | head -$((a+6)) | tail -$a |
			tee /dev/stderr | STARTX_LOG="$HOME/.top.log" LF_Log
		sleep 90
	done
) &

# start window manager
exec dwm

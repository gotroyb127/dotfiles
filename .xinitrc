#!/bin/sh

[ -z "$DBUS_SESSION_BUS_ADDRESS" ] &&
	eval "$(dbus-launch --exit-with-session --sh-syntax)"

echo 'starting X...' | LF_Log &

Xstart -a &
AutoUpdate -s5 >> "$ULOG" 2>&1 &

sblocks "${TMPDIR-/tmp}/sblocks.$DISPLAY.fifo" &
clipsaved &

pgrep syncthing ||
	setsid -f syncthing --no-browser >> "$SYNCTHING_LOG" &

dunst 2> /dev/null &
pgrep pulseaudio || pulseaudio -D &
lxqt-policykit-agent 2> /dev/null &
xsidle.sh slock 15 "$MACHINECTL suspend" 600 &
unclutter --timeout 1 --ignore-scrolling &

# start window manager
exec dwm

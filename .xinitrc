#!/bin/sh

Fork() {
	setsid -f "$@"
}

# make sure this does not look like a tty
exec < /dev/null

[ -z "$DBUS_SESSION_BUS_ADDRESS" ] &&
	eval "$(dbus-launch --exit-with-session --sh-syntax)"

echo 'starting X...' | LF_Log &

Fork Xstart -a
Fork AutoUpdate -s5 >> "$ULOG" 2>&1

Fork clipsaved
sblocks &
	export SBLOCKS_PID=$!

pgrep syncthing ||
	Fork syncthing --no-browser >> "$SYNCTHING_LOG"
pgrep pulseaudio ||
	Fork pulseaudio -D

Fork dunst 2> /dev/null
Fork lxqt-policykit-agent 2> /dev/null
Fork xsidle.sh slock 15 "$MACHINECTL suspend" 600
Fork unclutter --timeout 1 --ignore-scrolling
Fork keynav

# start window manager
exec dwm

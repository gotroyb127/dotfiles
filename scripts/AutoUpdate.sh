#!/bin/sh

sleep .5

sudo -n pacman -Sy &&
sudo -n pacman -Fy || exit 1

cachedir="${XDG_CACHE_HOME:-"$HOME/.cache"}"
cache="$cachedir/AutoUpdated"
Invl=5

cday="$(date +%j)"

case "$1" in
(-f)
	Updating=True;;
(*)
	Updating=;;
esac

if [ -f "$cache" ]; then
	passed="$((cday - $(cat "$cache")))"
	echo "Days passed since last auto-update: $passed."
	[ "$passed" -ge "$Invl" -o "$passed" -le -"$Invl" ] &&
	Updating=True
else
	Updating=True
fi

if [ -n "$Updating" ] ; then
	Updates="$(pacman -Qu | awk '{ printf("%-23s %s\n", $1, $NF) }' )"
	UpsNum="$(echo "$Updates" | wc -l)"
	notify-send -t 15000 "Time for Updates!!!
Pacman: $UpsNum updates available." \
	"$Updates"
	st -e tmux new 'sudo pacman -Su && echo "---- ----" && read'
	pacman -Quq > /dev/null || {
		echo "$cday" > "$cache"
		echo "Updating cache file ($cache)."
	}
fi

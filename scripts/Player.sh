#!/bin/sh

Socat() { socat - "$MPVSOCKET" 2> /dev/null; }
Info() {
	for c in "$@"; do
		printf '{ "command": ["get_property", "%s"] }\n' "$c"
	done |
	Socat | jq -r '.data'
}

SetInfoVars() {
	for v in $1; do
		read $v
	done <<- EOF
	$(Info $2)
	EOF
}

Command() {
	printf '{ "command": [%s] }\n' "$1" | Socat > /dev/null
}

SecsToTime() {
	t=${1%.*}
	m=$(( (t/60)%60 ))
	s=$((t%60))
	if [ "$((h = t/3600))" != 0 ]; then
		o="$h:$m:$s"
	elif [ "$m" != 0 ]; then
		o="$m:$s"
	else
		o="$s"
	fi
	eval "$2=\"$o\""
}

Status() {
	SetInfoVars "pause loop Title       CurrTime Duration RemPlTime          Speed" \
	            "pause loop media-title time-pos duration playtime-remaining speed"
	[ $? != 0 ] && {
		rm -f "$MPVSOCKET"
		exit 1
	}

	case "$pause" in
	(true)
		p='';;
	(false)
		p='';;
	esac
	l=
	case "$loop" in
	(true)
		l=" ()";;
#		l=" ( ﯢ)";;
	([0-9]*)
		l=" ($loop)";;
#	(false)
#		p="$p (:稜)";;
	esac

	for v in "$CurrTime CurrTime" "$Duration Duration" "$RemPlTime RemPlTime"
	do
		SecsToTime $v
	done

	printf "%s" "$Title [$CurrTime . $Duration] (-$RemPlTime) x$Speed $p$l"
}

TimeToSecs() {
	sed -e 's/^\([0-9]*\):\([0-9]*\)$/\1*60+\2/g' \
	    -e 's/^\([0-9]*\):\([0-9]*\):\([0-9]*\)$/\1*3600+\2*60+\3/g' \
	| bc
}

case "$1" in
	(status)
		Status;;
	(position-)
		Command '"seek", -'"$2";;
	(position)
		SetInfoVars "pos      dur" \
		            "time-pos duration"
		SecsToTime $pos pos
		SecsToTime $dur dur
		secs=$(dmenu -p "[$pos / $dur"'] Jump to: ' < /dev/null | TimeToSecs)
		Command '"set_property", "time-pos", '"$secs";;
	(position+)
		Command '"seek", '"$2";;
	(speed-)
		Command '"add", "speed", -'"$2";;
	(speed)
		Command '"set_property", "speed", '"$2";;
	(speed+)
		Command '"add", "speed", '"$2";;
	(play)
		Command '"set_property", "pause", false';;
	(pause)
		Command '"set_property", "pause", true';;
	(play-pause)
		Command '"cycle", "pause"';;
	(pause-after1)
		Command '"set_property", "pause", false'

		others=$(pgrep -f "$0 pause-after1" | wc -l)
		pgrep -f "$0 pause-after1" | grep -v $$ | xargs -r kill -15
		[ "$others" -gt 2 ] && {
			notify-send "Mpv pause canceled."
			exit 1
		}

		secs="$(echo "$(Info playtime-remaining) - 0.5" | bc)"
		SecsToTime $secs time
		notify-send "Pausing mpv after $time" "$(date +'%-I:%-M:%-S %p.')"
		sleep "$secs" && Command '"set_property", "pause", true';;
	(loop-)
		if [ $(Info loop) = true -a "$2" != 0 ]; then
			Command '"set_property", "loop", 0'
		else
			Command '"add", "loop", -'"$2"
		fi;;
	(loop)
		Command '"set_property", "loop", '"$2";;
	(loop+)
		Command '"add", "loop", '"$2";;
	(next)
		Command '"playlist-next"';;
	(prev*)
		Command '"playlist-prev"';;
	(quit-wl)
		Command '"quit-watch-later"';;
	(quit)
		Command '"quit"';;
	(*)
		"$@";;
esac

# Commands
#	seek
#	cycle
#	add
#	playlist-next
#	playlist-prev
#	playlist-unshuffle
#	playlist-shuffle
#	quit

## Interesting Properties:
#	filename{,/no-ext}
#	title
#	media-title
#	duration
#	time-pos
#	time-remaining
#	percent-pos
#	playtime-remaining
#	playback-time
#	?core-idle
#	playlist-pos-1
#
#	RemTime=$(Info time-remaining)
#	MetaDataTitle=$(Info media-title)
#	RemPlTime=$(Info playtime-remaining)
#	Perc=$(Info percent-pos | sed 's/\.[0-9]*//g')
#	Title=$(Info filename/no-ext)


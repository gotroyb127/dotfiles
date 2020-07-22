#!/bin/sh

Info() {
	for c in "$@"; do
		printf '{ "command": ["get_property", "%s"] }\n' "$c"
	done |
	socat - "$MPVSOCKET" | jq -r '.data'
}

Command() {
	printf '{ "command": [%s] }\n' "$1" | socat - "$MPVSOCKET" > /dev/null
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
	case "$(Info pause 2> /dev/null)" in
		'true')  p="";;
		'false') [ "$(Info loop)" = true ] && p=  || p="";;
		*) rm -f -- "$MPVSOCKET"; exit 1;;
	esac

	for v in Title CurrTime Duration RemPlTime Speed; do
		read $v
	done <<- EOF
	$(Info media-title time-pos duration playtime-remaining speed)
	EOF

	for v in "$CurrTime CurrTime" "$Duration Duration" "$RemPlTime RemPlTime"
	do
		SecsToTime $v
	done

	printf "%s" "$Title [$CurrTime . $Duration] (-$RemPlTime) x$Speed $p"
}

TimeToSecs() {
	sed -e 's/^\([0-9]*\):\([0-9]*\)$/\1*60+\2/g' \
	    -e 's/^\([0-9]*\):\([0-9]*\):\([0-9]*\)$/\1*3600+\2*60+\3/g' \
	| bc
}

case "$1" in
	status) Status;;
	position+)  Command '"seek", '"$2" ;;
	position-)  Command '"seek", -'"$2" ;;
	position)
		SecsToTime $(Info time-pos) pos
		SecsToTime $(Info duration) dur
		secs=$(dmenu -p "[$pos / $dur"'] Jump to: ' < /dev/null | TimeToSecs)
		Command '"set_property", "time-pos", '"$secs" ;;
	speed+) Command '"add", "speed", '"$2";;
	speed)  Command '"set_property", "speed", '"$2";;
	speed-) Command '"add", "speed", -'"$2";;
	play)   Command '"set_property", "pause", false';;
	pause)  Command '"set_property", "pause", true';;
	play-pause)
		Command '"cycle", "pause"' ;;
	pause-after1)
		Command '"set_property", "pause", false'
		pgrep -f 'Player.sh pause-after1' | grep -v $$ | xargs -r kill
		SecsToTime "$(echo "$(Info playtime-remaining) - 0.5" | bc)" secs
		notify-send "Pausing mpv after $secs" "$(date +'%-I:%-M:%-S %p.')"
		sleep "$t" &&
		Command '"set_property", "pause", true';;
	loop)
		if [ "$(Info loop)" = false ]; then
			Command '"set_property", "loop", true'
		else
			Command '"set_property", "loop", false'
		fi ;;
	next)   Command '"playlist-next"';;
	prev*)  Command '"playlist-prev"';;
	quit-wl) Command '"quit-watch-later"';;
	quit)    Command '"quit"';;
	Info*)  $@;;
	*)      Command "$1";;
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


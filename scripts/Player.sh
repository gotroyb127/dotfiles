#!/bin/mksh

Info() {
	printf '{ "command": ["get_property", "%s"] }\n' "$1" |
	socat - /tmp/mpvsocket | jq ".data" | tr -d '"'
}

Command() {
	printf '{ "command": [%s] }\n' "$1" | socat - /tmp/mpvsocket > /dev/null
}

SecsToTime() {
	echo "scale=0; t=$1/1; t/3600; (t/60)%60; t%60" | bc |
	head -c -1 | tr '\n' ':' | sed 's/^0:\|0:0://g'
}

Status() {
	case "$(Info pause 2> /dev/null)" in
		'true')  p="";;
		'false') [[ $(Info loop) = true ]] && p=  || p="";;
		*) exit 1;;
	esac

#	RemTime=$(Info time-remaining)
#	MetaDataTitle=$(Info media-title)
#	RemPlTime=$(Info playtime-remaining)
#	Perc=$(Info percent-pos | sed 's/\.[0-9]*//g')
#	Title=$(Info filename/no-ext)

	Title=$(Info media-title)
	CurrTime=$(SecsToTime $(Info time-pos) )
	Duration=$(SecsToTime $(Info duration) )
	RemPlTime=$(SecsToTime $(Info playtime-remaining) )
	Speed=$(Info speed)
	echo -n "$Title [$CurrTime . $Duration] (-$RemPlTime) x$Speed $p"
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
		echo | dmenu -p "[$(SecsToTime $(Info time-pos)) / $(SecsToTime $(Info duration))"'] Jump to: '\
		| TimeToSecs |& read -p Secs
		Command '"set_property", "time-pos", '"$Secs" ;;
	speed+) Command '"add", "speed", '"$2";;
	speed)  Command '"set_property", "speed", '"$2";;
	speed-) Command '"add", "speed", -'"$2";;
	play)   Command '"set_property", "pause", false';;
	pause)  Command '"set_property", "pause", true';;
	play-pause)
		Command '"cycle", "pause"' ;;
	pause-after1)
		Command '"set_property", "pause", false'
		t="$(echo "$(Info playtime-remaining) - 0.01" | bc)"
		notify-send "Pausing mpv after $(SecsToTime $t)" "$(date +'%-I:%-M:%-S %p.')"
		sleep "$t" &&
		Command '"set_property", "pause", true';;
	loop)	if [[ $(Info loop) = false ]]; then
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

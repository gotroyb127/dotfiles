#!/bin/mksh

Info() {
	printf '{ "command": ["get_property", "%s"] }\n' "$1" |
	socat - /tmp/mpvsocket | jq ".data" | tr -d '"'
}

Command() {
	printf '{ "command": [%s] }\n' "$1" | socat - /tmp/mpvsocket
}

FormatTime() {
	bc <<< "scale=0; t=$1/1; t/3600; (t/60)%60; t%60" |
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
	CurrTime=$(FormatTime $(Info time-pos) )
	Duration=$(FormatTime $(Info duration) )
	RemPlTime=$(FormatTime $(Info playtime-remaining) )
	Speed=$(Info speed)
	echo -n "$Title [$CurrTime . $Duration] (-$RemPlTime) x$Speed $p"
}

TimeToSecs() {
	sed -e 's/^\([0-9]*\):\([0-9]*\)$/\1*60+\2/g' -e 's/^\([0-9]*\):\([0-9]*\):\([0-9]*\)$/\1*3600+\2*60+\3/g' | bc
}

case "$1" in
	position+)  Command '"seek", '"$2" ;;
	position-)  Command '"seek", -'"$2" ;;
	position)
		echo | dmenu -p "[$(FormatTime $(Info time-pos)) / $(FormatTime $(Info duration))"'] Jump to: '\
		| TimeToSecs |& read -p Secs
		Command '"set_property", "time-pos", '"$Secs" ;;
	speed+)  Command '"add", "speed", '"$2";;
	speed1)  Command '"set_property", "speed", 1';;
	speed-)  Command '"add", "speed", -'"$2";;
	*pause*) Command '"cycle", "pause"' ;;
	loop)	if [[ $(Info loop) = false ]]; then
			Command '"set_property", "loop", true'
		else
			Command '"set_property", "loop", false'
		fi ;;
	next)   Command '"playlist-next"';;
	prev*)  Command '"playlist-prev"';;
	quit)   Command '"quit-watch-later"';;
	status) Status;;
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

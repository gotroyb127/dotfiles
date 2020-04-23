#!/bin/mksh

Info() {
printf '{ "command": ["get_property", "%s"] }\n' "$1" | socat - /tmp/mpvsocket | jq ".data" | sed 's/\"//g'
}

Command() {
printf '{ "command": [%s] }\n' "$1" | socat - /tmp/mpvsocket
}

FormatTime() {
local t=$(echo "$1" | sed 's/\.[0-9]*//g'); s=$((t % 60 )); m=$(( t / 60 % 60 )); h=$((t / 3600));
echo -n "$h:$m:$s" | sed 's/^0:\|//g' 
}

case "$(Info pause 2> /dev/null)" in
	'true')  p="";;
	'false') p="";;
	*) exit 1;;
esac


#RemTime=$(Info time-remaining)
#MetaDataTitle=$(Info media-title)
#RemPlTime=$(Info playtime-remaining)
#Perc=$(Info percent-pos | sed 's/\.[0-9]*//g')

#Title=$(Info filename/no-ext)
Title=$(Info media-title)
CurrTime=$(FormatTime $(Info time-pos) )
Duration=$(FormatTime $(Info duration) )
RemPlTime=$(FormatTime $(Info playtime-remaining) )
Speed=$(Info speed)

case "$1" in
	position+*) Command '"seek", 5' ;;
	position-*) Command '"seek", -5' ;;
	speed++*)   Command '"add", "speed", 0.3';;
	speed+)     Command '"add", "speed", 0.1';;
	speed)      Command '"set_property", "speed", 1';;
	speed-)     Command '"add", "speed", -0.1';;
	speed--*)   Command '"add", "speed", -0.3';;
	*pause*)    Command '"cycle", "pause"' ;;
	next)       Command '"playlist-next"';;
	prev*)      Command '"playlist-prev"';;
	quit)       Command '"quit"';;
	info)     echo -n "$Title | $CurrTime . $Duration (-$RemPlTime) x$Speed $p";;
	Info*)      $@;;
	*)          Command "$1";;
#		  echo -n "[$Title | $CurrTime . $Duration ($Perc%) x$Speed $p]";;
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
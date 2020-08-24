#!/bin/sh

set -e
#b0=${0##*/}
Command()     { printf '{ "command": [%s] }\n' "$1" | Socat > /dev/null; }
Notify()      { notify-send -t 2000 "$1" "$(date +'%-I:%-M:%-S %p.')"; }
ResyncPause() { pkill -USR1 -f "$0 pause-after"; }
Socat()       { socat - "$MPVSOCKET" 2> /dev/null; }

Info() {
	for c in "$@"
	do
		printf '{ "command": ["get_property", "%s"] }\n' "$c"
	done |
	Socat | jq -r '.data'
}

SetInfoVars() {
	for v in $1
	do
		read $v
	done <<- EOF
	$(Info $2)
	EOF
}

SecsToTime() {
	t=${1%.*}
	m=$(( (t/60)%60 ))
	s=$((t%60))
	if [ "$((h = t/3600))" != 0 ]
	then
		o="$h:$m:$s"
	elif [ "$m" != 0 ]
	then
		o="$m:$s"
	else
		o="$s"
	fi
	eval "$2=\"$o\""
}

Status() {
	[ ! -S "$MPVSOCKET" ] && exit
	SetInfoVars "pause loop Title       CurrTime Duration RemPlTime          Speed" \
	            "pause loop media-title time-pos duration playtime-remaining speed"

	case $pause in
	(true)
		p=''
	;;
	(false)
		p=''
	;;
	esac
	l=
	case $loop in
	(true)
		l=" ()"
	;;
	([0-9]*)
		l=" ($loop)"
	;;
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

case $1 in
(status)
	Status
;;
(position-)
	Command '"seek", -'"$2"
	ResyncPause &
;;
(position)
	SetInfoVars "pos      dur" \
		    "time-pos duration"
	SecsToTime $pos pos
	SecsToTime $dur dur
	secs=$(dmenu -p "[$pos / $dur"'] Jump to: ' < /dev/null | TimeToSecs)
	Command '"set_property", "time-pos", '"$secs"
	ResyncPause &
;;
(position+)
	Command '"seek", '"$2"
	ResyncPause &
;;
(speed-)
	Command '"add", "speed", -'"$2"
	ResyncPause &
;;
(speed)
	Command '"set_property", "speed", '"$2"
	ResyncPause &
;;
(speed+)
	Command '"add", "speed", '"$2"
	ResyncPause &
;;
(play)
	Command '"set_property", "pause", false'
	ResyncPause &
;;
(pause)
	Command '"set_property", "pause", true'
	ResyncPause &
;;
(play-pause)
	Command '"cycle", "pause"'
	ResyncPause &
;;
(pause-after)
	shift
	trap 'exec "$0" pause-after $n -' USR1

	# At first spawn
	[ -z "$2" ] && {
		# cancel any pending pause and exit
		others=$(pgrep -f "$0 pause-after" | wc -l)
		pgrep -f "$0 pause-after" | grep -v $$ | xargs -r kill -15
		[ "$others" -gt 3 ] && {
			Notify "Mpv pause canceled."
			exit 1
		}

		# Notify at first spawn
		Command '"set_property", "pause", false'
		[ "$1" -eq 1 ] && {
			secs=$(echo "$(Info playtime-remaining) - 0.5" | bc)
			SecsToTime $secs time
		} || {
			time=$1
		}
		Notify "Pausing mpv after $time."
	}

	n=$(($1 + 1))
	while [ $((n -= 1)) -gt 0 ]
	do
		if [ $n -ne 1 ]
		then
			secs=$(echo "$(Info playtime-remaining) + 1" | bc)
			( sleep $secs
			) & wait $!
		else
			secs=$(echo "$(Info playtime-remaining) - 0.5" | bc)
			( sleep "$secs"
				Command '"set_property", "pause", true'
				Notify "Mpv paused."
			) & wait $!
		fi
	done

	exit 0
;;
(loop-)
	if [ $(Info loop) = true -a "$2" != 0 ]
	then
		Command '"set_property", "loop", 0'
	else
		Command '"add", "loop", -'"$2"
	fi
;;
(loop)
	Command '"set_property", "loop", '"$2"
;;
(loop+)
	Command '"add", "loop", '"$2"
;;
(next)
	Command '"playlist-next"'
	ResyncPause &
;;
(prev*)
	Command '"playlist-prev"'
	ResyncPause &
;;
(quit-wl)
	Command '"quit-watch-later"'
;;
(quit)
	Command '"quit"'
;;
(*)
	"$@"
;;
esac

#!/bin/sh

set -e
Socat()       { socat - "$MPVSOCKET" 2> /dev/null; }
Command()     { printf '{ "command": [%s] }\n' "$1" | Socat > /dev/null; }
Notify()      { notify-send -t 2000 "$1" "$(date +'%-I:%-M:%-S %p.')"; }

ResyncPause() {
	pause=$(Info pause)
	case "$pause$1" in
	(true|*STOP)
		SIGS=STOP
	;;
	(false|*CONT)
		SIGS='CONT USR1'
	;;
	(*)
		SIGS=
	;;
	esac

	for sig in $SIGS
	do
		pkill -$sig -f "$0 pause-after"
	done
}

TimeToSecs() {
	sed -e 's/^\([0-9]*\):\([0-9]*\)$/\1*60+\2/g' \
	    -e 's/^\([0-9]*\):\([0-9]*\):\([0-9]*\)$/\1*3600+\2*60+\3/g' \
	| bc
}

Info() {
	for c in "$@"
	do
		printf '{ "command": ["get_property", "%s"] }\n' "$c"
	done |
	Socat | jq -r '.data'
}

PauseAfter() {
	shift
	trap 'exec "$0" pause-after $n -' USR1

	# At first spawn
	[ -z "$2" ] && {
		# cancel any pending pause and exit
		others=$(pgrep -f "$0 pause-after" | wc -l)
		pgrep -f "$0 pause-after" | grep -v $$ | xargs -r kill

		[ "$others" -gt 3 ] && {
			ResyncPause CONT &
			Notify "Mpv pause canceled."
			exit 1
		}

		# Notify at first spawn
		Command '"set_property", "pause", false'
		if [ "$1" -eq 1 ]
		then
			secs=$(echo "$(Info playtime-remaining) - 0.5" | bc)
			SecsToTime $secs time
		else
			time=$1
		fi
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

while [ $# -gt 0 ]
do
	case $1 in
	(status)
		Status
		shift 1
	;;
	(position-)
		Command '"seek", -'"$2"
		ResyncPause &
		shift 2
	;;
	(position)
		SetInfoVars "pos      dur" \
			    "time-pos duration"
		SecsToTime $pos pos
		SecsToTime $dur dur
		secs=$(dmenu -p "[$pos / $dur"'] Jump to: ' < /dev/null | TimeToSecs)
		Command '"set_property", "time-pos", '"$secs"
		ResyncPause &
		shift 1
	;;
	(position+)
		Command '"seek", '"$2"
		ResyncPause &
		shift 2
	;;
	(speed-)
		Command '"add", "speed", -'"$2"
		ResyncPause &
		shift 2
	;;
	(speed)
		Command '"set_property", "speed", '"$2"
		ResyncPause &
		shift 2
	;;
	(speed+)
		Command '"add", "speed", '"$2"
		ResyncPause &
		shift 2
	;;
	(play)
		Command '"set_property", "pause", false'
		ResyncPause &
		shift 1
	;;
	(pause)
		Command '"set_property", "pause", true'
		ResyncPause &
		shift 1
	;;
	(play-pause)
		Command '"cycle", "pause"'
		ResyncPause &
		shift 1
	;;
	(pause-after)
		PauseAfter "$@"
		shift $#
	;;
	(loop-)
		if [ $(Info loop) = true -a "$2" != 0 ]
		then
			Command '"set_property", "loop", 0'
		else
			Command '"add", "loop", -'"$2"
		fi
		shift 2
	;;
	(loop)
		Command '"set_property", "loop", '"$2"
		shift 2
	;;
	(loop+)
		Command '"add", "loop", '"$2"
		shift 2
	;;
	(next)
		Command '"playlist-next"'
		ResyncPause &
		shift 1
	;;
	(prev*)
		Command '"playlist-prev"'
		ResyncPause &
		shift 1
	;;
	(quit-wl)
		Command '"quit-watch-later"'
		shift 1
	;;
	(quit)
		Command '"quit"'
		shift 1
	;;
	(sleep)
		sleep $2
		shift 2
	;;
	(*)
		"$@"
		shift $#
	;;
	esac
done

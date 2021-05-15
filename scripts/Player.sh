#!/bin/sh

set -e
. "$(which Player_lib.sh)"
ResyncPause() {
	pause=$(Info pause)
	[ ! -e "$pidf" ] &&
		exit
	pid=$(cat "$pidf")
	case "$pause$1" in
	(true)
		sigs=STOP
	;;
	(false)
		sigs='CONT USR1'
	;;
	(*)
		sigs="CONT $*"
	;;
	esac
	for sig in $sigs
	do
		kill -$sig $pid
	done
}
PauseAfter() {
	trap 'exit 0' TERM
	trap 'PAfirstspawn=n; PauseAfter $n "$@"' USR1
	trap 'rm -f "$pidf"' USR2 INT
	dt=0.5
	# At first spawn
	[ "X$PAfirstspawn" = Xy ] && {
		# cancel any pending pause and exit
		[ -e "$pidf" ] && {
			ResyncPause USR2 &
			Notify "Mpv pause canceled."
			exit 4
		}
		# Notify
		if [ "$1" -eq 1 ]
		then
			secs=$(echo "$(Info playtime-remaining) - $dt" | bc)
			SecsToTime time $secs
			time="$time secs"
		else
			time=$1
		fi
		Notify "Pausing mpv after $time."
	}
	Command '"set_property", "pause", false'
	printf '%s' $$ > "$pidf"
	n=$(($1 + 1))
	shift
	while [ $((n -= 1)) -gt 0 ]
	do
		if [ $n -gt 1 ]
		then
			secs=$(echo "$(Info playtime-remaining) + $dt" | bc)
			(
				sleep $secs
			) & wait $!
		else
			secs=$(echo "$(Info playtime-remaining) - $dt" | bc)
			(
				sleep $secs
			) & wait $!
			Command '"set_property", "pause", true'
			Notify "Mpv paused."
		fi
	done
	rm -f "$pidf"
	trap '' TERM USR1 USR2 exit
	Main "$@"
}

Main() {
	while [ $# -gt 0 ]
	do
		case $1 in
		(position-)
			Command '"seek", -'"$2"
			ResyncPause &
			shift 2
		;;
		(position)
			Command '"set_property", "time-pos", '"$2"
			ResyncPause &
			shift 2
		;;
		(position+)
			Command '"seek", '"$2"
			ResyncPause &
			shift 2
		;;
		(positionm)
			SetInfoVars "pos      dur" \
				    "time-pos duration"
			SetTimeVars pos $pos dur $dur
			secs=$(dmenu -p "[$pos / $dur"'] Jump to: ' < /dev/null | TimeToSecs)
			Command '"set_property", "time-pos", '"$secs"
			ResyncPause &
			shift
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
#			Command '"set_property", "keep-open", "no"'
			Command '"set_property", "pause", false'
			ResyncPause &
			shift
		;;
		(pause)
			Command '"set_property", "pause", true'
			ResyncPause &
			shift
		;;
		(play-pause)
#			[ "$(Info eof-reached)" = true ] &&
#				Command '"set_property", "keep-open", "no"'
			Command '"cycle", "pause"'
			ResyncPause &
			shift
		;;
		(pause-after)
#			if [ "$(Info keep-open)" != always ]
#			then
#				Command '"set_property", "keep-open", "always"'
#			else
#				Command '"set_property", "keep-open", "no"'
#			fi
			shift
			[ "X$1" = X-f ] && {
				shift
				"$0" pause-after "$@" &
				sleep .1
				exit
			}
			PAfirstspawn=y
			PauseAfter "$@"
			shift
		;;
		(loop-)
			if [ "$(Info loop)" = inf ] && [ "$2" != 0 ]
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
		(loop-playlist)
			if [ "$(Info loop-playlist)" = inf ]
			then
				Command '"set_property", "loop-playlist", "no"'
			else
				Command '"set_property", "loop-playlist", "inf"'
			fi
			shift
		;;
		(next)
			Command '"playlist-next"'
			ResyncPause &
			shift
		;;
		(prev*)
			Command '"playlist-prev"'
			ResyncPause &
			shift
		;;
		(quit-wl)
			Command '"quit-watch-later"'
			shift
		;;
		(quit)
			Command '"quit"'
			ResyncPause TERM &
			shift
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
	exit
}

Main "$@"

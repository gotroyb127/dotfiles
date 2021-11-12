#!/bin/sh

set -e
. Player_lib.sh
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
	SetP '"pause", false'
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
			SetP '"pause", true'
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
			Cmd '"seek", -'"$2"
			ResyncPause &
			shift 2
		;;
		(position)
			SetP '"time-pos", '"$2"
			ResyncPause &
			shift 2
		;;
		(position+)
			Cmd '"seek", '"$2"
			ResyncPause &
			shift 2
		;;
		(positionm)
			SetInfoVars "pos      dur" \
				    "time-pos duration"
			SetTimeVars pos $pos dur $dur
			secs=$(dmenu -p "[$pos / $dur"'] Jump to: ' < /dev/null | TimeToSecs)
			SetP '"time-pos", '"$secs"
			ResyncPause &
			shift
		;;
		(speed-)
			Cmd '"add", "speed", -'"$2"
			ResyncPause &
			shift 2
		;;
		(speed)
			SetP '"speed", '"$2"
			ResyncPause &
			shift 2
		;;
		(speed+)
			Cmd '"add", "speed", '"$2"
			ResyncPause &
			shift 2
		;;
		(speedm)
			SetInfoVars "sp" "speed"
			nsp=$(dmenu -p "x$sp"' Set speed: ' < /dev/null)
			SetP '"speed", '"$nsp"
			ResyncPause &
			shift
		;;
		(play)
#			SetP '"keep-open", "no"'
			SetP '"pause", false'
			ResyncPause &
			shift
		;;
		(pause)
			SetP '"pause", true'
			ResyncPause &
			shift
		;;
		(play-pause)
#			[ "$(Info eof-reached)" = true ] &&
#				SetP '"keep-open", "no"'
			Cmd '"cycle", "pause"'
			ResyncPause &
			shift
		;;
		(pause-after)
#			if [ "$(Info keep-open)" != always ]
#			then
#				SetP '"keep-open", "always"'
#			else
#				SetP '"keep-open", "no"'
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
				SetP '"loop", 0'
			else
				Cmd '"add", "loop", -'"$2"
			fi
			shift 2
		;;
		(loop)
			SetP '"loop", '"$2"
			shift 2
		;;
		(loop+)
			Cmd '"add", "loop", '"$2"
			shift 2
		;;
		(loop-playlist)
			Cmd '"cycle-values", "loop-playlist", "no", "inf"'
			shift
		;;
		(next)
			Cmd '"playlist-next"'
			ResyncPause &
			shift
		;;
		(prev*)
			Cmd '"playlist-prev"'
			ResyncPause &
			shift
		;;
		(quit-wl)
			Cmd '"quit-watch-later"'
			shift
		;;
		(quit)
			Cmd '"quit"'
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

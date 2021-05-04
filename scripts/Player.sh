#!/bin/sh

set -e
pidf=${TMPDIR-/tmp}/${0##*/}.pause-after.pid
Socat() {
	[ ! -S "$MPVSOCKET" ] &&
		exit 3
	socat - "$MPVSOCKET" 2> /dev/null
}
Command() {
	printf '{ "command": [%s] }\n' "$1" | Socat > /dev/null
}
Notify() {
	notify-send -t 2000 "$1" "$(date +'%-I:%-M:%-S %p.')"
}
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
		kill -$sig $pid #|| rm -f "$pidf"
	done
}
TimeToSecs() {
	awk -F: '{
		for (i = NF; i > 0; --i)
			Secs += $i * (60 ^ (NF-i))
		print Secs
	}'
}
Info() {
	printf '{ "command": ["get_property", "%s"] }\n' "$@" \
		| Socat | jq -cr '.data'
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
PlaylistInfo() {
	echoPL() {
		cachedir="${TMPDIR-/tmp}/${0##*/}.cache"
		mkdir -p "$cachedir"
		IFS='
'
		for fname in $PL
		do
			cachepath="$cachedir$fname.cache"
			if ! [ -f "$cachepath" ]
			then
				mkdir -p "${cachepath%/*}"
				ffprobe -v error -show_entries format=duration \
					-of default=noprint_wrappers=1:nokey=1 "$fname" \
					2> /dev/null > "$cachepath"
			fi
			printf '%s\n' "$fname"
			cat "$cachepath"
		done
	}
	SetInfoVars "N            PL       CT       RT                 Speed"\
	            "playlist-pos playlist time-pos playtime-remaining speed"
	PL=$(printf '%s\n' "$PL" | jq -r '.[] | .filename')
	PL=$(echoPL)
	printf '%s\n' "$PL" |
		awk -v N="$((N+1))" -v SP="$Speed" \
		    -v CT="$CT" -v RD="$RT" \
		    -v c1='\033[33m' -v c2='\033[00m' \
		'function SecsToTime(t) {
			s = int(t % 60)
			m = int((t/60) % 60)
			h = int(t / 3600)
			if (h != 0)
				o = sprintf("%d:%d:%d", h, m, s)
			else if (m != 0)
				o = sprintf("%d:%d", m, s)
			else
				o = sprintf("%d", s)
			return o
		} (NR % 2) {
			sub("^/.*/", "")
			sub("\\.[^.]+$", "")
			title = $0
			if ((NR + 1) / 2 == N)
				BD = CT + TD
		} !(NR % 2) {
			TD += $1
			$0 = SecsToTime($0)
			if (NR / 2 == N) {
				printf("%s\t" c1 "%s" c2 "\n", $0, title)
			} else
				printf("%s\t%s\n", $0, title)
		} END {
			TRD = SecsToTime((TD - BD) / SP)
			BD = SecsToTime(BD)
			TD = SecsToTime(TD)
			printf("(%s/%s)\t\t[%s %s] (-%s) x%s",
			       N, NR/2, BD, TD, TRD, SP)
		}'
}
SetInfoVars() {
	for v in $1
	do
		read $v
	done <<- EOF
	$(Info $2)
	EOF
}
SetTimeVars() {
	while [ $# -gt 0 ]
	do
		SecsToTime "$1" "$2"
		shift 2
	done
}
SecsToTime() {
	t=${2%.*}
	m=$(((t/60) % 60))
	s=$((t % 60))
	if [ "$((h = t/3600))" != 0 ]
	then
		o="$h:$m:$s"
	elif [ "$m" != 0 ]
	then
		o="$m:$s"
	else
		o="$s"
	fi
	eval "$1='$o'"
}
Status() {
	SetInfoVars "pause loop loopPl        Title\
		CurrTime Duration RemTime            Speed" \
	            "pause loop loop-playlist media-title\
		time-pos duration playtime-remaining speed"
	p=?
	case $pause in
	(true)
		p=''
	;;
	(false)
		p=''
	;;
	esac
	[ "$loopPl" = inf ] &&
		lp=P
	use_lf=y
	case $loop in
	(inf)
		lf=
		[ "$lp" = P ] &&
			lf=F
	;;
	([0-9]*)
		lf=$loop
	;;
	(*)
		use_lf=
	;;
	esac
	pa=
	[ -e "$pidf" ] &&
		pa=!
	[ -n "$use_lf$lp" ] &&
		l=" ($lp$lf)"
	SetTimeVars CurrTime $CurrTime Duration $Duration RemTime $RemTime
	printf "%.150s [%s %s] (-%s) x%s %s" "$Title" "$CurrTime" "$Duration" \
	       "$RemTime" "$Speed" "$p$l$pa"
}

Main() {
	while [ $# -gt 0 ]
	do
		case $1 in
		(status)
			Status
			shift
		;;
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
			if [ $(Info loop) = inf ] && [ "$2" != 0 ]
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
			if [ $(Info loop-playlist) = inf ]
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
		(playlist-info)
			PlaylistInfo
			shift
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

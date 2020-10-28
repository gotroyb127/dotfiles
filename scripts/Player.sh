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
		SIGS=$1
	;;
	esac
	for sig in $SIGS
	do
		pkill -$sig -f "$0 pause-after"
	done
}

TimeToSecs() {
	awk '{
		Secs = 0
		n = split($0, TimeArr, ":")
		for (i = n; i > 0; --i)
			Secs += TimeArr[i] * ( 60 ^ (n-i) )
		print Secs
	}'
}

Info() {
	for c in "$@"
	do
		printf '{ "command": ["get_property", "%s"] }\n' "$c"
	done |
	Socat | jq -cr '.data'
}

PauseAfter() {
	trap 'exit 0' TERM
	trap 'PauseAfter $n -' USR1
	dt='0.5'
	# At first spawn
	if [ -z "$2" ]
	then
		# cancel any pending pause and exit
		others=$(pgrep -f "$0 pause-after" | wc -l)
		pgrep -f "$0 pause-after" | grep -v $$ | xargs -r kill
		if [ "$others" -gt 3 ]
		then
			ResyncPause CONT &
			Notify "Mpv pause canceled."
			exit 1
		fi
		# Notify at first spawn
		Command '"set_property", "pause", false'
		if [ "$1" -eq 1 ]
		then
			secs=$(echo "$(Info playtime-remaining) - $dt" | bc)
			SecsToTime time $secs
		else
			time=$1
		fi
		Notify "Pausing mpv after $time."
	fi
	n=$(($1 + 1))
	while [ $((n -= 1)) -gt 0 ]
	do
		if [ $n -ne 1 ]
		then
			secs=$(echo "$(Info playtime-remaining) + $dt" | bc)
			( sleep $secs
			) & wait $!
		else
			secs=$(echo "$(Info playtime-remaining) - $dt" | bc)
			( sleep $secs
				Command '"set_property", "pause", true'
				Notify "Mpv paused."
			) & wait $!
		fi
	done
}

PlaylistInfo() {
	SetInfoVars "N            PL       CT       RT                 Speed"\
	            "playlist-pos playlist time-pos playtime-remaining speed"
	PL=$(printf '%s\n' "$PL" | jq -r '.[] | .filename' |
		while read -r fname
		do
			ffprobe -v error -show_entries format=filename,duration \
				-of default=noprint_wrappers=1:nokey=1 "$fname" \
				2> /dev/null
		done
	)
	printf '%s\n' "$PL" |
		awk -v N="$((N+1))" -v SP="$Speed" \
		    -v CT="$CT" -v RD="$RT" \
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
				CT = SecsToTime(CT)
				RD = SecsToTime(RD)
				printf("\t%s\n%s\t%s\n\t-%s\n",
				       CT, $0, title, RD)
			} else
				printf("%s\t%s\n", $0, title)
		} END {
			TRD = SecsToTime((TD - BD) / SP)
			BD = SecsToTime(BD)
			TD = SecsToTime(TD)
			printf("(%s/%s)\t\t[%s . %s] (-%s) x%s\n",
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
	m=$(( (t/60)%60 ))
	s=$(( t%60 ))
	if [ "$((h = t/3600))" != 0 ]
	then
		o="$h:$m:$s"
	elif [ "$m" != 0 ]
	then
		o="$m:$s"
	else
		o="$s"
	fi
	eval "$1=\"$o\""
}

Status() {
	[ ! -S "$MPVSOCKET" ] && exit
	SetInfoVars "pause loop Title       CurrTime Duration RemTime            Speed" \
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
	SetTimeVars CurrTime $CurrTime Duration $Duration RemTime $RemTime
	printf "%.75s [%s . %s] (-%s) x%s %s" "$Title" "$CurrTime" "$Duration" \
	       "$RemTime" "$Speed" "$p$l"
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
		shift 1
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
		shift
		PauseAfter "$@"
		shift 2
		[ "X$1" = 'X-' ] && shift 1
	;;
	(loop-)
		if [ $(Info loop) = true ] && [ "$2" != 0 ]
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
		ResyncPause TERM &
		shift 1
	;;
	(sleep)
		sleep $2
		shift 2
	;;
	(playlist-info)
		PlaylistInfo
		shift 1
	;;
	(*)
		"$@"
		shift $#
	;;
	esac
done

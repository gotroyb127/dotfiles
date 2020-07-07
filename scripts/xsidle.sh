#!/bin/sh
#
# Use xset s $time to control the timeout when this will run.
#

b0="$(basename $0)"
if [ $# -lt 1 ];
then
	printf "usage: %s 'LockCmd' 'SuspendCmd'\n" "$b0" 2>&1
	exit 1
fi
LockCmd="$1"
SuspendCmd="$2"

log() {
	echo "$b0: $(date) $1" >&2
}

ToLock=15
ToSusp=600
SleepT=20
BigSleepT=100

while true; do
	Tim=$(xset q | grep timeout | awk '{print $2}')
	tosleep=$(($(xssstate -t) / 1000))
	if [ "$(xssstate -s)" = "disabled" ]; then
		sleep $BigSleepT
	elif [ $tosleep -eq 0 ];
	then
		log "Screensaver activated."
		sleep $ToLock
		[ "$(xssstate -s)" != 'on' ] && continue
		log "Executing LockCmd: '$LockCmd'."
		$LockCmd &

		[ -n "$SuspendCmd" ] &&
		    while [ "$(($(xssstate -i)/1000))" -lt "$((Tim + ToLock + ToSusp))" ]
		    do if [ "$(xssstate -s)" != 'on' ];
			then 
				Waked=True
				break
			fi
			sleep $SleepT
		    done
		[ -z "$Waked" ] &&
		    log "Executing SuspendCmd: '$SuspendCmd'."
		    $SuspendCmd
		Waked=

		while [ "$(xssstate -s)" = 'on' ]; do
			sleep $SleepT
		done
	else
		sleep $tosleep
	fi
done


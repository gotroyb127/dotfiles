#!/bin/mksh
#
# Use xset s $time to control the timeout when this will run.
#

if [ $# -lt 1 ];
then
	printf "usage: %s 'LockCmd' 'SuspendCmd'\n" "$(basename $0)" 2>&1
	exit 1
fi
LockCmd="$1"
SuspendCmd="$2"

if [[ $(xssstate -s) = "disabled" ]]; then
	notify-send "$0 exited" \
	    "Because screensaver is deactivated"
	exit 1
fi

ToLock=15
#AtLockCmd='Player.sh pause'
ToSusp=600
SleepT=30

while true; do
	Tim=$(xset q | grep timeout | awk '{print $2}')
	tosleep=$(($(xssstate -t) / 1000))
	if [ $tosleep -le 0 ];
	then
		sleep $ToLock
		[ "$(xssstate -s)" = 'off' ] && continue
		$LockCmd &

		[ -n "$SuspendCmd" ] &&
		    while [ "$(($(xssstate -i)/1000))" -lt "$((Tim + ToSusp))" ]
		    do
			if [ "$(xssstate -s)" != 'on' ];
			then 
				Waked=True
			fi
			sleep $SleepT
		    done
		    [ -n "$Waked" ] && $SuspendCmd
		Waked=

		while [ "$(xssstate -s)" = 'on' ]; do
			sleep $SleepT
		done
	else
		sleep $tosleep
	fi
done


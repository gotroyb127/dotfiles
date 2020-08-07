#!/bin/sh
#
# Use xset s $time to control the timeout when this will run.
#

b0=${0##*/}
if [ $# -lt 1 ]
then
	echo "usage: $b0 'LockCmd' 'SuspendCmd' 'TimeBeforeSuspend'\n" 1>&2
	exit 1
fi
LockCmd=$1
SuspendCmd=$2
ToSusp=${3:-600}

log() { echo "$b0: $(date +%r) $1" >&2; }
Waked() { [ "$(xssstate -s)" != 'on' ]; }

ToLock=10
SleepT=30
BigSleepT=30

while true
do
	Tim=$(xset q | grep timeout | awk '{print $2}')
	tosleep=$(($(xssstate -t) / 1000))
	if [ "$(xssstate -s)" = 'disabled' ]
	then
		sleep $BigSleepT
	elif [ $tosleep -eq 0 ]
	then
		log "Screensaver activated."
		sleep $ToLock
		Waked && continue
		log "Executing LockCmd: '$LockCmd'."
		$LockCmd &

		[ -n "$SuspendCmd" ] && {
			sleep $ToSusp
			Waked && continue
			log "Executing SuspendCmd: '$SuspendCmd'."
			$SuspendCmd
		}

		until Waked
		do
			sleep $SleepT
		done
	else
		sleep $tosleep
	fi
done

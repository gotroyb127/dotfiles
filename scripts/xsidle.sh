#!/bin/sh

set -x
b0=${0##*/}
[ $# -lt 1 ] && {
	echo "usage: $b0 'lockCmd' 'timeBeforeLocking' 'suspendCmd' 'timeBeforeSuspend'" 1>&2
	exit 1
}
noLockF="${TMPDIR-/tmp}/xsidle.sh.nolock"
lockCmd=$1
toLock=${2:-15}
suspendCmd=$3
toSusp=${4:-600}

log() {
	echo "$b0: $(date +%r): $1" >&2
}
Waked() {
#	log "xsstate: $(xssstate -s)."
	while [ -f "$noLockF" ]
	do
		sleep $sleepT
	done
	[ "$(xssstate -s)" != 'on' ] ||
		[ "$(xset q | awk '/timeout/{print $2}')" = 0 ]
}

sleepT=20
BigSleepT=30

while true
do
	toSleep=$(($(xssstate -t) / 1000))
	if [ "$(xssstate -s)" = 'disabled' ]
	then
		sleep $BigSleepT
	elif [ $toSleep -eq 0 ]
	then
		log "Screensaver activated."
		sleep $toLock
		Waked && continue
		log "Executing lockCmd: '$lockCmd'."
		$lockCmd &

		[ -n "$suspendCmd" ] && {
			sleep $toSusp
			Waked && continue
			log "Executing suspendCmd: '$suspendCmd'."
			$suspendCmd
		}

		until Waked
		do
			sleep $sleepT
		done
	else
		sleep $toSleep
	fi
done

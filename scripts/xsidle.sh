#!/bin/sh

b0=${0##*/}
[ $# -lt 1 ] && {
	cat << EOF 1>&2
usage: $b0 'lockCmd' 'timeBeforeLocking' \
'suspendCmd' 'timeBeforeSuspend'
EOF
	exit 5
}

tmpDir="${TMPDIR-/tmp}"
dontLockF="$tmpDir/xsidle.sh.dontlock"
haveLockedF="$tmpDir/$b0.lockded"
lockCmd=$1
toLock=${2:-15}
suspendCmd=$3
toSusp=${4:-600}

log() {
	echo "$b0: $(date +%r): $1" >&2
}
Waked() {
	while [ -f "$dontLockF" ]
	do
		sleep $bigSleepT
	done
	[ "$(xssstate -s)" != 'on' ] ||
		[ "$(xset q | awk '/timeout/{print $2}')" = 0 ]
}

sleepT=20
bigSleepT=60

while true
do
	toSleepU=$(xssstate -t)
	toSleepS=$((toSleepU / 1000 + 1))
	if [ "$(xssstate -s)" = 'disabled' ]
	then
		sleep $bigSleepT
	elif [ $toSleepU -eq 0 ]
	then
		log "Screensaver activated."
		sleep $toLock
		Waked && continue

		if [ ! -e "$haveLockedF" ]
		then
			log "Executing lockCmd: '$lockCmd'."
			(	touch "$haveLockedF"
				$lockCmd
				rm -f "$haveLockedF"
			) &
		else
			log "Skipping lockCmd, since screen is already locked."
		fi

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
		sleep $toSleepS
	fi
done

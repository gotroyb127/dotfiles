#!/bin/mksh
#
# Use xset s $time to control the timeout when this will run.
#

if [ $# -lt 1 ];
then
	printf "usage: %s cmd\n" "$(basename $0)" 2>&1
	exit 1
fi
cmd="$@"

if [[ $(xssstate -s) = "disabled" ]]; then
	exit 1
fi

ToLock=15
ToSusp=600

while true; do
	Tim=$(xset q | grep timeout | awk '{print $2}')
	idle=$(($(xssstate -i) / 1000 ))
	if [[ $idle -ge $((Tim + ToLock)) ]]; then
		$cmd &
		while [[ -z $Susp && $idle -ge $((Tim + ToLock)) ]]; do
			idle=$(($(xssstate -i) / 1000 ))
			if [[ $idle -gt $((Tim + ToLock + ToSusp)) ]];
			then
				Susp=true
				systemctl suspend
			fi
		done
		Susp=
		# Safety loop for preventing suspend command
		# from being executed continiously
		# useful when it doesn't suspend the system
		while [[ $idle -ge $((Tim)) ]]; do
			idle=$(($(xssstate -i) / 1000 ))
			sleep 60
		done
	else
		sleep 10
	fi
done


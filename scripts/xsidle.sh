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

while true; do
	Tim=$(xset q | grep timeout | awk '{print $2}')
	if [ $(xssstate -s) != "disabled" ];
	then
#		tosleep=$(($(xssstate -t) / 1000))
		idle=$(($(xssstate -i) / 1000 ))
#		if [ $tosleep -ge 0 ]; then
		if [[ $idle -ge $((Tim +10)) ]]; then
			notify-send "$(date)" "$idle"
			$cmd
			sleep 60
		else
			sleep 10
		fi
	else
		sleep 300
	fi
done


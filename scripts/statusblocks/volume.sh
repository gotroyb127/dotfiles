#!/bin/mksh

s=$(pulsemixer --list-sinks | grep -o sink-[0-9] | grep -o [0-9] )

VOL=$(pulsemixer --id sink-$s --get-volume | awk '{ print $1 }')

if [[ $(pulsemixer --id sink-$s --get-mute) -eq 0 ]]; then
	echo -n "       "; warn=' '
else
	echo -n "      ﱝ "; warn=!
fi
#墳

echo -n "$VOL$warn"


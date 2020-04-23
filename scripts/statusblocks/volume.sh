#!/bin/mksh

VOL=$(pulsemixer --id sink-0 --get-volume | awk '{ print $1 }')

if [ $(pulsemixer --id sink-0 --get-mute) -eq 0 ]; then
	echo -n "     "
else
	echo -n "   ﱝ "; warn=!
fi
#墳

echo -n "$VOL$warn"


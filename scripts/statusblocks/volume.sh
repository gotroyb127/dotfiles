#!/bin/mksh

VOL=$(pulsemixer --id sink-0 --get-volume | awk '{ print $1 }')

#[ $(pulsemixer --id sink-0 --get-mute) -eq 0 ] && echo -n "[ " || echo -n "[ "
[ $(pulsemixer --id sink-0 --get-mute) -eq 0 ] && echo -n "    " || echo -n "    "

#echo -n "$VOL]"
echo -n "$VOL"


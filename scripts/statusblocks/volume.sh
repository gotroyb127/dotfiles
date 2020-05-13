#!/bin/mksh

read VOL mute <<< $(amixer get Master | tail -n1 | awk '{print $5" "$6}' | tr -d '%[]')

if [[ $mute = on ]]; then
	echo -n "    "; warn=' '
else
	echo -n "   ﱝ "; warn=!
fi
#墳

echo -n "$VOL$warn"


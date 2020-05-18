#!/bin/mksh

read VOL mute <<< $(amixer get Master | tail -n1 | awk '{print $5" "$6}' | tr -d '%[]')

if [[ $mute = on ]]; then
	vol=" "; warn=' '
else
	vol="ﱝ "; warn='!'
fi

MicMute=$(amixer get Capture | tail -n1 | awk '{print $6}')

#mic=' '
[[ $MicMute = '[on]' ]] && mic=' '

echo -n "    $mic$vol$VOL$warn"


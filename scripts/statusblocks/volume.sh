#!/bin/mksh

#amixer get Master | tail -n1 | awk '{print $5" "$6}' \
# | tr -d '%[]' |& read -p VOL mute

amixer get Master | tail -1 \
 | sed 's/.*\[\([0-9]*\)%\] \[\(.*\)\].*/\1 \2/' |& read -p VOL mute

if [[ $mute = on ]]; then
	vol="墳 "; warn=' '
else
	vol="ﱝ "; warn='!'
fi

MicMute=$(amixer get Capture | tail -n1 | awk '{print $6}')

#mic=' '墳 
[[ $MicMute = '[on]' ]] && mic=' '

echo -n "    $mic$vol$VOL$warn"


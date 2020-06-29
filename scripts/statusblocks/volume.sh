#!/bin/sh

#out="$(amixer get Master | tail -1 | sed 's/.*\[\([0-9]*\)%\] \[\(.*\)\].*/\1 \2/')"

info="$(amixer get Master | grep -m 1 -o '[[0-9]*%] [[onf]*]' | tr -d '[]%')"
VOL=${info%% *}
mute=${info##* }

if [ "$mute" = on ]; then
	vol="墳 "; warn=' '
else
	vol="ﱝ "; warn='!'
fi

MicMute="$(amixer get Capture | tail -n1 | awk '{print $6}')"

#mic=' '墳
[ "$MicMute" = '[on]' ] && mic=' '

echo -n "$mic$vol$VOL$warn"

#!/bin/sh

read VOL mute << EOF
$(amixer get Master | tail -1 | sed 's/.*\[\([0-9]*\)%\].* \[\(o[nf]*\)\]/\1 \2/')
EOF

if [ "$mute" = on ]; then
	vol="墳 "; warn=' '
else
	vol="ﱝ "; warn='!'
fi

MicMute="$(amixer get Capture | tail -n1 | awk '{print $6}')"

#mic=' '墳
[ "$MicMute" = '[on]' ] && mic=' '

printf "$mic$vol$VOL$warn"

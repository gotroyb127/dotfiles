#!/bin/sh

#read VOL mute << EOF
#$(amixer get Master | tail -1 | sed 's/.*\[\([0-9]*\)%\].* \[\(o[nf]*\)\]/\1 \2/')
#EOF

#MicMute=$(amixer get Capture | tail -1)
#[ "${MicMute}" = '[on]' ] && mic=' '
#mic=' '墳

all=$(amixer get Master)
VOL=${all%\%] *}
VOL=${VOL##* \[}
mute=${all##* \[}
mute=${mute%]}

[ "$mute" = 'on' ] && {
	vol="墳 "; warn=' '
} || {
	vol="ﱝ "; warn='!'
}

MicMute=$(amixer get Capture)
[ -z "${MicMute##*\[on]*}" ] && mic=' '


printf %s "$mic$vol$VOL$warn"

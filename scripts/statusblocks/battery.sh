#!/bin/mksh

Info=$(acpi -b)

BAT="$(echo $Info | grep -E -o '[0-9," "][0-9][0-9]%')"']'

[ "$(echo "$Info" | grep Charging | wc -l) -qe 1" ] && Charg='[+' ||\
[ "$(echo "$Info" | grep "Full"   | wc -l) -qe 1" ] && Charg='' && BAT='' ||\
Charg='[-'

echo -n "$Charg$BAT"



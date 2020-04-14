#!/bin/mksh

Info=$(acpi -b)

BAT="$(echo $Info | grep -E -o '[0-9" "][0-9][0-9]%')"
#BAT="$(echo $Info | grep -E -o '[0-9," "][0-9][0-9]%')"']'

[[ $(echo "$Info" | grep Charging | wc -l) -ge 1 ]] && Charg='   +' ||\
[[ $(echo "$Info" | grep "100"    | wc -l) -ge 1 ]] && Charg='' && BAT='' ||\
Charg='   -'

#[[ $(echo "$Info" | grep Charging | wc -l) -ge 1 ]] && Charg='[+' ||\
#[[ $(echo "$Info" | grep "Full"   | wc -l) -ge 1 ]] && Charg='' && BAT='' ||\
#Charg='[-'

echo -n "$Charg$BAT"



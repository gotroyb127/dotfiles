#!/bin/sh

Info=$(acpi -b)


[ "$(echo "$Info" | grep Charging | wc -l) -qe 1" ] && Charg='+' ||\
[ "$(echo "$Info" | grep "Full"   | wc -l) -qe 1" ] && Charg='=' ||\
Charg='-'

BAT=$(acpi -b | grep -E -o '[0-9," "][0-9][0-9]%')

echo "$Charg$BAT"
#echo " $Charg$BAT"

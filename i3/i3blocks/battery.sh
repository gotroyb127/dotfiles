#!/bin/sh

Info=$(acpi -b)

[ $(echo "$Info" | grep Charging | wc -l) -eq 1 ] && Charg='+'  || Charg='-'

BAT=$(acpi -b | grep -E -o '[0-9," "][0-9][0-9]%')

echo " $Charg$BAT"

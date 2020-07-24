#!/bin/sh

Info=$(acpi -b)

BAT=$(echo "$Info" | sed 's/.*[^0-9]\+\([0-9]\+\)%.*/\1/')

if $(echo "$Info" | grep -q "100"); then
	BAT=" $BAT"; Charg=''
elif $(echo "$Info" | grep -q Charging); then
	BAT="$BAT"; Charg=''
else
	BAT="$BAT"; Charg='!'
fi

printf "${BAT}$Charg"

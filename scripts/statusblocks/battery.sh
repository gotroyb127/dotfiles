#!/bin/sh

Info=$(acpi -b)

BAT=$(echo "$Info" | sed 's/.*[^0-9]\+\([0-9]\+\)%.*/\1/')

case $Info in
(*100*)
	BAT=" $BAT"; Charg=''
;;
(*Charging*)
	BAT="$BAT"; Charg=''
;;
(*)
	BAT="$BAT"; Charg='!'
;;
esac

#if $(echo "$Info" | grep -q "100"); then
#elif $(echo "$Info" | grep -q Charging); then
#else
#fi

printf "${BAT}$Charg"

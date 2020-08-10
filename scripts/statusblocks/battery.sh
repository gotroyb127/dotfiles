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

printf "${BAT}$Charg"

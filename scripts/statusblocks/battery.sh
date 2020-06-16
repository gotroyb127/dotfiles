#!/bin/mksh

Info=$(acpi -b)

BAT="$(echo $Info | grep -E -o '[0-9]{2,}%' | tr -d '%' )"

if [[ $(echo "$Info" | grep Charging | wc -l) -ge 1 ]]; then
	BAT="$BAT"; Charg=''
elif [[ $(echo "$Info" | grep "100"  | wc -l) -ge 1 ]]; then
	BAT=" $BAT"; Charg=''
else
	BAT="$BAT"; Charg='!'
fi

echo -n "  ${BAT}$Charg"

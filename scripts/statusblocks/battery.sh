#!/bin/mksh

#Info='Battery 0: Charing, 50%'
Info=$(acpi -b)

BAT="$(echo $Info | grep -E -o '[0-9]{2,}')"

if [[ $(echo "$Info" | grep Charging | wc -l) -ge 1 ]]; then
	Charg=''; BAT="  $BAT"
elif [[ $(echo "$Info" | grep "100"  | wc -l) -ge 1 ]]; then
	Charg=''; BAT="   $BAT"
else
	Charg=''; BAT="  $BAT"
fi

echo -n "${BAT/%/}$Charg"



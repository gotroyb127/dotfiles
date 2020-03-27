#!/bin/bash

mute1=$(pulsemixer --id source-0 --get-mute)
mute2=$(pulsemixer --id source-1 --get-mute)
array=('' "")

out="${array[$mute1]} ${array[$mute2]}"
echo -e "$out\n$out\n$Yellow"

#echo -e "${array[$mute1]} ${array[$mute2]}\n\n$Yellow"

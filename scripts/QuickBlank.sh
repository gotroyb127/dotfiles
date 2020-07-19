#!/bin/sh

NewTime=${1:-10}
[ -n "$2" ] && NewBlank=no
Locker='xsidle.sh'

DefTime=$(xset q | awk '/timeout/ {print $2" "$4}')
[ "$(xset q | awk '/blanking/ {print $3}')" = no ] &&\
	BlankStyle=no

Set() {
	xset s $NewTime
	xset s ${NewBlank}blank
	printf "|-SS- \t\tTimeout changed: $NewTime\t${NewBlank}blank\n"
	printf "(II)\t"
	killall -v -STOP "$Locker"
}

Reset() {
	xset s $DefTime 
	xset s ${BlankStyle}blank
	printf "\n|-RR- \t\tTimeout reset: $DefTime\t${BlankStyle}blank\n"
	printf "(II)\t"
	killall -v -CONT "$Locker"
	printf -- "---------------------------------------------------\n"
}

trap 'exit' 2 15
trap 'Reset' exit

Pause() {
	An=$(bash -c 'read -sn1 An && echo $An')
	[ "$An" = q ] && exit 0
}

while true; do
	Set;	Pause
	Reset;	Pause
done


#!/bin/sh

Status=
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
	Status=S
}

Reset() {
	[ "x$Status" = xR ] && return 0
	xset s $DefTime 
	xset s ${BlankStyle}blank
	printf "\n|-RR- \t\tTimeout reset: $DefTime\t${BlankStyle}blank\n"
	printf "(II)\t"
	killall -v -CONT "$Locker"
	printf -- "---------------------------------------------------\n"
	Status=R
}

trap 'exit' 2 15
trap 'Reset' exit

Pause() {
	An=$(bash -c 'read -sn1 An && echo $An')
	[ "$An" = q ] && exit 0
}

while true
do
	Set;	Pause
	Reset;	Pause
done


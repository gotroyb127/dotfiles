#!/bin/mksh

NewTime=${1:-10}
[[ -n $2 ]] && NewBlank=no
Locker='xsidle.sh'

DefTime=$(xset q | awk '/timeout/ {print $2" "$4}')
[[ $(xset q | awk '/blanking/ {print $3}') = no ]] &&\
	BlankStyle=no

Set() {
	xset s $NewTime
	xset s ${NewBlank}blank
	echo -e "|-SS- \t\tTimeout changed: $NewTime\t${NewBlank}blank"
	echo -en "(II)\t"
	killall -v -STOP "$Locker"
}

Reset() {
	xset s $DefTime 
	xset s ${BlankStyle}blank
	echo -e "\n|-RR- \t\tTimeout reset: $DefTime\t${BlankStyle}blank"
	echo -en "(II)\t"
	killall -v -CONT "$Locker"
	echo -e "\n---------------------------------------------------\n"
}

trap 'exit' SIGINT SIGTERM
trap 'Reset' exit

Pause() {
	An=$(bash -c 'read -sn1 An && echo $An')
	[[ $An = @(e|s|q) ]] && exit 0
}

while true; do
	Set;	Pause
	Reset;	Pause
done


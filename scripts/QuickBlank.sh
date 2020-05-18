#!/bin/mksh

NewTime=${1:-10}
[[ -n $2 ]] && NewBlank=no
Locker='xsidle.sh'

DefTime=$(xset q | awk '/timeout/ {print $2" "$4}')
[[ $(xset q | awk '/blanking/ {print $3}') = no ]] &&\
	BlankStyle=no

xset s $NewTime
xset s ${NewBlank}blank
echo -e "|-- \tTimeout changed: $NewTime\t${NewBlank}blank"
echo -en "(II)\t"
killall -v -STOP "$Locker"

Reset() {
	xset s $DefTime 
	xset s ${BlankStyle}blank
	echo -e "\n|-- \tTimeout reset: $DefTime\t${BlankStyle}blank"
	echo -en "(II)\t"
	killall -v -CONT "$Locker"
	exit 0
}

trap 'Reset' SIGINT SIGTERM
trap 'Reset' exit

bash -c 'read -sn1'


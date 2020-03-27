#!/bin/bash

#Yellow=#D6CD17

case $button in
	1)
		pamixer -t
		pkill -RTMIN+1 i3blocks
		;;
	3)
		pavucontrol
		;;
	4)
		pamixer -i 5
		pkill -RTMIN+1 i3blocks
		;;
	5)
		pamixer -d 5
		pkill -RTMIN+1 i3blocks
		;;
esac

outp=$(pamixer --get-volume)

if [ $(pamixer --get-mute) = 'false' ]; then
	echo "  ${outp}%"
else
	echo -e "  ${outp}%\n ${outp}%\n${Yellow}"
#	echo -e " $(pamixer --get-volume)%\\n$Yellow\\n"
fi



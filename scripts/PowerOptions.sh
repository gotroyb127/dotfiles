#!/bin/sh

ctl=${MACHINECTL:-systemctl}
Option=$(dmenu -l 10 -p 'Choose option:' << EOF
0: rEBOOT
1: pOWEROFF
2: hIBERNATE
3: sUSPEND
4: eXIT
5: lOCK SCREEN
EOF
)

case ${Option%%:*} in
(0)
	$ctl reboot
;;
(1)
	$ctl poweroff
;;
(2)
	slock $ctl hibernate
;;
(3)
	slock $ctl suspend
;;
(4)
	pkill -15 -t tty"$XDG_VTNR" 'dwm$'
;;
(5)
	slock & sleep 1 && xset s activate
;;
(6)
	sleep .5 && xset s activate
;;
(7)
	$ctl suspend
;;
esac

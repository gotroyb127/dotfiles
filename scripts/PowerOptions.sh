#!/bin/sh

l='10'
prompt='Choose option:'


Opt0='0: rEBOOT'
Opt1='1: pOWEROFF'
Opt2='2: hIBERNATE'
Opt3='3: sUSPEND'
Opt4='4: eXIT'
Opt5='5: lOCK SCREEN'
Option=$(printf "$Opt5\n$Opt4\n$Opt3\n$Opt2\n$Opt1\n$Opt0\n" | dmenu -l $l -p "$prompt" )

case "$Option" in
	("$Opt0") systemctl reboot;;
	("$Opt1") systemctl poweroff;;
	("$Opt2") slock systemctl hibernate;;
	("$Opt3") slock systemctl suspend;;
	("$Opt4") pkill -15 -t tty"$XDG_VTNR" 'dwm$';;
	("$Opt5") slock & sleep 1 && xset s activate;;
	'screen nolock'|*6*)  sleep .5 && xset s activate;;
	'suspend nolock'|*7*) systemctl suspend;;
esac


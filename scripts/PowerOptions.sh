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

oIFS=$IFS
IFS=:
if find $PATH -maxdepth 1 | grep -q systemctl; then
	ctl=systemctl
else
	ctl=loginctl
fi
IFS=$oIFS

case "$Option" in
	("$Opt0") $ctl reboot;;
	("$Opt1") $ctl poweroff;;
	("$Opt2") slock $ctl hibernate;;
	("$Opt3") slock $ctl suspend;;
	("$Opt4") pkill -15 -t tty"$XDG_VTNR" 'dwm$';;
	("$Opt5") slock & sleep 1 && xset s activate;;
	'screen nolock'|*6*)  sleep .5 && xset s activate;;
	'suspend nolock'|*7*) $ctl suspend;;
esac

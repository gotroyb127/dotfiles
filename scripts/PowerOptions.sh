#!/bin/mksh

#fn='Source Code Pro Black:size=8'
#nb='#000000'
#nf='#888888'
#sb='#000000'
#sf='#ffffff'
#dmenucmd="dmenu -l $l -nb $nb -nf $nf -sb $sb -sf $sf"

l='10'
prompt='Choose option:'


Opt0='0: rEBOOT'
Opt1='1: pOWEROFF'
Opt2='2: hIBERNATE'
Opt3='3: sUSPEND'
Opt4='4: eXIT'
Opt5='5: lOCK SCREEN'
Option=$(echo -en "$Opt0\n$Opt1\n$Opt2\n$Opt3\n$Opt4\n$Opt5\n" | dmenu -l $l -p "$prompt" )

case "$Option" in
	("$Opt0") systemctl reboot;;
	("$Opt1")  systemctl poweroff;;
	("$Opt2") slock systemctl hibernate;;
	("$Opt3") slock systemctl suspend;;
	("$Opt4") killall dwm;;
	("$Opt5") slock & sleep 1 && xset s activate;;
	'screen nolock'|*6*)  sleep 0.3 && xset s activate;;
	'suspend nolock'|*7*) systemctl suspend;;
esac


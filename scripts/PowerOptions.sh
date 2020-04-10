#!/bin/mksh

l='10'
prompt='Choose option:'
fn='Source Code Pro Black:size=8'
#fn='monospace:size=8'
nb='#000000'
nf='#888888'
sb='#000000'
sf='#ffffff'
#nb='#111111'
#nf='#aaaaaa'
#sb='#333333'
#sf='#eeeeee'


dmenucmd="dmenu -i -l $l -nb $nb -nf $nf -sb $sb -sf $sf"
echo $dmenucmd
Option=$(echo -en "0: Reboot\n1: Poweroff\n2: Hibernate\n3: Suspend\n4: Exit\n5: Lock screen" | $dmenucmd -p "$prompt" -fn "$fn" )

case "$Option" in
	'0: Reboot')      systemctl reboot;;
	'1: Poweroff')    systemctl poweroff;;
	'2: Hibernate')   slock systemctl hibernate;;
	'3: Suspend')     slock systemctl suspend;;
	'4: Exit')        pkill dwm;;
	'5: Lock screen') slock & sleep 1 && xset s activate;;
	'screen nolock'|*6*)  sleep 0.3 && xset s activate;;
	'suspend nolock'|*7*) slock systemctl suspend;;
esac


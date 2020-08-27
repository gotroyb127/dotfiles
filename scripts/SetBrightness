#!/bin/sh

echostr() {
	for a in "$@"
	do
		echo "$f$a"
		echo "$s$a"
	done
}

Dmenucmd() {
	CurrBr=$(xbacklight)
	f=${1%?}
	s=${1#?}
	echostr $2 1 5 10 | dmenu -f -l 8 -p "Adjust screen brightness ($CurrBr): "
}

last='+- 5'
while true
do
	ans=$(Dmenucmd $last)
	num=${ans#?}
	case "$ans" in
	('-'[0-9]*)
		xbacklight -dec "$num"; last="-+ $num"
	;;
	('+'[0-9]*)
		xbacklight -inc "$num"; last="+- $num"
	;;
	([0-9]*)
		xbacklight -set "$ans"
	;;
	('')
		exit 0
	;;
	esac
done

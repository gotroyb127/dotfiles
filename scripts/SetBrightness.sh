#!/bin/sh

Dmenucmd() {
	CurrBr=$(xbacklight)
	if [ -z "$1" ]; then
		printf -- '+5\n-5\n+1\n-1\n+10\n-10' | dmenu -l 7 -p "Adjust screen brightness($CurrBr): "
	else
		printf -- '-5\n+5\n-1\n+1\n-10\n+10' | dmenu -l 7 -p "Adjust screen brightness($CurrBr): "
	fi
}

ans=5
while true; do
	ans=$(Dmenucmd $last)
	[ -z "$ans" ] && exit 0;
	case "$ans" in
		'-'[0-9]*) xbacklight -dec "$(echo "$ans" | tr -d '+-')"; last='-' ;;
		'+'[0-9]*) xbacklight -inc "$(echo "$ans" | tr -d '+-')"; last= ;;
		*)         xbacklight -set "$ans" ;;
	esac
done


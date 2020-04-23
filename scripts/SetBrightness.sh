#!/bin/mksh

#echo "$dmenucmd"
Dmenucmd() {
	local CurrBr=$(xbacklight)
	if [[ -z $1 ]]; then
		echo -e '+5\n-5\n+1\n-1\n+10\n-10' | $dmenucmd -p "Adjust screen brightness($CurrBr): "
	else
		echo -e '-5\n+5\n-1\n+1\n-10\n+10' | $dmenucmd -p "Adjust screen brightness($CurrBr): "
	fi
}

#notify-send "Asked for: $dmenucmd"
ans=5
while $() ; do
	ans=$(Dmenucmd $last)
	[[ -z $ans ]] && exit 0;
	case "$ans" in
		'-'[0-9]*) xbacklight -dec ${ans:1} ; last='-' ;;
		'+'[0-9]*) xbacklight -inc ${ans:1} ; last= ;;
		*)         xbacklight -set ${ans} ;;
	esac
done

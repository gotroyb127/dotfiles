#!/bin/sh

IFS='
'
box='==========----------------------------------------------------------------------=========='

Print() {
	clear -x 2> /dev/null || clear
	echo -n "$box"
	for f in $(find ~/.config/mpv/watch_later -type f)
	do
		( read i; i=${i#??}
		[ -e "$i" ] &&
			echo "${i##*/}" ||
			echo "$i"
		) < "$f"
	done | sort -nk2 |
	while read n
	do
		echo
		echo "$n"
	done
	echo "$box"
}

while Print
do
	read ans
	case $ans in
	(q*)
		break
	;;
	esac
done

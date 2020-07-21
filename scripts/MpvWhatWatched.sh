#!/bin/sh

IFS='
'
box='==========----------------------------------------------------------------------=========='

Print() {
	clear -x 2> /dev/null || clear
	echo -n "$box"
	for f in $(find ~/.config/mpv/watch_later -type f); do
		for l in $(head -1 "$f"); do
			i="${l#??}"
			[ -e "$i" ] &&
				echo "${i##*/}" ||
				echo "$i"
		done
	done | sort -nk2 |
	while read n; do
		echo
		echo "$n"
	done
	echo "$box"
}

while Print; do
	read _
done

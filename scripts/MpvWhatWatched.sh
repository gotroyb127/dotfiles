#!/bin/sh

IFS="
"
clear -x
box='==========----------------------------------------------------------------------=========='
echo -n "$box"
for f in $(find ~/.config/mpv/watch_later -type f); do
	for i in $(head -1 "$f" | tr -d '#'); do
		echo
		basename $i
	done
done
echo "$box"
read

#!/bin/sh

f_args=
case "$1" in
	(-type|-mindepth|-maxdepth)
		f_args="$1 $2"
		shift 2;;
esac
[ $# -ge 2 ] && { opts=$1; shift; }

find "$PWD" -mindepth 1 $f_args | grep $opts "[^/]*$@[^/]*$" | sort

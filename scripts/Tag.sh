#!/bin/sh

IFS='
'
Title() {
	echo "${1##*/}" | sed 's/\.[^.]\+$//g'
}
Tag() {
	tagutil clear: set:title="$(Title "$1")" print "$1"
}

set -e
for f in $@
do
	Tag "$f"
done

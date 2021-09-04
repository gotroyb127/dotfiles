#!/bin/sh

IFS='
'
Title() { echo "${1##*/}" | sed 's/\.mp[34]$//g'; }

Tag() {
	for f in $(find $1 -type f)
	do
		tagutil clear: set:title=$(Title "$f") print "$f"
	done
}

for fname in $@
do
	[ -d "$fname" ] || [ -f "$fname" ] && Tag $fname
done

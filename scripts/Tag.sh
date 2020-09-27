#!/bin/sh

IFS='
'

Title() { echo "${1##*/}" | sed 's/\.mp[34]$//g'; }

Tag() {
	for i in $(find $1 -type f)
	do
		mat2 --inplace "$i"
		tagutil set:title=$(Title "$i") "$i"
		tagutil "$i"
	done
}

for fname in $@
do
	[ -d "$fname" ] || [ -f "$fname" ] && Tag $fname
done

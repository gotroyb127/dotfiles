#!/bin/sh

IFS='
'

Title() { basename $1 | sed 's/.mp[34]//g'; }

Tag() {
	for i in $(find $1 -type f)
	do
		mat2 --inplace "$i"
		tagutil set:title=$(Title "$i") "$i"
		tagutil "$i"
	done
}

for dir in $@
do
	[ -d $dir ] && Tag $dir
done

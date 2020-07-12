#!/bin/ksh

IFS='
'

Title() { basename $1 | sed 's/.mp[34]//g'; }

if [ -n "$1" ]; then
	Folder="$1"
else
	echo -n "Are you sure you want to retag every file in ~/Music??? [Y/n] "
	read ans
	[ "$ans" != Y ] && exit 1
	Folder="$HOME/Music"
fi

for i in $(find $Folder -type f ); do
	mat2 --inplace "$i"
	tagutil set:title=$(Title "$i") "$i"
	tagutil "$i"
done

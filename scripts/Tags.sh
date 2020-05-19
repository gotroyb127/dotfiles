#!/bin/mksh

export IFS=$'\n'

Title() { basename $1 | sed 's/.mp[34]//g'; }

if [[ -n "$1" ]]; then
	Folder="$1"
else
	echo -n "Are you sure you want to retag every file in ~/Music??? [Y/n] "
	read -n1 ans
	[[ $ans != @(Y|y) ]] && exit 1
	Folder="$HOME/Music"
fi

for i in $(find $Folder -type f ); do
	mat2 --inplace "$i"
	bash -c 'read -sn1 tert'
	tagutil set:title=$(Title "$i") "$i"
	tagutil "$i"
done


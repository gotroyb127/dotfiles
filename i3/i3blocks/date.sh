#!/bin/bash

#dat=$(date  +"%X. %A %d %B %Y")
#dat=$(date  +"%I  %M  %S  %p. |  %A %d %B %Y")
dat=$(date  +"%p. |  %A %d %B %Y")

Hour=$(date +"%I")
Minutes=$(date +"%M")
Seconds=$(date +"%S")

NoZeros () {
	if [ ${1:0:1} = '0' ]; then 
		echo " ${1:1:1}";
	else
		echo "$1";
	fi
}

if [ $button -eq 1 ]; then
	i3-msg -q exec gsimplecal
fi

Hour=$(NoZeros $Hour)
Minutes=$(NoZeros $Minutes)
Seconds=$(NoZeros $Seconds)

echo "$Hour : $Minutes : $Seconds $dat"
#echo "$dat"

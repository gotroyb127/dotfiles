#!/bin/bash

str1=$(playerctl metadata --format '{{title}} | {{duration(position)}} . {{duration(mpris:length)}}')


if [ $button -eq 1 ]; then
	playerctl play-pause
fi


status=$(playerctl status)

if [ $status = 'Playing' ]; then
	str2=''
else
	str2=''
fi

echo "$str1 $str2"


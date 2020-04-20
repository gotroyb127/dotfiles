#!/bin/mksh

str1=$(playerctl metadata --format '{{title}} | {{duration(position)}} . {{duration(mpris:length)}}')


[ "$button" = "1" ] && playerctl play-pause

status=$(playerctl status)

[ "$status" = 'Playing' ] && str2='' || str2=''

echo "$str1 $str2"


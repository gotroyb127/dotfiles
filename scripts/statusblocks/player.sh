#!/bin/mksh

status=$(playerctl status 2> /dev/null)

case "$status" in
	'Playing') str2='';;
	'Paused')  str2='';;
	*)         echo -n $(Player.sh status); exit 0  ;;
esac

str1=$(playerctl metadata --format '{{title}} | {{duration(position)}} . {{duration(mpris:length)}} ' 2> /dev/null)

#[ "$status" = 'Playing' ] && str2='' || [ "$status" = 'Paused' ] && str2='' || exit 0



echo -n "[$str1$str2]"


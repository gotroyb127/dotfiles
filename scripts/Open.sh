#!/bin/mksh

IFS=$'\n'

[[ -z $@ ]] && exit 1

SH=/bin/sh

for t in $@; do
	[[ -d $t ]] && continue
	case $t in
		(*.png|*.jpg|*.webp|*.svg)
			Groups[0]+='"'$t'" ' ;;
		(*.pdf)
			Groups[1]+='"'$t'" ' ;;
		(*.pptx|*.ppt)
			Groups[2]+='"'$t'" ' ;;
		(*.exe)
			Groups[3]+='"'$t'" ' ;;
		(*.mid|*.MID)
			Groups[4]+='"'$t'" ' ;;
		(*.mp3|*.mp4)
			Groups[5]+='"'$t'" ' ;;
		(*)
			Groups[6]+='"'$t'" ' ;;
	esac
done

Opener=(sxiv zathura loimpress wine 'timidity -in' 'mpv --input-ipc-server=/tmp/mpvsocket' vim)

for i in $(seq 0 6); do
	[[ -z ${Groups[i]} ]] && continue
	if [[ $i -le 3 ]]; then
		echo ${Opener[i]} ${Groups[i]} | $SH 2> /dev/null &
	else
		eval "${Opener[i]} ${Groups[i]}"
	fi
done


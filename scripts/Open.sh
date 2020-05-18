#!/bin/mksh

IFS=$'\n'

OpenGroup() {
	case "$@" in
		(*.png|*.jpg|*.webp|*.svg)
			sxiv $@ &;;
		(*.pdf)
			zathura $@ 2> /dev/null &;;
		(*.pptx|*.ppt)
			loimpress $@ &;;
		(*.exe)
			wine $@ &;;
		(*.mid|*.MID)
			timidity -in $@ ;;
		(*.mp3|*.mp4)
			mpv --input-ipc-server=/tmp/mpvsocket $@ ;;
		(*)
			vim $@;;
	esac
}

for t in $@; do
	case $t in
		(*.mp3|*.mp4)
			Groups0+=$'\n'$t ;;
		(*.png|*.jpg|*.webp|*.svg)
			Groups1+=$'\n'$t ;;
		(*.pdf)
			Groups2+=$'\n'$t ;;
		(*.pptx|*.ppt)
			Groups3+=$'\n'$t ;;
		(*.mid|*.MID)
			Groups4+=$'\n'$t ;;
		(*.exe)
			Groups5+=$'\n'$t ;;
		(*)
			Groups6+=$'\n'$t ;;
	esac
done

for i in $(seq 0 6); do
	[[ -z $(eval "echo \$Groups$i") ]] && continue
#	eval 'echo OpenGroup $Groups'"$i"
	eval 'OpenGroup $Groups'"$i"
done


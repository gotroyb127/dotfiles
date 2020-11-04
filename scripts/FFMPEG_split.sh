#!/bin/ksh

# usage: FFMPEG_split.sh [-recode] media_file times_file name_format

case $1 in
(-recode)
	Rec='-recode'
	shift
;;
(*)
	Rec=
;;
esac

F=$1
T=$2
Format=$3

lr=0
pt=
ct=

while read -u3 l
do
	[ $((lr += 1)) -gt 7 ] && break
	pt=$ct
	ct=$l
	if [ -z "${pt###*}" ] || [ -z "${l###*}" ]
	then
		lr=$((lr - 1))
		continue
	fi
	FFMPEG_cut.sh $Rec "$F" "$pt" "$ct" "$(printf "$Format" "$lr")"
done 3< "$T"

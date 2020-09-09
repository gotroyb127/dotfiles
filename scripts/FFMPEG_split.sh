#!/bin/ksh

if [ "X$1" = X-recode ]
then
	Rec='-recode'
	shift
else
	Rec=
fi

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
	[ -z "${pt###*}" -o -z "${l###*}" ] && {
		lr=$((lr - 1))
		continue
	}
	FFMPEG_cut.sh $Rec "$F" "$pt" "$ct" "$(printf "$Format" "$lr")"
done 3< "$T"

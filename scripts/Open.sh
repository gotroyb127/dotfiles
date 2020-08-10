#!/bin/ksh

N='
'
IFS=$N
[[ -z $@ ]] && exit 1

set -A Opener\
	"zathura"\
	"loimpress"\
	"lowriter"\
	"sxiv$N-o"\
	"timidity$N-in"\
	"mpv$N--input-ipc-server=$MPVSOCKET"\
	"w3m$N-N"\
	"nvim"

set -A Group\
	'@(*.pdf)'\
	'@(*.pptx|*.ppt)'\
	'@(*.od[ft]|*.doc|*.docx)'\
	'@(*.png|*.jpg|*.webp|*.svg|*.tiff)'\
	'@(*.mid|*.MID)'\
	'@(*.mp[34]|*.mk[av]|*.ogg|*.wav|*.webm)'\
	'@(*.html)'\
	'@(*)'\

for t in $@
do
	i=0
	[[ -d $t ]] && continue
	until eval "[[ \$t = ${Group[i]} ]]"
	do
		((++i))
	done
	Groups[i]="${Groups[i]}$t$N";
done

i=-1; m=${#Group[@]}
while [[ $((i++)) -lt $m ]]
do
	[[ -z ${Groups[i]} ]] && continue
	echo ${Opener[i]} "$N${Groups[i]}" | pathi '/' 0
	if [[ $i -le 3 ]]
	then
		${Opener[i]} ${Groups[i]} 2> /dev/null |
		    xsel -b &
	else
		exec ${Opener[i]} ${Groups[i]}
	fi
done

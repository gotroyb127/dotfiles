#!/bin/ksh

set -f
N='
'
IFS=$N
[[ -z $@ ]] && {
	echo 'No targets given.' >&2
	exit 100
}

set -A Group\
	'@(*.pdf|*.djvu)'\
	'@(*.pptx|*.ppt)'\
	'@(*.od[ft]|*.doc|*.docx)'\
	'@(*.png|*.jp*(e)g|*.JPG|*.webp|*.svg|*.tiff|*.gif)'\
	'@(*.mid|*.MID)'\
	'@(*.mp[34]|*.MP[34]|*.mk[av]|*.ogg|*.wav|*.webm)'\
	'@(*.html)'\
	'@(*)'\

set -A Opener\
	"zathura"\
	"loimpress"\
	"lowriter"\
	"sxiv$N-o"\
	"timidity$N-in"\
	"mpv$N--input-ipc-server=$MPVSOCKET"\
	"w3m$N-N"\
	"nvim"

for t in $@
do
	i=0
	[[ -d $t ]] && continue
	until eval "[[ \$t = ${Group[i]} ]]"
	do
		if [ $((i += 1)) -ge ${#Group[@]} ]
		then
			continue 2
		fi
	done
	Groups[i]="${Groups[i]}$t$N";
done

i=-1; m=${#Group[@]}
while [[ $((i++)) -lt $m ]]
do
	[[ -z ${Groups[i]} ]] && continue

	echo ${Opener[i]} "$N${Groups[i]}" | LF_Fihi

	if [[ $i -le 2 ]]
	then
		${Opener[i]} ${Groups[i]} 2> /dev/null &
	elif [[ $i -le 3 ]]
	then
		${Opener[i]} ${Groups[i]} 2> /dev/null | xsel -b &
	else
		${Opener[i]} ${Groups[i]}
	fi
done

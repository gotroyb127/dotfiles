#!/bin/ksh

IFS="$(print '\n\b')"
N="$(print '\n\b')"

[[ -z $@ ]] && exit 1

set -A Opener	zathura\
		loimpress\
		lowriter\
		wine\
		"sxiv$N-o"\
		"timidity$N-in"\
		"mpv$N--input-ipc-server=/tmp/mpvsocket"\
		nvim

set -A Group	'\.pdf$'\
		'\.pptx$\|\.ppt$'\
		'\.odf$\|\.odt$\|\.doc$\|\.docx$'\
		'\.exe$'\
		'\.png$\|\.jpg$\|\.webp$\|\.svg$\|\.tiff$'\
		'\.mid$\|\.MID$'\
		'\.mp[34]$\|\.mka$\|\.ogg$\|\.wav\|\.mkv$'\
		''

for t in $@; do
	i=0
	[[ -d $t ]] && continue
	until echo $t | grep -q "${Group[i]}"; do
		((++i))
	done
	Groups[i]="${Groups[i]}$t$N"
done

for i in $(seq 0 $((${#Group[@]}-1))); do
	[[ -z ${Groups[i]} ]] && continue
	echo "${Opener[i]} ${Groups[i]}"
	if [[ $i -le 4 ]]; then
		${Opener[i]} ${Groups[i]} 2> /dev/null |
		    xsel -b &
	else
		${Opener[i]} ${Groups[i]}
	fi
done


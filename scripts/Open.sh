#!/bin/mksh

IFS=$'\n'

[[ -z $@ ]] && exit 1

Opener=(sxiv
	zathura
	loimpress
	lowriter
	wine
	$'timidity\n-in'
	$'mpv\n--input-ipc-server=/tmp/mpvsocket'
	vim)

Group=( '\.png$\|\.jpg$\|\.webp$\|\.svg$'
	'\.pdf$'
	'\.pptx$\|\.ppt$'
	'\.doc$\|\.docx$'
	'\.exe$'
	'\.mid$\|\.MID$'
	'\.mp[34]$\|\.mka$\|\.ogg$\|\.wav$'
	'')

for t in $@; do
	i=0
	[[ -d $t ]] && continue
	until echo $t | grep -q "${Group[i]}"; do
		((++i))
	done
	Groups[i]+="$t"$'\n'
done

for i in $(seq 0 $((${#Group[@]}-1))); do
	[[ -z ${Groups[i]} ]] && continue
	if [[ $i -le 4 ]]; then
		${Opener[i]} ${Groups[i]} 2> /dev/null &
	else
		${Opener[i]} ${Groups[i]}
	fi
done


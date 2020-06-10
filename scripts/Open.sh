#!/bin/mksh

IFS=$'\n'

[[ -z $@ ]] && exit 1

Opener=(zathura
	loimpress
	lowriter
	wine
	$'sxiv\n-o'
	$'timidity\n-in'
	$'mpv\n--input-ipc-server=/tmp/mpvsocket'
	vim)

Group=( '\.pdf$'
	'\.pptx$\|\.ppt$'
	'\.odt$\|\.doc$\|\.docx$'
	'\.exe$'
	'\.png$\|\.jpg$\|\.webp$\|\.svg$'
	'\.mid$\|\.MID$'
	'\.mp[34]$\|\.mka$\|\.ogg$\|\.wav\|\.mkv$'
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
		${Opener[i]} ${Groups[i]} 2> /dev/null | xclip &
	else
		${Opener[i]} ${Groups[i]}
	fi
done


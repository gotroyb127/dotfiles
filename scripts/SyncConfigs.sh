#!/bin/ksh

tilde() {
	while read -r line ; do
		echo "$line" |
		sed "s!'$HOME!'~!g"
	done
}

DEST="$HOME/Documents/ConfigFiles"

set -A Targets ~/.{config/{gsimplecal,zathura,dunst,lf,mpv,init.sh},local/scripts,tmux.conf,{vim,xinit,input}rc,profile} ~/{Notes,TODO}.txt

Update() {
	local bsnm="$(basename "$1")"
	if [ -f "$1" -a "$1" -nt "$2/$bsnm" ]; then
		cp -pv "$1" "$2"
		return 0
	elif [ ! -d "$1" ]; then
		return 1
	fi

	mkdir -p "$2/$bsnm"

	find "$1" -maxdepth 1 |
	    while read f; do
		[[ $1 == $f ]] && continue
		Update "$f" "$2/$bsnm"
	    done
}

date
printf "\nCopying to $DEST:\n" | tilde
for i in $(seq ${#Targets[@]}); do
	t="${Targets[i-1]}"
	Update "$t" "$DEST" | tilde
done
echo

#!/bin/mksh

tilde() {
	while read -r line ; do
		echo "$line" |\
		sed 's/'"${HOME//\//\\/}"'/~/g'
	done
}

Sync() {

Dest=~/Documents/ConfigFiles

echo -e "Copying to $Dest.\n" | tilde

Targets=(~/.{config/{gsimplecal,zathura,dunst,lf,mpv,fish,init.sh},local/scripts,tmux.conf,{vim,xinit,input}rc,profile} ~/{Notes,TODO}.txt)
total=${#Targets[@]}
w=${#total}

for i in $(seq 1 $total); do
	t="${Targets[i-1]}"
	echo "$i" \""$t"\" |\
	awk '{printf("[%'"$w"'d]\t%s\n",$1,$2,$3)}' |\
	tr -d '"' | tilde
	cp -upRv "$t" "$Dest" | tilde 1>&2
done
}

date 1>&2
notify-send "$(Sync)"
echo 1>&2

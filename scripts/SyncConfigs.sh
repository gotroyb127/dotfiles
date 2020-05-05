#!/bin/mksh

tilde() {
	while read -r line ; do
		echo "$line" |\
		sed 's/'"$(echo $HOME | sed 's/\//\\\//g')"'/~/g'
	done
}

Sync() {

Dest=~/Documents/ConfigFiles

echo -e "Copying to $Dest.\n" | tilde

Targets=(~/.{config/{gsimplecal,zathura,dunst,lf,mpv},local/scripts,tmux.conf,{vim,xinit,bash,input}rc} ~/{Notes,TODO}.txt /etc/X11/xorg.conf.d)
total=${#Targets[@]}

for i in $(seq 1 $total); do
	t="${Targets[i-1]}"
	echo "$i" "$total" \""$t"\" |\
	awk '{printf("(%'"${#total}"'d/%d) %s\n",$1,$2,$3)}' |\
	tr -d '"' | tilde
	cp -upR "$t" "$Dest"
done
echo 
}

notify-send "$(Sync)"


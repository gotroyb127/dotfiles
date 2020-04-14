#!/bin/bash

Dest=~/Documents/ConfigFiles



files=(~/.bashrc ~/.inputrc ~/.xinitrc ~/.vimrc ~/Notes.txt)
folders=("")


Folders=("gsimplecal i3 termite ranger zathura dunst htop lf" "scripts" "xorg.conf.d")
Parents=(~/.config/ ~/.local/ /etc/X11/)

targets=()

for i in $(seq 0 ${#Parents[@]}); do
	for ii in ${Folders[$i]}; do
		targets+=("${Parents[$i]}${ii}")
	done
done

targets+=(${files[@]})

total=${#targets[@]}

echo -e "Copying tagerts to $Dest...\n"

for ((a=0; a < $total; ++a)); do
	targ=${targets[$a]}
	echo -e "     ($((a+1))/${total}): copying $targ..."
	cp -R $targ $Dest
done


echo -e "Done.\n"



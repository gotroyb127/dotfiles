#!/bin/mksh

Sync() {
Dest=~/Documents/ConfigFiles



files=(~/.tmux.conf ~/.bashrc ~/.inputrc ~/.xinitrc ~/.vimrc ~/Notes.txt ~/TODO.txt)
folders=("")


Folders=("gsimplecal zathura dunst htop lf mpv" "scripts" "xorg.conf.d")
Parents=(~/.config/ ~/.local/ /etc/X11/)

targets=()

for i in $(seq 0 ${#Parents[@]}); do
	for ii in ${Folders[$i]}; do
		targets+=("${Parents[$i]}${ii}")
	done
done

targets+=(${files[@]})

total=${#targets[@]}

echo -e "Copying tagerts to $Dest.\n"

for a in $(seq 1 $total); do
	targ=${targets[$((a-1))]}
	echo -e "($((a))/${total}): $targ"
	cp -R $targ $Dest
done

echo -e "Done.\n"
}

notify-send "$(Sync)"

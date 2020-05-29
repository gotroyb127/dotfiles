#!/bin/mksh


# Show available updates on startup.
sleep 1.5

if [[ $(( $(date +%j) % 7 )) -le 1 ]]; then
	sudo pacman -Sy
	sudo pacman -Fy
	pacman -Quq || exit 1
	UpsNum=$(pacman -Quq | wc -l)
	notify-send -t 15000 $'Time for Updates!!!\nPacman: '\
\	"$UpsNum updates available." \
	"$(pacman -Qu | awk '{ printf("%-23s %s\n", $1, $NF) }' )"
fi


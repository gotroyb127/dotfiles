#!/usr/bin/sh


# Show available updates on startup.
if [[ $(( $(date +%j) % 7 )) -le 1 ]]; then
	UpsNum=$(pacman -Quq | wc -l)
	notify-send $'Time for Updates!!!\nPacman: '\
\	"$UpsNum updates available." \
	"$(pacman -Qu | awk '{ printf("%-23s %s\n", $1, $NF) }' )"
fi


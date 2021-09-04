#!/bin/sh

diff=diff
command -v colordiff > /dev/null &&
	diff=colordiff
cp='cp -vfR'

Ask() {
	printf '%s [y/n]: ' "$1"
	read ans
	[ "X$ans" = Xy ]
}

cd "${0%/*}"
for t in * .*
do
	case $t in
	(dunst|gsimplecal|lf|mpv|zathura|nvim|vis)
		DEST=${XDG_CONFIG_HOME:-$HOME/.config}
	;;
	(scripts|bin)
		DEST=$HOME/.local
	;;
	(.init.sh|.inputrc|.profile|.tmux.conf|.vimrc\
	|.xinitrc|.gdbinit|.keynavrc|.XCompose|.Xmodmap)
		DEST=$HOME
	;;
	(*)
		continue
	;;
	esac

	if [ -e "$DEST/$t" ]
	then
		$diff -u "$DEST/$t" "$t" &&
			continue
		query="Replace '$t'?"
	else
		query="Copy '$t'?"
	fi
	Ask "$query" &&
		$cp "$t" "$DEST"
done

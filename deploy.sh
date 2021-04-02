#!/bin/sh

diff=diff
command -v colordiff > /dev/null &&
	diff=colordiff
cp='cp -vfR'
# check if -u flag is supported
cp -u /dev/null /dev/zero 2> /dev/null &&
	cp="$cp -u"

Ask() {
	printf '%s [y/n]: ' "$1"
	read ans
	[ "X$ans" = Xy ]
}

for t in * .*
do
	case $t in
	(dunst|gsimplecal|lf|mpv|zathura|nvim)
		DEST=${XDG_CONFIG_HOME:-$HOME/.config}
	;;
	(scripts|bin)
		DEST=$HOME/.local
	;;
	(.init.sh|.inputrc|.profile|.tmux.conf|.vimrc\
	|.xinitrc|.keynavrc|.XCompose|.Xmodmap)
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

#!/bin/sh

for t in * .*
do
	case $t in
	(dunst|gsimplecal|lf|mpv|zathura|init.sh)
		DEST=${XDG_CONFIG_HOME:-$HOME/.config}
	;;
	(scripts)
		DEST=$HOME/.local
	;;
	(.inputrc|.profile|.tmux.conf|.vimrc|.xinitrc)
		DEST=$HOME
	;;
	(*)
		continue
	;;
	esac
	git diff "$DEST/$t" "$t"
	printf %s "Do you want to replace '$t'? [y/n]: "
	read REP
	[ "X$REP" = Xy ] && cp -vfR "$t" "$DEST"
done

#!/bin/sh

for t in * .*
do
	case $t in
	(dunst|gsimplecal|lf|mpv|zathura)
		DEST=${XDG_CONFIG_HOME:-$HOME/.config}
	;;
	(scripts|bin)
		DEST=$HOME/.local
	;;
	(init.sh|.inputrc|.profile|.tmux.conf|.vimrc|.xinitrc)
		DEST=$HOME
	;;
	(*)
		continue
	;;
	esac

	git diff "$DEST/$t" "$t"

	printf %s "Do you want to replace '$t'? [y/n]: "
	read reply
	[ "X$reply" = Xy ] && cp -vfR "$t" "$DEST"
done

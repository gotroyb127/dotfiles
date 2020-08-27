#!/bin/sh

for t in $(ls)
do
	case $t in
	(dunst|gsimplecal|lf|mpv|zathura)
		DEST=${XDG_CONFIG_HOME:-$HOME/.config}
	;;
	(scripts)
		DEST=$HOME/.local
	;;
	(*)
		DEST=$HOME
	;;
	esac
	git diff "$DEST/$t" "$t"
	printf %s "Do you want to replace '$t'? [y/n]: "
	read REP
	[ "X$REP" = Xy ] && cp -vfR "$t" "$DEST/$t"
done

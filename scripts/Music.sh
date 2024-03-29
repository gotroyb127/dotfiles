#!/bin/sh

if tmux.sh has -t Music 2> /dev/null
then
	tmux.sh attach -t Music
else
	tmux.sh new -s Music -c"$HOME/Music" $SHELL -ic lf \; \
		splitw -v MPV_PlaylistInfo \; \
		splitw -dh MPV_WatchLater \; \
		selectp -t1
fi

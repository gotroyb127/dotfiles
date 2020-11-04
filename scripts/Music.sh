#!/bin/sh

if tmux has -t Music 2> /dev/null
then
	tmux attach -t Music
else
	tmux new -s Music -c"$HOME/Music" $SHELL -ic lf \; \
		splitw -vl 35 MPV_PlaylistInfo \; \
		splitw -dh MPV_WatchLater \; \
		selectp -t1 \; \
		resizep -Z
fi

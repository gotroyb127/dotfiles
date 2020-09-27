#!/bin/sh

if tmux has -t Music 2> /dev/null
then
	tmux attach -t Music
else
	tmux new -s Music -c"$HOME/Music" $SHELL -ic lf \; \
		splitw -dvl 15 MPV_PlaylistInfo \; \
		splitw -dvl 8 MPV_WatchLater \;
fi

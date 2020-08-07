#!/bin/sh

if tmux has -t Music 2> /dev/null
then
	tmux attach -t Music
else
	tmux new -s Music '$SHELL -ic "lf ~/Music"' \; splitw -dvl 15 MpvWhatWatched.sh
fi


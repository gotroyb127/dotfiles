#!/bin/sh

if tmux has -t Music; then
	st -e tmux attach -t Music
else
	st -e tmux new -s Music '$SHELL -ic "lf ~/Music"' \; splitw -v MpvWhatWatched.sh
fi


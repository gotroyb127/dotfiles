#!/bin/sh

sessions=$(tmux ls | sed -n 's/^\([0-9]\+\):.*/\1/p' | sort -n)

new=0
for old in $sessions
do
	tmux rename -t $old $((++new))
done

#!/usr/bin/env bash

sessions=$(tmux ls | grep '^[0-9]\{1,\}:' | cut -f1 -d':' | sort -n)
echo $sessions

new=1
for old in $sessions
do
  tmux rename -t $old $new
  ((new++))
done

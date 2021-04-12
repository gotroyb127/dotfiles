#!/bin/sh

exec tmux -L tmux."$DISPLAY" "$@"

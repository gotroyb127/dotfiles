#!/bin/sh

if [ ! "X$USE_PIPEWIRE" = Xn ]
then
	pgrep pipewire >/dev/null || {
		pipewire &
		pipewire-pulse &
		pipewire-media-session &
	}
else
	pgrep pulseaudio >/dev/null || {
		pulseaudio -D
	}
fi

#!/bin/sh

if [ "X$USE_PULSEAUDIO" = Xy ]
then
	pgrep pipewire > /dev/null || {
		pipewire &
		pipewire-pulse &
		pipewire-media-session &
	}
else
	pgrep pulseaudio || {
		pulseaudio -D
	}
fi

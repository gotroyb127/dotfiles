#!/bin/sh

start() {
	! pgrep "^$1" >/dev/null &&
		"$@"
}

if [ ! "X$USE_PIPEWIRE" = Xn ]
then
	start pipewire &
	start pipewire-pulse &
	start wireplumber &
else
	start pulseaudio -D &
fi

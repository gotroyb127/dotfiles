#!/bin/sh

! pgrep pipewire && {
	pipewire &
	pipewire-pulse &
	pipewire-media-session &
}

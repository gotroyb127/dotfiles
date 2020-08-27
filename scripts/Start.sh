#!/bin/sh

# Synaptic settings for touchpad
#	TapButton1=1
synclient \
	TapButton1=0\
	TapButton2=3\
	TapButton3=2\
	HorizTwoFingerScroll=on\
	VertTwoFingerScroll=on\
	MinSpeed=0.5\
	MaxSpeed=3\
	AccelFactor=0.2\
	ClickTime=50\
	VertScrollDelta=-115\
	HorizScrollDelta=-60\
	VertTwoFingerScroll=1\
	HorizTwoFingerScroll=1\
	PalmDetect=1\

# Xorg settings
xset m 11/2 0
xset s 900 600
xset s noblank
xset r rate 250 25

[ $(pgrep Xorg | wc -l) -gt 1 ] && {
	pgrep QuickBlank.sh ||
		st QuickBlank.sh off
}

#xmodmap -e 'keycode 108 = Super_R'
setxkbmap -layout us,gr -option grp:alt_shift_toggle

sleep 1 && amixer -q set Capture nocap &

echo "${0##*/}: ----- KEYMAPS LOADED -----"

[ "X$1" != 'X-u' ] && exit 0
# Show available updates on startup.
AutoUpdate.sh

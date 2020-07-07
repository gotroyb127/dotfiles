#!/bin/ksh

# Synaptic settings for touchpad
synclient TapButton1=1\
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

# Xotg settings
xset m 11/2 0
xset s 900 600
xset s noblank
xset r rate 250 25
setxkbmap -layout us,gr -option grp:alt_shift_toggle

# xrandr settings
#xrandr --output HDMI1 --primary
#xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
#xrandr --addmode HDMI1 "1920x1080_60.00"
#xrandr --output HDMI1 --mode 1920x1080_60.00


# Show available updates on startup.
AutoUpdate.sh

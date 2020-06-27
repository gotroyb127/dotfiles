####

xset m 11/2 0
xset s 900 600
xset s noblank
xset r rate 250 25
setxkbmap -layout us,gr -option grp:alt_shift_toggle
#setxkbmap -model hpmini110 -layout us,gr -option grp:alt_shift_toggle
#xmodmap -e "keycode x = Key_Name"

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
	PalmDetect=1\

#xrandr --output HDMI1 --primary
#xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
#xrandr --addmode HDMI1 "1920x1080_60.00"
#xrandr --output HDMI1 --mode 1920x1080_60.00

clipmenud &
dunst 2> /dev/null &
lxqt-policykit-agent 2> /dev/null &
unclutter --timeout 1 --ignore-scrolling &

xsidle.sh 'slock' 'systemctl suspend' &
Start.sh &
dwmblocks &

exec dwm

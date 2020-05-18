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

xrandr --output HDMI1 --primary


clipmenud &
dunst 2> /dev/null &
lxqt-policykit-agent 2> /dev/null &
unclutter --timeout 1 --jitter 25 --ignore-scrolling &

xsidle.sh 'slock' 'systemctl suspend' &
Start.sh &
dwmblocks.sh &

exec dwm


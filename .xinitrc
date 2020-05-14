####

xset m 11/2 0
xset s 900 600
xset s noblank
xset r rate 250 25
xsidle.sh 'slock' 'systemctl suspend' &

xrandr --output HDMI1 --primary

dunst 2> /dev/null &
clipmenud &
lxqt-policykit-agent 2> /dev/null &
unclutter --timeout 1 --jitter 25 --ignore-scrolling &
#nm-applet &
dwmblocks.sh &

Start.sh &

exec dwm


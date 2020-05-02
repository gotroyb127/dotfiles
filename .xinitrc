####

xset m 11/2 0
xset s 900 600
xset s noblank
xset r rate 200 20
xsidle.sh slock &

xrandr --output HDMI1 --primary

dunst &
clipmenud &
lxqt-policykit-agent &
unclutter --timeout 1 --jitter 25 --ignore-scrolling &
#nm-applet &
dwmblocks &

start.sh

exec dwm


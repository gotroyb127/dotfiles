##

xset m 11/2 0
xset s 900 600
xset s blank
xset r rate 250 22

xrandr --output HDMI1 --primary

dunst &
clipmenud &
lxqt-policykit-agent &
unclutter --timeout 1 &

nm-applet &
#copyq &

dwmblocks &

#while :; do
#	ssh-agent dwm
#done

exec dwm
#exec i3
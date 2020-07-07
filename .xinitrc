####

Start.sh &

dwmblocks &
clipmenud &
dunst 2> /dev/null &
lxqt-policykit-agent 2> /dev/null &
xsidle.sh 'slock' 'systemctl suspend' &
unclutter --timeout 1 --ignore-scrolling &

# start window manager
exec dwm

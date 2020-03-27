#!/bin/bash

xset m 11/2 0
xset s 900 600
xset s blank
xset r rate 300 25

xrandr --output HDMI1 --primary

copyq &
unclutter --timeout 1 &
nm-applet


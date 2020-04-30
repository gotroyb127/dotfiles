#!/bin/mksh

#echo -n '   '
#echo -n $(date +"%I:%M:%S %p.| %a %d %b %Y") | sed 's/\([ :]\|^\)0/\1/g'
#echo -n ' '

echo -n '   '
echo -n $(date +"%-I:%-M:%-S %p.| %a %-d %b %Y")
echo -n ' '

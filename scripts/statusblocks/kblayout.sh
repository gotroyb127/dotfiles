#!/bin/mksh

#printf "["
printf " "
[ "$(xkblayout-state print %s)" = 'gr' ] && printf 'el' || printf 'us'
#printf "]"


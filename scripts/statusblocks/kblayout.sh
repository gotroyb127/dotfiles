#!/bin/sh

printf ' '
[ "$(xkblayout-state print %s)" = 'gr' ] && printf 'el' || printf 'us'

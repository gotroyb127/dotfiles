#!/bin/bash

case $button in
	1|4|5)
		xkblayout-state set +1
		;;
esac

kblay=$(xkblayout-state print %s)

case $kblay in
	us)
		echo "us"
		;;
	gr)
		echo "el"
		;;
	*)
		echo "!!"
		;;
esac

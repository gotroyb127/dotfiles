#!/bin/mksh

case $button in
	1|4|5)
		xkblayout-state set +1 ;;
esac

kblay=$(xkblayout-state print %s)

case $kblay in
	gr)
		echo "el";;
	*)
		echo "us";;
esac

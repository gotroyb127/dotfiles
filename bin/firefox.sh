#!/bin/sh

firefox=firefox-developer-edition

case $1 in
(p)
	args='-P 1Private'
	shift
;;
(0)
	args='-P 0Accounts'
	shift
;;
(1)
	args='-P 1Accounts'
	shift
;;
esac

exec "$firefox" $args "$@"

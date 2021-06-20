#!/bin/sh

firefox=firefox-developer-edition

args=
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
(2)
	args='-P KeepCookies'
	shift
;;
(3)
	args='-P 1Private'
	shift
;;
esac

exec "$firefox" $args "$@"

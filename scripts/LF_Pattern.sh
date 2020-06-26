#!/bin/sh

if [ "$1" = "-type" ]; then
	f_args='-type f'
	shift 2
else
	f_args=
fi

find "$PWD" $f_args | grep "[^/]*$@[^/]*$" | sort

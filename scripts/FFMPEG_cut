#!/bin/sh

set -o nounset

if [ "X$1" = 'X-recode' ]
then
	Copy=
	shift
else
	Copy='-c copy'
fi

from=$2
to=$3
if=$1
of=$4

ffmpeg -to "$to" -i "$if" -ss "$from" $Copy "$of"

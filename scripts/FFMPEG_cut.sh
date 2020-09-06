#!/bin/sh

set -o nounset

from=$2
to=$3
if=$1
of=$4

ffmpeg -t "$to" -i "$if" -ss "$from" -c copy "$of"

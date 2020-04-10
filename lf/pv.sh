#!/bin/mksh

Text() {
local OPTIONS="--stdout --out-format=ansi --failsafe --line-range=1-$2"
highlight $OPTIONS "$1"
}

Text "$1"

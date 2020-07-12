#!/bin/sh

MAX=200

ToggleSel() {
	lf -remote "send $id togglesel$F"
	F= ; i=0
}

F= ; i=0
while read -r file; do
	[ -z "$file" ] && continue

	F="$F \"$file\""

	[ "$((++i))" -ge $MAX ] &&
	    ToggleSel
done
ToggleSel

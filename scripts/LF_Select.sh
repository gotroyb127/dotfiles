#!/bin/ksh

# Reads file names from stdin and selects them in lf.

N="$(printf '\n\b')"
while read -r file; do
	echo "send $id select '$file'${N}send $id toggle" >&2
	[ -z "$file" ] && continue
	lf -remote "send $id select '$file'${N}send $id toggle"
done

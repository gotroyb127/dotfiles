#!/bin/sh

# Reads file names from stdin and selects them in lf.

N="
"
while read -r file; do
	[ -z "$file" ] && continue
	lf -remote "send $id select '$file'${N}send $id toggle"
done
lf -remote "send $id select '$f'"

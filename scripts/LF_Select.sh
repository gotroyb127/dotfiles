#!/bin/ksh

# Reads file names from stdin and selects them in lf.

N="${IFS#??}"
while read -r file; do
	[ -z "$file" ] && continue
	lf -remote "send $id select '$file'${N}send $id toggle"
done

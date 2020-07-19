#!/bin/sh

IFS='
'
OP="$1"
DEST="$2"
NO_DUPS="$3"

if [ -z "$DEST" -o -z "$OP" ]; then
	echo "$0: Wrong arguments."
	exit 0
fi

for i in $fx; do
	d=$(dirname "$i")

	[ -n "$NO_DUPS" -a "$d" = "$DEST" ] && continue
	i=$(basename "$i")
	if [ ! -e "$DEST/$i" ]; then
		$OP "$d/$i" "$DEST"
		continue
	fi
	read p s <<- EOF
	$(echo "$i" | sed 's/\(.*\) (\([0-9]\+\))/\1\n\2/')
	EOF
	[ -z "$s" ] && s=1 || s=$((s+1))
	newn="$DEST/$p ($s)"
	while [ -e "$newn" ]; do
		newn="$DEST/$p ($((s+=1)))"
	done
	$OP "$d/$i" "$newn"
done

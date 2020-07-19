#!/bin/ksh

echo -n 'Jump to pattern: '
read Pattern

i=0
IFS='
'
for Matches[i] in $(unset IFS; LF_Pattern.sh "$@" $Pattern);
do
	((++i))
done

[ "$i" -eq 0 ] && printf '\e[7;31;47m%s\e[0m' "Pattern not found" && exit 1
[ "$i" -eq 1 ] && echo 'Only one match found.' && E=' ' || E=

LfSelect() {
	t="${Matches[c]}"
	lf -remote "send $id select '$t'"
	[ -d "$t" ] || t=$(dirname "$t") && lf -remote "send $id select '$t'"
}

c=0
LfSelect
[ -n "$E" ] && exit 0

while echo -n "Matches for '$Pattern': ($((c+1))/$i) [N/n]: " && read ans
do
	case "$ans" in
	(n*|j*)
		c=$(( (c+1) %i ));;
	(N*|k*)
		((--c))
		[ "$c" -lt 0 ] && c=$((i-1));;
	(a)
		lf -remote "send $id select '$f'"
		break;;
	(q)
		break;;
	esac
	LfSelect
done

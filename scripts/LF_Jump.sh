#!/bin/ksh

Read() {
	echo -n "$1"
	shift
	read "$@"
}

lfselect() {
	lf -remote "send $id select '$1'"
}

Select() {
	t=${Matches[c]}
	lfselect "$t"
	[ ! -d "$t" ] && {
		t=${t%/*}
		lfselect "$t"
	}
}

Read 'Jump to pattern: ' Pattern

i=0
IFS='
'
for Matches[i] in $(unset IFS; LF_Pattern.sh "$@" $Pattern)
do
	((++i))
done

if [ "$i" -eq 0 ]
then
	printf '\e[7;31;47m%s\e[0m' "Pattern not found"
	exit 1
elif [ "$i" -eq 1 ]
then
	echo 'Only one match found.'
	E=' '
else
	E=
fi

c=0
Select
[ -n "$E" ] && exit 0

while Read "Matches for '$Pattern': ($((c+1))/$i) [N/n]: " ans
do
	case "$ans" in
	(n|j)
		c=$(( (c+1) %i ))
	;;
	(N|k)
		((--c))
		[ "$c" -lt 0 ] && c=$((i-1))
	;;
	(s)
		lfselect "${Matches[c]}"
		break
	;;
	(a)
		lfselect "$f"
		break
	;;
	(q)
		break
	;;
	esac
	Select
done

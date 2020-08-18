#!/bin/sh

ls_size() {
	awk '/^[^dltσ]/ { printf $5"\t"; for(i=9; i<NF; ++i){printf $i" "} print $NF}'
}

[ -z "$fs" ] && {
	du -hd1 | sort -hr
	ls -Shla | ls_size
	exit
}

for t in $(echo "$fs" | sed "s\`$PWD/\`\`")
do
	[ -d $t ] && {
		du -hd0 $t
		continue
	}
	ls -Shl $t | ls_size
done

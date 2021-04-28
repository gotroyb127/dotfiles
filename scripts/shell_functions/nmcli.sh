#!/bin/sh
nmcli.sh() {
	nmcli
	while read a && [ "X$a" != Xq ]
	do
		nmcli
	done
}

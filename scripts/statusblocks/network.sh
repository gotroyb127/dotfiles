#!/bin/mksh

case $(nmcli networking connectivity) in
	'full')    st=' o';;
	'limited') st='勒 ?';;
	*)         st='勒 x';;
esac

case $(nmcli radio wifi) in
	'disabled') wifis='';;
	'enabled')  wifis=' 直';;
	*)          wifis=' 睊 ?';;
esac

echo -n "$wifis $st "

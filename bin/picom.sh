#!/bin/sh

IFS='
'
bg=
shadow=
fading='--no-fading-openclose'
transp="--active-opacity${IFS}1.0${IFS}--inactive-opacity${IFS}1.0"
dim=
invert=

usage() {
	exec >&2
	cat << EOF
usage: ${0##*/} [-bg [bg_color | image | y]] [-s] [-f] [-t] [-d] [-i] [--] picom_args...
EOF
	exit 1
}

while [ $# -gt 0 ]
do
	[ "X$(printf '%c' "$1")" != X- ] &&
		usage
	o=${1#?}
	while [ -n "$o" ]
	do
		# first character of $o
		case $(printf '%c' "$o") in
		(b)
			[ "X$o" != Xbg ] || [ $# -lt 2 ] &&
				usage
			o=${o#?}
			bg=$2
			shift
		;;
		(s)
			shadow='--shadow'
		;;
		(f)
			fading=
		;;
		(t)
			transp="--active-opacity${IFS}0.95"
			transp="${transp}${IFS}--inactive-opacity${IFS}0.85"
		;;
		(d)
			dim="--inactive-dim${IFS}0.2"
		;;
		(i)
			invert="--invert-color-include${IFS}class_i ~="
			invert="$invert '^dwm$|^st-256color$|^dmenu$'"
		;;
		(-)
			shift
			break 2
		;;
		(*)
			usage
		;;
		esac
		o=${o#?}
	done
	shift
done

[ -n "$bg" ] &&
	if [ -e "$bg" ]
	then
		hsetroot -center "$bg" > /dev/null
	elif [ "X$bg" = Xy ]
	then
		hsetroot -center ~/Pictures/wall.jpg > /dev/null
	else
		hsetroot -solid "$bg"
	fi

ExecPicom() {
	echo picom
	printf '\t%s\n' "$@"
	exec picom "$@"
}

ExecPicom $shadow $fading $transp $dim $invert "$@"

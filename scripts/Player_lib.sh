#!/bin/sh

pidf=${TMPDIR-/tmp}/Player.sh.pause-after.pid
TestSocket() {
	[ -S "$MPVSOCKET" ] ||
		exit
}
Socat() {
	socat - "$MPVSOCKET" 2> /dev/null
}
Command() {
	printf '{ "command": [%s] }\n' "$1" | Socat > /dev/null
}
SetP() {
	Command '"set_property", '"$1"
}
Notify() {
	notify-send -t 2000 "$1" "$(date +'%-I:%-M:%-S %p.')"
}
TimeToSecs() {
	awk -F: '{
		for (i = NF; i > 0; i--)
			Secs += $i * (60 ^ (NF-i))
		print Secs
	}'
}
Info() {
	TestSocket
	printf '{ "command": ["get_property", "%s"] }\n' "$@" \
		| Socat | jq -cr '.data'
}
SetInfoVars() {
	for v in $1
	do
		read $v
	done <<- EOF ||
	$(Info $2)
	EOF
		exit
}
SetTimeVars() {
	while [ $# -gt 0 ]
	do
		SecsToTime "$1" "$2"
		shift 2
	done
}
SecsToTime() {
	t=${2%.*}
	m=$(((t/60) % 60))
	s=$((t % 60))
	if [ "$((h = t/3600))" != 0 ]
	then
		o="$h:$m:$s"
	elif [ "$m" != 0 ]
	then
		o="$m:$s"
	else
		o="$s"
	fi
	eval "$1='$o'"
}

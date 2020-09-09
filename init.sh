# only usefull when the shell is interactive
[ -z "${-##*c*}" ] && return

set -o notify -o vi -o vi-tabcomplete

HISTFILE=${XDG_CONFIG_HOME:-"$HOME/.config"}/shell_history
HISTCONTROL='ignoredups:ignorespace'
HISTSIZE=1000
[ -z "$LF_LEVEL" ] &&
	let LF_LEVEL=1 ||
	let LF_LEVEL++
export LF_LEVEL

alias \
	='clear -x 2> /dev/null || clear'\
	ls='ls --color=auto'\
	ll='ls -l'\
	la='ls -al'\
	lA='ls -Al'\
	vim='nvim'\
	view='nvim -MR'\
	mpvs="mpv --input-ipc-server=$MPVSOCKET"\
	SU='sudo ksh -il'\
	LOG='vim "$STARTX_LOG"'\
	PLAYER='COLS=$COLUMNS sblocks-player'\
	mksh='HISTFILE= ENV= mksh -o vi'\
	dash='HISTFILE= ENV= dash'\
	bash='HISTFILE= ENV= bash'\
	youtube-dl="youtube-dl -f mp4 --audio-format mp3 -o '%(title)s.%(ext)s'"\
	CompileInstall='make clean && make && sudo make install && make clean'\
	BuildLf='go mod vendor; ./gen/build.sh -mod=vendor -trimpath'\

## Functions to automate de-bloat on Android with adb
#AdbGetFocus() {
#	F="$(adb shell dumpsys window windows | tr '/' '\n' | grep mCurrentFocus | awk '{print $3}')"
#	echo "$F" 1>&2; echo "$F"
#}
#AdbUnistall() {
#	adb shell pm uninstall -k --user 0 W}

LF() { let --LF_LEVEL; exec "$0" -ic "lf $1"; }
Hist() { [ $# -ge 1 ] && grep "$@" "$HISTFILE"; }
exec_ksh() { let --LF_LEVEL; exec ksh "$@"; }

mantopdf() {
	groff -m man "$1" -Tpdf 2> /dev/null | zathura - 2> /dev/null
}

SET_PS1() {
# 8-bit (256-color) '\e[<args>m' arguments are `5;<n>` or `2;<r>;<g>;<b>`

#	?='\[\e[38;2;;;m\]'
#	local T='\[\e[38;2;255;207;240m\]'
#	local U='\[\e[38;2;66;235;255m\]'
#	local H='\[\e[38;2;255;253;154m\]'
	local B='\[\e[38;2;15;251;191m\]'
	local T='\[\e[38;2;255;255;190m\]'
	local D='\[\e[38;2;100;205;255m\]'
	local P='\[\e[38;2;0;255;255m\]'
	local N='\[\e[0;0m\]'

	local s='>'
	local LVL=$LF_LEVEL

	if [ "$USER" = root ]
	then
		local D='\[\e[38;2;200;0;0m\]'
		s='#'
	fi

	ExtStatus() {
		local s=$?
		local Sb='\[\e[1;31m\]'
		local S='\[\e[0;31m\]'
		[ "$s" -ne 0 ] && echo -n "$S[$Sb$s$S] "
		return $s
	}


#	PS1="\e[${1:-2} q$B[$T\t$B] $U\u$N@$H\h $D\w\n\$(ExtStatus)$P> $N"
	PS1="\e[${1:-2} q$B[$T\D{%-I:%-M:%-S}$B] $LVL $D\w\n\$(ExtStatus)$P$s $N"
}

WHO() {
	local U='\033[38;2;66;235;255m'
	local H='\033[38;2;255;253;154m'
	local N='\033[0;0m'
	echo "$U$USER$N@$H$(hostname) " >&2
}

SET_PS1 2
PS2=

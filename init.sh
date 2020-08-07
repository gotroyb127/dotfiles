# only usefull when the shell is interactive
[ "${-#*i}" = "$-" ] && return

set -o vi -o vi-tabcomplete

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
	mksh='HISTFILE= ENV= mksh'\
	dash='HISTFILE= ENV= dash'\
	bash='HISTFILE= ENV= bash'\
	CompileInstall='make clean && make && sudo make install && make clean'\
	BuildLf='go mod vendor; ./gen/build.sh -mod=vendor -trimpath'\

## Functions to automate de-bloat on Android with adb
#AdbGetFocus() {
#	F="$(adb shell dumpsys window windows | tr '/' '\n' | grep mCurrentFocus | awk '{print $3}')"
#	echo "$F" 1>&2; echo "$F"
#}
#AdbUnistall() {
#	adb shell pm uninstall -k --user 0 W}

hist () {
	[ $# -ge 1 ] && grep "$@" "$HISTFILE"
}

mantopdf() {
	groff -m man "$1" -Tpdf 2> /dev/null | zathura - 2> /dev/null
}

SET_PS1 () {
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
	PS1="\e[${1:-2} q$B[$T\t$B] $LVL $D\w\n\$(ExtStatus)$P$s $N"
}

SET_PS1 4
PS2=

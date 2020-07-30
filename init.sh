# only usefull when the shells is in interactive mode
[ "${-#*i*}" = "$-" ] && exit 5

HISTFILE="${XDG_CONFIG_HOME:-"$HOME/.config"}/shell_history"
HISTCONTROL="ignoredups:ignorespace"
HISTSIZE=1000
#export SHELL_LVL=$((${SHELL_LVL-0}+1))

alias \
	='clear -x 2> /dev/null || clear'\
	ls='ls --color=auto'\
	ll='ls -l'\
	la='ls -al'\
	vim='nvim'\
	view='nvim -MR'\
	mpvs="mpv --input-ipc-server=$MPVSOCKET"\
	ksh='SHELL_LVL=$((SHELL_LVL+1)) ksh'\
	mksh='env -u HISTFILE -u ENV mksh'\
	bash='bash +o history'\
	dash='env -i dash'\
	CompileInstall='make clean && make && sudo make install && make clean'\
	BuildLf='go mod vendor; ./gen/build.sh -mod=vendor -trimpath'\

set -o vi -o vi-tabcomplete

## Functions to automate de-bloat on Android with adb
#AdbGetFocus() {
#	F="$(adb shell dumpsys window windows | tr '/' '\n' | grep mCurrentFocus | awk '{print $3}')"
#	echo "$F" 1>&2; echo "$F"
#}
#AdbUnistall() {
#	adb shell pm uninstall -k --user 0 $1
#}

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

	if [ "$USER" = root ]; then
		local D='\[\e[38;2;200;0;0m\]'
		s='#'
	fi

	ExtStatus() {
		local s=$?
		local Sb='\[\e[1;31m\]'
		local S='\[\e[0;31m\]'
		local N='\[\e[0;0m\]'
		[ "$s" -ne 0 ] && echo -n "$S[$Sb$s$S] "
#		[ "$s" -ne 0 ] && printf "$N($Sb$s$N) "
#		[ "$s" -ne 0 ] && printf "%s" "($s) "
		return $s
	}

	Lvls() {
		echo -n "${SHELL_LVL}${LF_LEVEL:-0} "
#		echo -n "${SHELL_LVL} "
	}

#	PS1="\e[${1:-2} q$B[$T\t$B] $U\u$N@$H\h $D\w\n\$(ExtStatus)$P> $N"
	PS1="\e[${1:-2} q$B[$T\t$B] \$(Lvls)$D\w\n\$(ExtStatus)$P$s $N"
}

SET_PS1 4
PS2=

HISTFILE="${XDG_CONFIG_HOME:-"$HOME/.config"}/shell_history"
export HISTCONTROL="ignoredups:ignorespace"

alias	='clear -x 2> /dev/null || clear'\
	ls='ls --color=auto'\
	la='ls -al'\
	vim='nvim'\
	view='nvim -MR'\
	mpvs='mpv --input-ipc-server=/tmp/mpvsocket'\
	CompileInstall='make clean && make && sudo make install && make clean'\
	BuildLf='export GOPATH="$PWD/gopath"; go mod vendor; version=r$pkgver ./gen/build.sh -mod=vendor -trimpath'\
	mksh='env -i mksh'\
	bash='env -i bash'\

set -o vi
set -o vi-tabcomplete

## Functions to automate de-bloat on Android with adb
#AdbGetFocus() {
#	F="$(adb shell dumpsys window windows | tr '/' '\n' | grep mCurrentFocus | awk '{print $3}')"
#	echo "$F" 1>&2; echo "$F"
#}
#AdbUnistall() {
#	adb shell pm uninstall -k --user 0 $1
#}

SET_PS1 () {
# 8-bit (256-color) '\e[<args>m' arguments are `5;<n>` or `2;<r>;<g>;<b>`

#	?='\[\e[38;2;;;m\]'
#	local B='\[\e[38;2;15;251;191m\]'
#	local T='\[\e[38;2;255;207;240m\]'
#	local U='\[\e[38;2;66;235;255m\]'
#	local H='\[\e[38;2;255;253;154m\]'
#	local D='\[\e[38;2;100;205;255m\]'
#	local P='\[\e[38;2;255;150;0m\]'
#	local N='\[\e[0;0m\]'

	ExtStatus() {
		local s=$?
#		local Sb='\[\e[1;31m\]'
#		local S='\[\e[0;31m\]'
#		[ "$s" -ne 0 ] && printf "$S[$Sb$s$S] "
		[ "$s" -ne 0 ] && printf "($s) "
		return $s
	}

#	PS1="\e[${1:-2} q$B[$T\t$B] $U\u$N@$H\h $D\w\n\$(ExtStatus)$P> $N"
#	PS1="\e[${1:-2} q[\t] \u@\h \w\n\$(ExtStatus)\$ "
	PS1="\e[${1:-2} q[\t] \w\n\$(ExtStatus)\$ "
}

SET_PS1 4
PS2="	"

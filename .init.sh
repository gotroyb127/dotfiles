# only usefull when the shell is interactive
[ -z "${-##*c*}" ] && return

set \
	-o vi\
	-o notify\
	-o pipefail

HISTFILE=${XDG_CONFIG_HOME:-"$HOME/.config"}/shell_history
HISTCONTROL='ignoredups:ignorespace'
HISTSIZE=1000
LF_LEVEL=$((${LF_LEVEL:-0} + 1))

export LF_LEVEL

if ls --color=auto >/dev/null 2>&1
then
	alias ls='ls --color=auto'
fi
alias \
	E='set -o emacs'\
	ll='ls -l'\
	la='ls -al'\
	lA='ls -Al'\
	vim='nvim'\
	view='nvim -MR'\
	SU='sudo --preserve-env=LF_LEVEL ksh -l'\
	LOG='vim "$ULOG"'\
	XLOG='vim "$STARTX_LOG"'\
	LOGIN='exec_ksh -l'\
	mksh='HISTFILE= ENV= mksh -o vi'\
	dash='HISTFILE= ENV= dash'\
	bash='HISTFILE= ENV= bash'\
	yt-dl="youtube-dl -f mp4 --audio-format mp3 -o '%(title)s.%(ext)s'"\
	scrcpy="scrcpy --shortcut-mod 'lalt+lctrl'"\
	MakeInstall='make && sudo make install'\

LF() {
	let --LF_LEVEL
	exec "$0" -ic "lf $1"
}
exec_ksh() {
	let --LF_LEVEL
	exec ksh "$@"
}
SET_PS1() {
#	?='\[\033[38;2;;;m\]'
	local B='\[\033[38;2;15;251;191m\]'
	local T='\[\033[38;2;255;200;170m\]'
	local L='\[\033[38;2;95;255;135m\]'
	local U='\[\033[38;2;66;235;255m\]'
	local H='\[\033[38;2;8;255;166m\]'
	local D='\[\033[38;2;128;128;255m\]'
	local P='\[\033[38;2;0;255;255m\]'
	local N='\[\033[0;0m\]'

	local C=
	local W=
	local s='>'
	local LVL=$LF_LEVEL

	[ "X$USER" = Xroot ] && {
		D='\[\033[38;2;255;0;0m\]'
		s='#'
	}
	while [ $# -gt 0 ]
	do
		case $1 in
		(-w)
			W="$U\u$N@$H\h "
			shift 1
		;;
		(-c[0-9])
			C="\033[${1#-c} q"
			shift 1
		;;
		(-c)
			C="\033[${2} q"
			shift 2
		;;
		(*)
			shift 1
		;;
		esac
	done

	ExtStatus() {
		local s=$?
		local Sb='\[\033[1;31m\]'
		local S='\[\033[0;31m\]'
		[ "$s" -ne 0 ] && echo -n "$S[$Sb$s$S] "
		return $s
	}

	PS1="$C$B[$T\D{%-I:%-M:%-S}$B] $L$LVL $W$D\w\n\$(ExtStatus)$P$s $N"
}
WHO() {
	local U='\033[38;2;66;235;255m'
	local H='\033[38;2;8;255;166m'
	local N='\033[0;0m'
	echo "$U$USER$N@$H$(hostname)"
}

SET_PS1
PS2=

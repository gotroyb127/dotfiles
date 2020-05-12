#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Colored prompt
c1='\[\033[1;38;5;111m\]'
c2='\[\033[1;38;5;45m\]'
c3='\[\033[1;38;5;42m\]'
#c4='\[\033[1;38;5;153m\]'
c4='\[\033[1;38;5;105m\]'
c5='\[\033[1;38;5;219m\]'
c6='\[\033[0;38;5;195m\]'
c7='\[\033[1;38;5;7m\]'
c1="$c7"
end='\[\033[00m\]'

PS1="${c1}[${c2}\u${c6}@${c3}\H${c7}:${c4}\w${c1}]$c5\$ ${end}"
unset c{1..7} end

# In order to have colors when connected via ssh: 
#TERM=xterm-256color
alias SSH='TERM=xterm-256color luit -encoding ISO-8859-7 ssh'

export XDG_CACHE_HOME="$HOME/.local/var/cache"
export XDG_CONFIG_HOME="$HOME/.local/etc"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/var/lib"
export XDG_LIB_HOME="$HOME/.local/lib"
export XDG_LOG_HOME="$HOME/.local/var/log"

export EDITOR=vim
export PAGER=less
#export PAGER='w3m -t 20 -s -num'
# climenud: manage only the clipboard
export CM_SELECTIONS=clipboard

PATH+=":$HOME/.local/scripts"

viman() { /usr/bin/man "$1" | col -b | vim -MR - ; }

alias 	man=viman\
	view='vim -MR'\
	mpvs='mpv --input-ipc-server=/tmp/mpvsocket'\
	cdl='cd ~/.local'\
	cds='cd ~/.local/scripts'\
	cdc='cd ~/.config'\
	cdd='cd ~/Documents'\
	Startx='startx 2>> /tmp/startx.log'


set -o vi
#shopt -s autocd

if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  startx 2>> "/tmp/startx($XDG_VTNR).log"
fi
if [[ $(ps --no-header --pid=$PPID --format=cmd) != "fish" ]]
then
	exec fish
fi



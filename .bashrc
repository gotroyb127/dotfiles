#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Colored prompt
c1='\[\033[0;38;5;69m\]'
c2='\[\033[0;38;5;51m\]'
c3='\[\033[0;38;5;40m\]'
c4='\[\033[0;38;5;228m\]'
c5='\[\033[1;38;5;216m\]'
c6='\[\033[0;38;5;4m\]'
end='\[\033[00m\]'

PS1="${c1}[${c2}\u${c6}@${c3}\H ${c4}\w${c1}]$c5\$ ${end}"
unset c{1..6} end

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


set -o vi


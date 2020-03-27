#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
#PS1='[\u@\h \W]\$ '


#red='\e[0;38;5;69m'
#blue='\e[0;38;5;51m'
#green='\e[0;38;5;40m'
#yellow='\e[0;38;5;228m'
#orange='\e[1;38;5;216m'
#brown='\e[0;38;5;4m'
#end='\033[0m'

#PS1="${red}[${end}${blue}\u${end}${brown}@${end}${green}\H${end}${red}]${end}${yellow}\w${end}${orange}\$ ${end}"
#PS1="${red}[${blue}\u${brown}@${green}\H${red}]${yellow}\w${orange}\$ ${end}"

# Colored prompt
c1='\[\033[0;38;5;69m\]'
c2='\[\033[0;38;5;51m\]'
c3='\[\033[0;38;5;40m\]'
c4='\[\033[0;38;5;228m\]'
c5='\[\033[1;38;5;216m\]'
c6='\[\033[0;38;5;4m\]'
end='\[\033[00m\]'

PS1="${c1}[${c2}\u${c6}@${c3}\H ${c4}\w${c1}]$c5\$ ${end}"

# In order to have colors when connected via ssh: 
TERM=xterm-256color
export EDITOR=vim

# Extended bash completition
complete -cf sudo
complete -c man

EditConfigs () {
local files=("$HOME/.config/i3/config" "$HOME/.config/i3/i3blocks/i3blocks.conf")
  
#assign a default value: geany
local inp=$1
echo ${inp:=geany} > /dev/null

$inp ${files[@]}
}

set -o vi


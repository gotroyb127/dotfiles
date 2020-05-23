#set -U fish_greeting
#fish_vi_key_bindings
#set -U fish_prompt_pwd_dir_length 0
#set -U fish_escape_delay_ms 10

#set -U fish_color_user '42E1FF'
#set -U fish_color_host 'FFFD9A'
#set -U fish_color_host '00CE81'
#set -U fish_color_cwd 'DCF000'
#set -U fish_color_cwd_root 'FF1F00'
#set -U fish_color_time 'FFB599'
#set -U fish_color_braces 'FFFCAD'

#viman() { /usr/bin/man "$1" | col -b | vim -MR - ; }

alias mpvs='mpv --input-ipc-server=/tmp/mpvsocket'
alias view='vim -MR'

abbr SSH 'env TERM=xterm-256color luit -encoding ISO-8859-7 ssh'

abbr cdl 'cd ~/.local'
abbr cdc 'cd ~/.local/etc'
abbr cds 'cd ~/.local/scripts'
abbr cdd 'cd ~/Documents'
abbr cdD 'cd ~/Downloads'
abbr p pacman
abbr P 'sudo pacman'

abbr Startx 'startx &>> /tmp/startx.log'
abbr Compile 'make clean && make && sudo make install && make clean'
abbr KillTEAMS 'pkill "^teams\$"'
abbr WhatWatched MpvWhatWatched



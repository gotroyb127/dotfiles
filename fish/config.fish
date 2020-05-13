#set -U fish_greeting
#fish_vi_key_bindings
#set -U fish_prompt_pwd_dir_length 0
#set -U fish_escape_delay_ms 10

#set -U fish_color_user '00D7FF'
#set -U fish_color_host 'FFF03D'
#set -U fish_color_host 'DDC2FF'
#set -U fish_color_cwd '00FF50'

alias mpvs='mpv --input-ipc-server=/tmp/mpvsocket'
abbr YamahaMD xfce4-appfinder

abbr cdl 'cd ~/.local'
abbr cdc 'cd ~/.local/etc'
abbr cds 'cd ~/.local/scripts'
abbr cdd 'cd ~/Documents'
abbr cdD 'cd ~/Downloads'
abbr p pacman
abbr P 'sudo pacman'
abbr Startx 'startx 2>> /tmp/startx.log'
abbr Compile 'make clean && make && sudo make install && make clean'
abbr KillTEAMS 'pkill "^teams\$"'



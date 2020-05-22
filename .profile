#
# -_-
#

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

export PATH+=":$HOME/.local/scripts"

if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  startx &>> "/tmp/startx($XDG_VTNR).log"
fi
if [[ $(ps --no-header --pid=$PPID --format=cmd) != "fish" ]]
then
	exec fish
fi


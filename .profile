#!/bin/sh

echo 'Sourcing ~/.profile'

export XDG_CACHE_HOME=$HOME/.local/var/cache
export XDG_CONFIG_HOME=$HOME/.local/etc
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/var/lib
export XDG_LIB_HOME=$HOME/.local/lib
export XDG_LOG_HOME=$HOME/.local/var/log

export ENV=$HOME/.init.sh
export PATH=$PATH:$HOME/.local/scripts:$HOME/.local/bin
export PATH=$HOME/.cargo/bin:$PATH
export FPATH=$HOME/.local/scripts/shell_functions

export PAGER=less
export EDITOR=nvim
export OPENER=Open.sh
export MANPAGER='nvim +Man!'
export CS_SELECTIONS=clipboard

export TRASH=$HOME/.local/trash
export TMPDIR=${TMPDIR:-/tmp}
export STARTX_LOG=$TMPDIR/startx-auto.log
export MPVSOCKET=$TMPDIR/mpvsocket
if command -v systemctl >/dev/null
then
	MACHINECTL=systemctl
else
	MACHINECTL=loginctl
fi
export MACHINECTL

# keep ~/ clean ?
export LESSHISTFILE='-'
export GOPATH=${XDG_DATA_HOME:-$HOME/.local/share}/go

export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=00;32:*.jpeg=00;32:*.mjpg=00;32:*.mjpeg=00;32:*.gif=00;32:*.bmp=00;32:*.pbm=00;32:*.pgm=00;32:*.ppm=00;32:*.tga=00;32:*.xbm=00;32:*.xpm=00;32:*.tif=00;32:*.tiff=00;32:*.png=00;32:*.svg=00;32:*.svgz=00;32:*.mng=00;32:*.pcx=00;32:*.mov=00;32:*.mpg=00;32:*.mpeg=00;32:*.m2v=00;32:*.mkv=00;32:*.webm=00;32:*.webp=00;32:*.ogm=00;32:*.mp4=00;32:*.m4v=00;32:*.mp4v=00;32:*.vob=00;32:*.qt=00;32:*.nuv=00;32:*.wmv=00;32:*.asf=00;32:*.rm=00;32:*.rmvb=00;32:*.flc=00;32:*.avi=00;32:*.fli=00;32:*.flv=00;32:*.gl=00;32:*.dl=00;32:*.xcf=00;32:*.xwd=00;32:*.yuv=00;32:*.cgm=00;32:*.emf=00;32:*.ogv=00;32:*.ogx=00;32:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.MID=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:'

dir=''; music=''; midi='ﱘ'; vid='辶'; img=''; book=''; ex=''; txt=''; fi=''; arc=''; word=''; ppt=''
export LF_ICONS="tw=$dir :st=st :ow= :di=$dir :ln= :or= :pi=pi :so= :cd= :cd= :bd=bd :su=su :sg=sg :dt=dt :fi=$fi :ex=$ex :*.opus=$music :*.ogg=$music :*.m4a=$music :*.mp3=$music :*.ogg=$music :*.midi=$midi :*.mid=$midi :*.MID=$midi :*.mkv=$vid:*.mp4=$vid:*.webm=$vid:*.mpeg=$vid:*.avi=$vid:*.jpg=$img :*.jpeg=$img :*.png=$img :*.pdf=$book :*.djvu=$book :*.epub=$book :*.txt=$txt :*.zip=$arc :*.rar=$arc :*.7z=$arc :*.gz=$arc :*.xz=$arc :*.exe= :*.doc=$word :*.docx=$word :*.odt=$word :*.ppt=$ppt :*.pptx=$ppt :*.py= :*.c=$txt :*.cpp=$txt :*.h=$txt :*.hpp=$txt :*.go=$txt :*.sh=$txt :"
unset dir music midi vid img book ex txt fi arc word ppt

if [ $(id -u) != 0 ] && expr "$(tty)" : '/dev/tty[0-9]*' > /dev/null
then
	printf '%s' "Options: [s]hell, [t]mux, [X]org: "
	read ans
	case "$ans" in
	(t|T|j)
		tmux
	;;
	([tT]a)
		tmux attach
	;;
	(x|X|'')
		echo "Starting X.org..."
		startx >> "$STARTX_LOG" 2>&1
	;;
	(s|S)
		echo "Continuing to login shell."
	;;
	esac
fi
echo '---> Sourced ~/.profile'

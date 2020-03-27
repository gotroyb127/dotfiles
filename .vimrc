set tabstop=2
set shiftwidth=2
set softtabstop=0
set number
set relativenumber
syntax enable

let &t_SI = "\e[6 q"
let &t_SR = "\e[4 q"

let &t_EI = "\e[2 q"


" set listchars=tab:>-,trail:~,extends:>,precedes:<,space:.

autocmd CmdlineEnter * silent execute '!echo -ne "\e[6 q"'
autocmd CmdlineLeave * silent execute '!echo -ne "\e[2 q"'

set ttimeout
set ttimeoutlen=1
set ttyfast



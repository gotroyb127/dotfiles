set number
set relativenumber
set guifont=Source\ Code\ Pro\ 9
colorscheme pablo
syntax enable

let &t_SI = "\e[6 q"
let &t_SR = "\e[4 q"

let &t_EI = "\e[2 q"


autocmd CmdlineEnter * silent execute '!echo -ne "\e[6 q"'
autocmd CmdlineLeave * silent execute '!echo -ne "\e[2 q"'
autocmd VimEnter     * silent execute '!echo -ne "\e[2 q"'

" Clear highlighted search with [Ctrl]+[/]
nmap <C-_> :noh<return>

set ttimeout
set ttimeoutlen=1
set ttyfast

set clipboard=unnamed

" vimrc

set number
set relativenumber
set incsearch
set hlsearch
set guifont=Fira\ Code\ Medium\ 9

" set scrolloff=5
set mouse=a
set cursorline
set cursorlineopt=line

" colorscheme slate
" colorscheme pablo
colorscheme elflord
syntax enable

let &t_SI = "\e[6 q"
let &t_SR = "\e[4 q"

let &t_EI = "\e[2 q"

" autocmd CmdlineEnter * silent execute '!echo -ne "\e[6 q"'
" autocmd CmdlineLeave * silent execute '!echo -ne "\e[2 q"'
" autocmd CmdlineEnter * silent execute '!echo -ne "\e[2 q"'

" Show whitespace
"¬—>·~><:→—
set listchars=eol:$,tab:←—→,trail:~,extends:>,precedes:<,space:·
imap <F2> <C-o>:set list!<CR>
nmap <F2> :set list!<CR>

autocmd VimEnter     * silent execute '!echo -ne "\e[2 q"'

inoremap " ""<Left>
inoremap ' ''<Left>
inoremap ( ()<Left>
inoremap )) )
inoremap ) <Right>
inoremap } }<Left>
inoremap { {
" Only works with autoident on
inoremap {<C-j> {}<Left><Return><Return><Up><Tab>
" inoremap {<CR> {}<Left><Return><Return><Up><Tab>

inoremap <C-f> <Esc>*Nea

set shiftwidth=8
set tabstop=8
set autoindent

" Faster multi window management inside vim
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
vnoremap ( xi(<C-o>P)
vnoremap [ xi[<C-o>P]
vnoremap ' xi'<C-o>P'
vnoremap " xi"<C-o>P"

set splitbelow
set splitright


" Clear highlighted search with [Ctrl]+[/]
nmap <C-_> :noh<return>
imap <C-_> <C-o>:noh<return>

set ttimeout
set ttimeoutlen=1
set ttyfast

set clipboard=unnamed

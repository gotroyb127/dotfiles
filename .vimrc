" vimrc

set ruler
set number
set showcmd
set hlsearch
set incsearch
set laststatus=2
set relativenumber
set guifont=Fira\ Code\ Medium\ 9

" set scrolloff=5
" set autochdir
set mouse=a
set cursorline
if ! has("nvim")
	let &t_SI = "\e[6 q"
	let &t_SR = "\e[4 q"
	let &t_EI = "\e[2 q"
	set cursorlineopt=line
	command! Resource source ~/.vimrc
else
	command! Resource source ~/.config/nvim/init.vim
endif

autocmd ColorScheme * hi CursorLine ctermbg=235 cterm=NONE
colorscheme elflord
syntax enable

set statusline=\ %<%f\ (%F)\ %h%m%r%=\|%-14.(%4.l,%-6.(%c%V%)%6.L\|%)\ %P\ 

" Show whitespace
"¬—>·~><:→— ←—→
set listchars=eol:$,tab:\ —→,trail:~,extends:>,precedes:<,space:·
imap <F2> <C-o>:set list!<CR>
nmap <F2> :set list!<CR>

autocmd VimEnter * silent execute '!echo -ne "\e[2 q"'

inoremap <C-d> <Del>
inoremap " ""<Left>
inoremap ' ''<Left>
inoremap ( ()<Left>
inoremap ) <Right>
inoremap )) )
inoremap { {

" Only works with autoident on
inoremap {<C-j> {<CR><Tab>}<Left><CR><BS><Up><Right>
" inoremap {<CR> {}<Left><Return><Return><Up><Tab>

inoremap <C-f> <Esc>*Nea

filetype indent off
set autoindent
set tabstop=8
set shiftwidth=8

" Faster multi window management inside vim
nnoremap <M-q> <C-W>q
nnoremap <M-j> <C-W><C-J>
nnoremap <M-k> <C-W><C-K>
nnoremap <M-l> <C-W><C-L>
nnoremap <M-h> <C-W><C-H>
nnoremap <M-=> <C-W>+
nnoremap <M--> <C-W>-
nnoremap <M-,> <C-W><
nnoremap <M-.> <C-W>>

vnoremap ( c(<Esc>pa)<Esc>
vnoremap [ c[<Esc>pa]<Esc>
vnoremap { c{<Esc>pa}<Esc>
vnoremap ' c'<Esc>pa'<Esc>
vnoremap " c"<Esc>pa"<Esc>
vnoremap <C-c> "+y

set splitbelow
set splitright

" Clear highlighted search with [Ctrl]+[/]
nmap <C-_> :noh<return>
imap <C-_> <C-o>:noh<return>

set ttimeout
set ttimeoutlen=1
set ttyfast

set clipboard=unnamed

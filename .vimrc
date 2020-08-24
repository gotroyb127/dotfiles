" ~/.vimrc

set ruler
set number
set title
set showcmd
set mouse=a
set hlsearch
set incsearch
set autochdir

set splitbelow
set splitright

set laststatus=2
set relativenumber
set clipboard+=unnamed
set guifont=Fira\ Code\ Medium\ 9
" set scrolloff=5

" filetype plugin indent off
" filetype indent off
set loadplugins
set autoindent
set tabstop=8
set shiftwidth=8

set ttimeout
set ttimeoutlen=1
set ttyfast

syntax enable
set statusline=\ %<%f\ (%F)\ %h%m%r%=\|%-14.(%4.l,%-6.(%c%V%)%6.L\|%)\ %P\ 

set cursorline
augroup AutoCmds
	autocmd!
	autocmd ColorScheme * hi CursorLine ctermbg=235 cterm=NONE
	autocmd FileType python filetype plugin off
"	autocmd FileType man filetype plugin on
"	autocmd FileType sh,vim,python set tabstop=4 shiftwidth=4
augroup END
colorscheme pablo

if ! has("nvim")
	let &t_SI = "\e[6 q"
	let &t_SR = "\e[4 q"
	let &t_EI = "\e[2 q"
	set cursorlineopt=line
	command! Resource source ~/.vimrc
	autocmd VimEnter * silent execute '!printf "\033[2 q"'

	nnoremap <Esc>q <C-W>q
	nnoremap <Esc>j <C-W><C-J>
	nnoremap <Esc>k <C-W><C-K>
	nnoremap <Esc>l <C-W><C-L>
	nnoremap <Esc>h <C-W><C-H>
	nnoremap <Esc>= <C-W>+
	nnoremap <Esc>- <C-W>-
	nnoremap <Esc>, <C-W><
	nnoremap <Esc>. <C-W>>

	inoremap {<C-j> {}<Left><CR><C-O>O<Tab>
else
	command! Resource source ~/.config/nvim/init.vim

	nnoremap <M-q> <C-W>q
	nnoremap <M-j> <C-W><C-J>
	nnoremap <M-k> <C-W><C-K>
	nnoremap <M-l> <C-W><C-L>
	nnoremap <M-h> <C-W><C-H>
	nnoremap <M-=> <C-W>+
	nnoremap <M--> <C-W>-
	nnoremap <M-,> <C-W><
	nnoremap <M-.> <C-W>>

	inoremap {<C-j> {}<Left><CR><C-O>O
endif

" Show whitespace
"¬—>·~><:→— ←—→
set listchars=eol:$,tab:\ —→,trail:~,extends:>,precedes:<,space:·
imap <F2> <C-\><C-o>:set list!<CR>
nmap <F2> :set list!<CR>
imap <F3> <C-\><C-o>:set paste!<CR>
nmap <F3> :set paste!<CR>

" Clear highlighted search with [Ctrl]+[/]
imap <C-_> <C-o>:noh<return>
nmap <C-_> :noh<return>

inoremap <C-d> <Del>
inoremap " ""<Left>
inoremap ' ''<Left>
inoremap ( ()<Left>
inoremap ) <Right>
inoremap )) )
inoremap { {

" Only works with `autoident on` and `filetype indent off`
inoremap <C-f> <Esc>*Nea

function! Surround(lst)
	let save = @"
	silent normal gvy
	let @" = a:lst[0] . @" . a:lst[-1]
	silent normal gv""p
	let @" = save
endfunction

nnoremap <leader>e :e!<CR>
vnoremap <leader>n :norm 
vnoremap <leader>' <Esc>:call Surround(["'"])<CR>
vnoremap <leader>" <Esc>:call Surround(['"'])<CR>
vnoremap <leader>` <Esc>:call Surround(['`'])<CR>
vnoremap <leader>( <Esc>:call Surround(['(', ')'])<CR>
vnoremap <leader>{ <Esc>:call Surround(['{', '}'])<CR>
vnoremap <leader>[ <Esc>:call Surround(['[', ']'])<CR>
" vnoremap <C-c> "+y

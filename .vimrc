" vimrc

set ruler
set number
set showcmd
set hlsearch
set incsearch
set laststatus=2
set loadplugins
set relativenumber
set clipboard+=unnamed
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
else
	nnoremap <M-q> <C-W>q
	nnoremap <M-j> <C-W><C-J>
	nnoremap <M-k> <C-W><C-K>
	nnoremap <M-l> <C-W><C-L>
	nnoremap <M-h> <C-W><C-H>
	nnoremap <M-=> <C-W>+
	nnoremap <M--> <C-W>-
	nnoremap <M-,> <C-W><
	nnoremap <M-.> <C-W>>

	command! Resource source ~/.config/nvim/init.vim
endif

set ttimeout
set ttimeoutlen=1
set ttyfast

augroup AutoCmds
	autocmd!
	autocmd ColorScheme * hi CursorLine ctermbg=235 cterm=NONE
	autocmd FileType python filetype plugin off
"	autocmd FileType man filetype plugin on
"	autocmd FileType sh,vim,python set tabstop=4 shiftwidth=4
augroup END

syntax enable
colorscheme pablo
set statusline=\ %<%f\ (%F)\ %h%m%r%=\|%-14.(%4.l,%-6.(%c%V%)%6.L\|%)\ %P\ 

" Show whitespace
"¬—>·~><:→— ←—→
set listchars=eol:$,tab:\ —→,trail:~,extends:>,precedes:<,space:·
imap <F2> <C-\><C-o>:set list!<CR>
nmap <F2> :set list!<CR>

inoremap <C-d> <Del>
inoremap " ""<Left>
inoremap ' ''<Left>
inoremap ( ()<Left>
inoremap ) <Right>
inoremap )) )
inoremap { {

" Only works with autoident on
inoremap {<C-j> {<CR><Tab>}<Left><CR><BS><Up><Right>
inoremap <C-f> <Esc>*Nea

" filetype plugin indent off
set autoindent
set tabstop=8
set shiftwidth=8

" Faster multi window management inside vim
" nnoremap <M-q> <C-W>q

function! Surround(lst)
	let save = @"
	silent normal gvy
	let @" = a:lst[0] . @" . a:lst[-1]
	silent normal gv""p
	let @" = save
endfunction

vnoremap <leader>' <Esc>:call Surround(["'"])<CR>
vnoremap <leader>" <Esc>:call Surround(['"'])<CR>
vnoremap <leader>( <Esc>:call Surround(['(', ')'])<CR>
vnoremap <leader>{ <Esc>:call Surround(['{', '}'])<CR>
vnoremap <leader>[ <Esc>:call Surround(['[', ']'])<CR>
vnoremap <C-c> "+y

set splitbelow
set splitright

" Clear highlighted search with [Ctrl]+[/]
nmap <C-_> :noh<return>
imap <C-_> <C-o>:noh<return>

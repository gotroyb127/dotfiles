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

" filetype plugin indent off
" filetype indent off
set loadplugins
set autoindent
set tabstop=8
set shiftwidth=8

set ttimeout
set ttimeoutlen=1
set ttyfast

" set scrolloff=5
:set langmap=ΑA,ΒB,ΨC,ΔD,ΕE,ΦF,ΓG,ΗH,ΙI,ΞJ,ΚK,ΛL,ΜM,ΝN,ΟO,ΠP,QQ,ΡR,ΣS,ΤT,ΘU,ΩV,WW,ΧX,ΥY,ΖZ,αa,βb,ψc,δd,εe,φf,γg,ηh,ιi,ξj,κk,λl,μm,νn,οo,πp,qq,ρr,σs,τt,θu,ωv,ςw,χx,υy,ζz

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
" "colorscheme elflord
" "colorscheme ron
colorscheme pablo

map Y y$
if ! has("nvim")
	let &t_SI = "\e[6 q"
	let &t_SR = "\e[4 q"
	let &t_EI = "\e[2 q"
	set cursorlineopt=line
	command! Resource source ~/.vimrc
	autocmd VimEnter * silent exec'!printf "\033[2 q"'

	nnoremap <Esc>q <C-w>q
	nnoremap <Esc>j <C-w><C-j>
	nnoremap <Esc>k <C-w><C-k>
	nnoremap <Esc>l <C-w><C-l>
	nnoremap <Esc>h <C-w><C-h>
	nnoremap <Esc>+ <C-w>+
	nnoremap <Esc>- <C-w>-
	nnoremap <Esc>= <C-w>=
	nnoremap <Esc>, <C-w><
	nnoremap <Esc>. <C-w>>

	inoremap {<C-j> {}<Left><CR><C-o>O<Tab>
	inoremap {<CR> {}<Left><CR><C-o>O<Tab>
else
	command! Resource source ~/.config/nvim/init.vim

	nnoremap <M-q> <C-w>q
	nnoremap <M-j> <C-w><C-j>
	nnoremap <M-k> <C-w><C-k>
	nnoremap <M-l> <C-w><C-l>
	nnoremap <M-h> <C-w><C-h>
	nnoremap <M-+> <C-w>+
	nnoremap <M--> <C-w>-
	nnoremap <M-=> <C-w>=
	nnoremap <M-,> <C-w><
	nnoremap <M-.> <C-w>>

	inoremap {<C-j> {}<Left><CR><C-o>O
	inoremap {<CR> {}<Left><CR><C-o>O
endif

" Show whitespace
"¬—>·~><:→— ←—→
set listchars=eol:$,tab:\|->,trail:~,extends:>,precedes:<,space:·
imap <F2> <C-\><C-o>:set list!<CR>
nmap <F2> :call ToggleOption("list")<CR>
imap <F3> <C-\><C-o>:set paste!<CR>
nmap <F3> :call ToggleOption("paste")<CR>

func ToggleOption(option)
	exec "set " . a:option . "!"
	exec 'echo "' . a:option . ':" &' . a:option
endfunc

" Clear highlighted search with [Ctrl]+[/]
imap <C-_> <C-o>:noh<CR>
nmap <C-_> :noh<CR>

inoremap <C-d> <Del>

inoremap " ""<C-g>U<Left>
inoremap ' ''<C-g>U<Left>
inoremap ( ()<C-g>U<Left>
inoremap ) <C-g>U<Right>
inoremap )) )

" Only works with `autoident on` and `filetype indent off`
inoremap <C-f> <Esc>*Nea

nnoremap <leader>e :e!<CR>
nnoremap <leader>E :set write modifiable noreadonly<CR>

vnoremap <leader>n :norm 
vnoremap <leader>' <Esc>:call Surround(["'"])<CR>
vnoremap <leader>" <Esc>:call Surround(['"'])<CR>
vnoremap <leader>` <Esc>:call Surround(['`'])<CR>
vnoremap <leader>( <Esc>:call Surround(['(', ')'])<CR>
vnoremap <leader>{ <Esc>:call Surround(['{', '}'])<CR>
vnoremap <leader>[ <Esc>:call Surround(['[', ']'])<CR>

func Surround(lst)
	let save = @"
	silent norm gvy
	let @" = a:lst[0] . @" . a:lst[-1]
	silent norm gv""p
	let @" = save
endfunc

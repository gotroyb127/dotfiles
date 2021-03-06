" ~/.vimrc

set ruler
set number
set title
set showcmd
set laststatus=2
set statusline=\ %f\ %<(%F)\ %h%m%r%=[%{&fileencoding}]\ %4B\ \|%-15.(%-8.(%c%V%)%4.l/%L\|%)\ %P\ 

set mouse=a
set hlsearch
set incsearch
set autochdir

set splitbelow
set splitright

set relativenumber
set clipboard+=unnamed
set guifont=Fira\ Code\ Medium\ 12

" filetype plugin indent off
" filetype indent off
filetype plugin on
set loadplugins
set autoindent
set tabstop=8
set shiftwidth=8
set noexpandtab

set timeout timeoutlen=3000
set ttimeout ttimeoutlen=1

set listchars=eol:↵,tab:\|->,trail:~,extends:>,precedes:<,space:·
set langmap=ΑA,ΒB,ΨC,ΔD,ΕE,ΦF,ΓG,ΗH,ΙI,ΞJ,ΚK,ΛL,ΜM,ΝN,ΟO,ΠP,QQ,ΡR,ΣS,ΤT,ΘU,ΩV,-W,ΧX,ΥY,ΖZ,αa,βb,ψc,δd,εe,φf,γg,ηh,ιi,ξj,κk,λl,μm,νn,οo,πp,qq,ρr,σs,τt,θu,ωv,ςw,χx,υy,ζz

let g:mapleader = ' '
let g:python_recommended_style = 0
let g:rust_recommended_style = 0

set cursorline
augroup AutoCmds
	autocmd!
	if ! has("nvim")
		autocmd VimEnter * silent exec '!printf "\033[2 q"'
	endif
	autocmd ColorScheme * hi CursorLine ctermbg=234 cterm=NONE guibg='#1c1c1c'
	autocmd ColorScheme * hi ExtraWhitespace ctermbg=red guibg=red
	autocmd FileType python,sh,vim,c,cpp,go,rust,openscad,ada,lua
		\ call MapAutoComplete()
"	autocmd InsertLeave * redraw!
"	autocmd InsertLeave * match ExtraWhitespace /\s\+$/
"	autocmd InsertLeave * match ExtraWhitespace /\s\+\%#\@<!$/
augroup END

" Colorescheme setting must
" be after ColorScheme autocmd.
"colorscheme pablo
colo noclown
match ExtraWhitespace /\s\+\%#\@<!$/
syntax enable

map Y y$
if ! has("nvim")
	let &t_SI = "\e[6 q"
	let &t_SR = "\e[4 q"
	let &t_EI = "\e[2 q"
	set cursorlineopt=line
	set ttyfast

	command! Resource source ~/.vimrc

	for i in range(33, 123) + range(125, 126)
		let c = nr2char(i)
		exec "map  \e" . c . " <M-" . c . ">"
	endfor
	for c in ['\|', 'Space', '\e']
		exec 'map \e' . c . " <M-". c . ">"
	endfor
else
	command! Resource source ~/.config/nvim/init.vim
endif

imap <F2> <C-\><C-o>:set list!<CR>
nmap <F2> :call OptionToggle("list")<CR>
imap <F3> <C-\><C-o>:set paste!<CR>
nmap <F3> :call OptionToggle("paste")<CR>

" Clear highlighted search with [Ctrl]+[/]
imap <C-_> <C-o>:noh<CR>
nmap <C-_> :noh<CR>

inoremap <C-j> <C-g>u<CR>
inoremap <C-d> <Del>
inoremap <C-f> <C-g>U<Right>
inoremap <C-b> <C-g>U<Left>
inoremap <C-a> <C-g>U<Home>
inoremap <C-e> <C-g>U<End>

nnoremap <leader>f *Nzz

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

nnoremap <leader>r :Resource<CR>
nnoremap <leader>e :e!<CR>
nnoremap <leader>E :set write! modifiable! readonly!<CR>
nnoremap <leader>i :call OptionToggle("ignorecase")<CR>
nnoremap <leader>p :call OptionToggle("paste")<CR>
nnoremap <leader>l :call OptionToggle("list")<CR>
nnoremap <leader>s :call ColoToggle()<CR>
nnoremap <leader>S :call SyntaxToggle()<CR>

vnoremap <leader>n :norm
vnoremap <leader>' <Esc>:call Surround(["'"])<CR>
vnoremap <leader>" <Esc>:call Surround(['"'])<CR>
vnoremap <leader>` <Esc>:call Surround(['`'])<CR>
vnoremap <leader>( <Esc>:call Surround(['(', ')'])<CR>
vnoremap <leader>{ <Esc>:call Surround(['{', '}'])<CR>
vnoremap <leader>[ <Esc>:call Surround(['[', ']'])<CR>

nnoremap <leader>cc :call CommentLines('c')<CR>
nnoremap <leader>cu :call CommentLines('u')<CR>

nnoremap <leader>bn :bn<CR>
nnoremap <leader>bp :bp<CR>

vnoremap <leader>cc :call CommentLines('c')<CR>
vnoremap <leader>cu :call CommentLines('u')<CR>

func! OptionToggle(option)
	exec "setl " . a:option . "!"
	exec 'echo "' . a:option . ':" &' . a:option
endfunc

func! Surround(lst)
	let save = @"
	silent norm gvy
	let @" = a:lst[0] . @" . a:lst[-1]
	silent norm gv""p
	let @" = save
endfunc

func! CommentLines(action) range
	if index(["vim"], &ft) != -1
		let cmnts = '"'
	elseif index(["c", "cpp", "go", "rust", "openscad"], &ft) != -1
		let cmnts = '//'
	elseif index(["nroff"], &ft) != -1
		let cmnts = '.\"'
	elseif index(["matlab", "plaintex", "tex"], &ft) != -1
		let cmnts = '%'
	elseif index(["ada", "lua"], &ft) != -1
		let cmnts = '--'
	else
		let cmnts = '#'
	endif

	if a:action ==# 'c'
		func! ActionClosure(ln) closure
			call setline(ln, cmnts . getline(ln))
		endfunc
	elseif a:action ==# 'u'
		func! ActionClosure(ln) closure
			call setline(ln, getline(ln)[len(cmnts):])
		endfunc
	endif

	for ln in range(a:firstline, a:lastline)
		call ActionClosure(ln)
	endfor
endfunc

func! SyntaxToggle()
	if exists('g:syntax_on')
		syntax off
	else
		syntax enable
	endif
endfunc

func! ColoToggle()
	if ! exists('g:colors_name') || g:colors_name !=# 'pablo'
		colo pablo
	else
		colo noclown
	endif
endfunc

func! MapAutoComplete()
	if &ft != "ada"
		inoremap ' ''<C-g>U<Left>
	endif
	inoremap " ""<C-g>U<Left>
	inoremap ( ()<C-g>U<Left>
	inoremap [ []<C-g>U<Left>

	if has("nvim")
		inoremap {<C-j> {}<Left><CR><C-o>O
		inoremap {<CR> {}<Left><CR><C-o>O
	else
		inoremap {<C-j> {}<Left><CR><C-o>O<Tab>
		inoremap {<CR> {}<Left><CR><C-o>O<Tab>
	endif
endfunc

" noclown
"
" A mostly color free theme with a goal of not making your code look like a
" clown threw up.
"
" Propaganda:
" -- Visual clutter saps mental energy.
"
" * http://www.linusakesson.net/programming/syntaxhighlighting/
" * http://kyleisom.net/blog/2012/10/17/syntax-off/
" * https://www.robertmelton.com/2016/04/10/syntax-highlighting-off/
"
" PUBLIC DOMAIN
" To the extent possible under law, Berk D. Demir has waived all copyright and
" related or neighboring rights to noclown color scheme for Vim.
" This work is published from: United States.


highlight clear
if exists('syntax_on')
	syntax reset
endif
let g:colors_name = 'noclown'

" Terminals that don't support italics, resort to rendering them as standout.
" For comments and other things we italicize, this can become annoying very
" quickly. We are going to ignore 'italic' attribute if the terminal doesn't
" know about it.
if (has('gui_running') ||
	\ has('unix') && system('tput sitm') ==# "\e[3m")
	let g:noclown_has_italics = 1
endif

let s:palette = {
	\ 'foreground' : [253, '#dadada'],
	\ 'background' : [  0, '#000000'],
	\ 'fade'       : [245, '#8a8a8a'],
	\ 'fade-more'  : [238, '#444444'],
	\ 'highlight'  : [255, '#ffffff'],
	\ 'attention'  : [224, '#ffd7d7'],
	\ 'error'      : [203, '#ff5f5f'],
	\ }

function! s:fg(name)
	let [l:ctermfg, l:guifg] = s:palette[a:name]
	return {'ctermfg': l:ctermfg, 'guifg': l:guifg}
endfunction

function! s:bg(name)
	let [l:ctermbg, l:guibg] = s:palette[a:name]
	return {'ctermbg': l:ctermbg, 'guibg': l:guibg}
endfunction

function! s:attr(...)
	let l:alist = a:000

	if !exists('g:noclown_has_italics')
		" We're going to modify the list,
		" so make a copy (a:* are immutable)
		let l:alist = copy(a:000)
		call filter(l:alist, "v:val !=# 'italic'")
	endif

	" l:attrs: comma separated 'l:alist' as string or if empty: 'NONE'
	let l:attrs = empty(l:alist) ? 'NONE' : join(l:alist, ',')

	return {'term': l:attrs, 'cterm': l:attrs, 'gui': l:attrs}
endfunction

" Clear every attribute to NONE to avoid inheriting from default colorscheme.
let s:hi_clear = {}
for s:key in ['term', 'cterm', 'ctermfg', 'ctermbg', 'gui', 'guifg', 'guibg']
	let s:hi_clear[s:key] = 'NONE'
endfor

function! s:Defn(group, ...)
	let l:hi_dict = copy(s:hi_clear)

	" Merge attribute group definitions to main dictionary
	for l:setting in a:000
		call extend(l:hi_dict, l:setting)
	endfor

	let l:hi_expr = 'highlight ' . a:group . ' '
	" Convert { k1: v1, k2: v2, ..., kn: vn} dictionary to
	" 'k1=v1 k2=v2 ... kn=vn' string
	let l:hi_expr .= join(map(items(l:hi_dict), "join(v:val, '=')"), ' ')

	execute l:hi_expr
endfunction

function! s:None(group)
	execute 'highlight ' . a:group . ' NONE'
endfunction

function! s:Link(from, to)
	call s:None(a:from)
	execute 'highlight link ' . a:from . ' ' . a:to
endfunction

" Suggested group names from naming conventions -- ':h E669'
call s:Defn('Comment', s:fg('fade'))
call s:None('Constant') "<- String Character Number Boolean Float
call s:None('Identifier') "<- Function
call s:None('Statement') "<- Conditional Repeat Label Operator Keyword Exception
call s:None('PreProc') "<- Include Define Macro PreCondit
call s:None('Type') "<- StorageClass Structure Typedef
call s:None('Special') "<- SpecialChar Tag Delimiter SpecialComment Debug
call s:Defn('Underlined', s:attr('underline'))
call s:Defn('Ignore', s:fg('fade-more'))
call s:Defn('Error', s:fg('error'))
call s:Defn('Todo', s:attr('reverse'))

" Default group names -- ':h highlight-default'
call s:Defn('Normal', s:fg('foreground'), s:bg('background'))

call s:Defn('SpecialKey', s:fg('fade'))
call s:Defn('NonText', s:fg('fade-more'))
call s:Link('CursorLineNr', 'SpecialKey')
call s:Link('LineNr', 'NonText')
call s:None('CursorLine')

call s:Defn('VertSplit', s:fg('fade'), s:bg('fade-more'))

call s:Defn('StatusLine', s:attr('reverse'))
call s:Link('StatusLineNC', 'VertSplit')
call s:Defn('StatusLineTerm', s:fg('attention'), s:attr('reverse'))
call s:Defn('StatusLineTermNC', s:fg('attention'), s:bg('fade-more'))
call s:Defn('Visual', s:bg('fade-more'))
call s:Defn('MatchParen', s:fg('fade'), s:attr('reverse'))

call s:Defn('Title', s:fg('highlight')) " titles for output from ':set all', ':autocmd' etc.
call s:Link('Question', 'Title')
call s:Link('MoreMsg', 'Title')
call s:Defn('Search', s:fg('highlight'), s:attr('reverse'))
call s:Defn('IncSearch', s:fg('fade'), s:attr('reverse'))
call s:Link('WildMenu', 'Search')

call s:Defn('WarningMsg', s:fg('attention'))
call s:Defn('ErrorMsg', s:fg('error'))

call s:Defn('Pmenu', s:bg('fade-more'))
call s:Defn('PMenuSel', s:fg('highlight'), s:bg('fade'))
call s:Defn('PMenuSbar', s:fg('fade'), s:bg('fade'))
call s:Defn('PMenuThumb', s:fg('fade'), s:bg('highlight'))

call s:Defn('SpellBad', s:fg('attention'), s:attr('italic'))
call s:Link('SpellCap', 'Underlined')
call s:Link('SpellLocal', 'SpellCap')
call s:Link('SpellRare', 'SpellCap')

call s:Defn('Folded', s:fg('highlight'), s:bg('fade-more'))
call s:Defn('FoldColumn', s:fg('highlight'), s:bg('fade-more'))

call s:Defn('DiffAdd', s:attr('bold'), s:bg('fade-more'))
call s:Defn('DiffChange', s:bg('fade-more'))
call s:Defn('DiffDelete', s:fg('error'), s:bg('fade-more'))
call s:Defn('DiffText', s:bg('attention'), s:fg('background'))

" QuickFix
call s:Defn('qfFileName', s:fg('fade'))

""""
""" Unmodified groups from default group names list.
""" They retain their colorscheme from Vim's defaults.
"""
"ColorColumn	used for the columns set with 'colorcolumn'
"Conceal	placeholder characters substituted for concealed
"		text (see 'conceallevel')
"Cursor		the character under the cursor
"CursorIM	like Cursor, but used when in IME mode |CursorIM|
"CursorColumn	the screen column that the cursor is in when 'cursorcolumn' is
"		set
"Directory	directory names (and other special names in listings)
"EndOfBuffer	filler lines (~) after the last line in the buffer.
"		By default, this is highlighted like |hl-NonText|.
"SignColumn	column where |signs| are displayed
"ModeMsg	'showmode' message (e.g., "-- INSERT --")
"TabLine	tab pages line, not active tab page label
"TabLineFill	tab pages line, where there are no labels
"TabLineSel	tab pages line, active tab page label
"VisualNOS	Visual mode selection when vim is "Not Owning the Selection".
"		Only X11 Gui's |gui-x11| and |xterm-clipboard| supports this.

"""
" Highlight debugging helpers
"""
function! s:HighlightGroupChain()
	" Return the names in syntax identifier chain for the symbol under cursor.
	" Chain is a '->' delimited string of linked syntax identifier names from
	" leaf to root.
	let l:chain = []
	let l:leaf_id = synID(line('.'), col('.'), 1)
	let l:leaf_name = synIDattr(l:leaf_id, 'name')
	let l:root_name = synIDattr(synIDtrans(l:leaf_id), 'name')

	call add(l:chain, l:leaf_name)

	while len(l:chain) < 10 " highlight group linking is prone to loops
		redir => l:hi_output | execute 'silent! highlight ' . l:leaf_name | redir END
		let l:matches = matchlist(l:hi_output, '\vxxx links to (\w+)$')
		if len(l:matches) > 0
			let l:leaf_name = l:matches[1]
			call add(l:chain, l:leaf_name)
		else
			" highlight group doesn't link to anything. done following links.
			break
		endif
	endwhile

	if l:chain[-1] != l:root_name
		call add(l:chain, '...')
		call add(l:chain, l:root_name)
	endif

	return join(l:chain, '->')
endfunction

nmap <Plug>(noclown-echo-highlight-group-chain) :echo <SID>HighlightGroupChain()<CR>

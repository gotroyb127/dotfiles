-- visrc.lua
require('vis')
require('visUtil')

function mapCmds()
	for _, m in ipairs{vis.modes.NORMAL, vis.modes.VISUAL} do
		vis:map(m, leader('c'), Comment, '(Un)comment selected lines')
	end

	function Listchars(keys)
		set('show-spaces!')
		set('show-tabs!')
		set('show-newlines!')
		return 0
	end
	vis:map(vis.modes.NORMAL, leader('l'), Listchars, 'Toggle showing of whitespace')

	function toggleIc(keys)
		set('ic!')
		return 0 -- no keys consumed
	end
	vis:map(vis.modes.NORMAL, leader('i'), toggleIc, 'Toggle ignorecase option')

	function selTrailWhtSpc(keys)
		cmd('x/[ \t]+$')
		return 0 -- no keys consumed
	end
	vis:map(vis.modes.NORMAL, leader('w'), selTrailWhtSpc,
		':x/[ \\t]+$ (trailing whitespace)')
end

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	setTitle()
	set('nu')
	set('rnu')
	set('cursorline')

	map('! normal <M-q> ":q 0<Enter>:<Escape>kdd<Escape>"')
	map('! normal <M-h> <C-w>k')
	map('! normal <M-l> <C-w>j')
	map('! normal <M-m> <vis-motion-window-line-middle>')
	map('! normal gI 0i')

	map('! insert <C-j> <Enter>')
	map('! insert <C-b> <vis-motion-char-prev>')
	map('! insert <C-f> <vis-motion-char-next>')
	map('! insert <C-d> <vis-delete-char-next>')

	for _, m in ipairs{'visual', 'visual-line'} do
		map('! ' .. m .. ' <C-e> <vis-window-slide-up>')
		map('! ' .. m .. ' <C-y> <vis-window-slide-down>')
	end

	mapPairs('"', '()', '[]', '{}', '`')
	if win.syntax ~= 'ada' then
		mapPairs("'")
	end
	mapCmds()
end)

vis.events.subscribe(vis.events.INIT, function()
	set('ai')
	set('theme noclown')
	cmd('langmap ΑΒΨΔΕΦΓΗΙΞΚΛΜΝΟΠΡΣΤΘΩ-ΧΥΖαβψδεφγηιξκλμνοπρστθωςχυζ'
	        .. ' ABCDEFGHIJKLMNOPRSTUVWXYZabcdefghijklmnoprstuvwxyz')
end)

vis.events.subscribe(vis.events.FILE_OPEN, onFileOpen)
vis.events.subscribe(vis.events.FILE_CLOSE, onFileClose)
vis.events.subscribe(vis.events.FILE_SAVE_POST, onFileSavePost)

vis.events.subscribe(vis.events.WIN_STATUS, pUpdateStatus)
vis.events.subscribe(vis.events.QUIT, restoreTitle)

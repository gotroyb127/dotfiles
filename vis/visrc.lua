-- visrc.lua
require('vis')
require('visUtil')

function mapCmds()
	vis:map(vis.modes.NORMAL, leader('l'), Listchars, 'Toggle showing of whitespace')

	for _, m in ipairs{vis.modes.NORMAL, vis.modes.VISUAL} do
		vis:map(m, leader('c'), Comment, '(Un)comment selected lines')
	end

	function toggleIc(keys)
		set('ic!')
		return 0 -- no keys consumed
	end
	vis:map(vis.modes.NORMAL, leader('i'), toggleIc, 'Toggle ignorecase option')
end

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	set('nu')
	set('rnu')
	set('cursorline')

	map('! normal <M-q> ":q 0<Enter>"')
	map('! normal <M-k> <C-w>k')
	map('! normal <M-j> <C-w>j')
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
	set('selTrailWhitespace')
end)

vis:option_register("selTrailWhitespace", "bool", optTrailWhitespace,
	'x/[ \\t]+$/ just before saving the file')

vis.events.subscribe(vis.events.FILE_SAVE_PRE, fileSavePre)
vis.events.subscribe(vis.events.FILE_SAVE_POST, fileSavePost)

vis.events.subscribe(vis.events.WIN_STATUS, updateStatus)

-- visUtil.lua
require('vis')

local strf = string.format

local leaderc = ' '

function cmd(s)
	vis:command(s)
end

function msg(s)
	vis:message(s)
end

function info(s)
	vis:info(s)
end

function set(s)
	cmd('set ' .. s)
end

function map(s)
	cmd('map' .. s)
end

function mapw(s)
	cmd('map-window' .. s)
end

function leader(keys)
	return leaderc .. keys
end
function leaderq(keys)
	return strf('%q', leaderc .. keys)
end

function Listchars(keys)
	set('show-spaces!')
	set('show-tabs!')
	set('show-newlines!')
	return 0
end

function Comment(keys)
	if #keys < 1 then
		return -1 -- need more input
	end

	local key = keys:sub(1, 1)
	local win = vis.win
	local f = win.file
	local sel = win.selection
	local cmnts = '#'
	local fts = {
		ansi_c = '//',
		cpp = '//',
		go = '//',
		rust = '//',
		ada = '--',
		lua = '--',
	}
	for ft, s in pairs(fts) do
		if ft == win.syntax then
			cmnts = s
		end
	end

	local pa = sel.range.start
	local pz = sel.range.finish
	local selline = sel.line

	if key == 'c' then
		-- Comment
		function Do(pos)
			f:insert(pos, cmnts)
			pz = pz + #cmnts
		end
	elseif key == 'u' then
		-- Uncomment
		function Do(pos)
			if f:content(pos, #cmnts) == cmnts then
				f:delete(pos, #cmnts)
			end
			pz = pz - #cmnts
		end
	else
		return 0
	end

	while pa > 0 and f:content(pa - 1, 1) ~= '\n' do
		pa = pa - 1
	end
	local count = vis.count or 0
	Do(pa)
	while pa < pz or (pa < f.size and count > 1) do
		if f:content(pa, 1) == '\n' then
			Do(pa + 1)
			count = count - 1
		end
		pa = pa + 1
	end
	vis.count = nil

	sel:to(selline, 1)
--	win:draw()
	return 1 -- 1 key consumed
end

function mapPairs(...)
	function v(s)
		return strf('<vis-insert-verbatim>u%04x', s:byte())
	end

	for _, s in ipairs{...} do
		local o = s:sub(1, 1)
		local c = s:sub(-1)
		map(strf('! insert %q %s%s<vis-motion-char-prev>',
			o, v(o), v(c)))
		map(strf('! visual %s %q', leaderq(o),
			strf(':x/%s.|\\n)+/ c/%s&%s/<Enter>v',
			v'(', v(o), v(c))))
	end
end

function fileSavePost(file)
	info(strf('"%s" %dL, %dC written', file.name, #file.lines, file.size))
end

local lastMode;
local home = os.getenv('HOME')
function updateStatus(win)
	if lastMode ~= vis.mode then
		lastMode = vis.mode
		local n
		if lastMode == vis.modes.NORMAL then
			n = 2
		elseif lastMode == vis.modes.OPERATOR_PENDING then
			n = 4
		elseif lastMode == vis.modes.INSERT then
			n = 6
		elseif lastMode == vis.modes.REPLACE then
			n = 4
		elseif lastMode == vis.modes.VISUAL then
			n = 2
		elseif lastMode == vis.modes.VISUAL_LINE then
			n = 2
		end
		io.stderr:write(strf('\x1b[%d q', n))
	end

	local f = win.file
	local sel = win.selection
	local sels = win.selections

	local sleft, sright
	local fname
	local dirname
	local mod
	local selinfo
	local keys
	local cc
	local cp
	local lnc
	local lnt
	local col

	if f.path then
		fname = f.path:gsub('^.*/', '', 1)
		dirname = f.path:gsub('/[^/]*$', '', 1)
		if dirname:sub(1, #home) == home then
			dirname = '~' .. dirname:sub(#home + 1)
		end
	else
		fname = '[No Name]'
		dirname = '[No Name]'
	end
	mod = f.modified and ' [+]' or ''

	if not sel.range then
		return true
	end
	cc = f:content(sel.range)
	cp = cc ~= '' and utf8.codepoint(cc) or 0
	col = sel.col
	lnc = sel.line
	lnt = #f.lines

	if #sels > 1 then
		selinfo = strf('%d/%d ', sel.number, #sels)
	else
		selinfo = ''
	end

	keys = vis.input_queue
	if keys ~= '' then
		keys = keys .. ' '
	end

	sleft = strf(' %s%s (%s)', fname, mod, dirname)
	sright = strf('%s%sU+%04X |%d  %2d/%d| ', selinfo, keys, cp,
		col, lnc, lnt)

	win:status(sleft, sright)
end

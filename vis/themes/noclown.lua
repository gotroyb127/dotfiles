-- adapted from noclown.vim
local lexers = vis.lexers

-- palette
local fg = '#dadada'
local bg = '#000000'
local fade = '#8a8a8a'
local fade_less = '#aaaaaa'
local fade_more = '#444444'
local highlight = '#ffffff'
local info = '#aaffff'
local err = '#ff5f5f'
local cursln = '#1c1c1c'

function style(t)
	function isy(s, st)
		return (s == 'y' and '' or 'not') .. st
	end
	local l = {
		str = '',
		add = function(l, str)
			l.str = l.str .. str .. ','
		end,
	}
	if t.fg then
		l:add('fore:' .. t.fg)
	end
	if t.bg then
		l:add('back:' .. t.bg)
	end
	if t.B then
		l:add(isy(t.B, 'bold'))
	end
	if t.I then
		l:add(isy(t.I, 'italics'))
	end
	if t.U then
		l:add(isy(t.U, 'underlined'))
	end
	if t.blink then
		l:add(isy(t.blink, 'blink'))
	end
	return l.str
end

lexers.STYLE_NOTHING = style{fg = fg, bg = bg}
lexers.STYLE_DEFINITION = ''
lexers.STYLE_TAG = ''

-- grep '@field STYLE_' lexer.lua
lexers.STYLE_CLASS = ''
lexers.STYLE_COMMENT = style{fg = fade}
lexers.STYLE_CONSTANT = ''
lexers.STYLE_ERROR = style{fg = err}
lexers.STYLE_FUNCTION = ''
lexers.STYLE_KEYWORD = ''
lexers.STYLE_LABEL = ''
lexers.STYLE_NUMBER = ''
lexers.STYLE_OPERATOR = ''
lexers.STYLE_REGEX = ''
lexers.STYLE_STRING = ''
lexers.STYLE_PREPROCESSOR = ''
lexers.STYLE_TYPE = ''
lexers.STYLE_VARIABLE = ''
lexers.STYLE_WHITESPACE = style{fg = fade}
lexers.STYLE_EMBEDDED = ''
lexers.STYLE_IDENTIFIER = ''
lexers.STYLE_DEFAULT = style{fg = fg, bg = bg, blink = 'n'}
lexers.STYLE_LINENUMBER = style{fg = fade_more}
lexers.STYLE_BRACELIGHT = style{fg = fg, bg = fade_more}
lexers.STYLE_BRACEBAD = style{fg = err}
lexers.STYLE_CONTROLCHAR = ''
lexers.STYLE_INDENTGUIDE = ''
lexers.STYLE_CALLTIP = ''
lexers.STYLE_FOLDDISPLAYTEXT = ''

lexers.STYLE_LINENUMBER_CURSOR = style{fg = fade}
lexers.STYLE_CURSOR = style{fg = bg, bg = fade}
lexers.STYLE_CURSOR_PRIMARY = style{fg = bg, bg = fg}
lexers.STYLE_CURSOR_MATCHING = style{fg = bg, bg = fade_more}
lexers.STYLE_CURSOR_LINE = style{bg = cursln}
lexers.STYLE_COLOR_COLUMN = lexers.STYLE_CURSOR_LINE
lexers.STYLE_SELECTION = style{bg = fade_more}
lexers.STYLE_STATUS = style{fg = fade, bg = fade_more}
lexers.STYLE_STATUS_FOCUSED = style{fg = bg, bg = fg}
lexers.STYLE_SEPARATOR = lexers.STYLE_DEFAULT
lexers.STYLE_INFO = style{fg = info}
lexers.STYLE_EOF = style{fg = fade_more}

local M = {}

---@return Palette
function M.mocha()
	--- @type AnsiColors
	local ansi = {
		'#45475a',
		'#f38ba8',
		'#a6e3a1',
		'#f9e2af',
		'#89b4fa',
		'#f5c2e7',
		'#94e2d5',
		'#bac2de',
	}

	--- @type BrightColors
	local brights = {
		'#585b70',
		'#f38ba8',
		'#a6e3a1',
		'#f9e2af',
		'#89b4fa',
		'#f5c2e7',
		'#94e2d5',
		'#a6adc8',
	}


	-- TODO: add correct themes
	--- @type Palette
	return {
		foreground = '#cdd6f4',
		background = '#1e1e2e',
		background_secondary = '#3c3836',
		cursor_bg = '#f5e0dc',
		cursor_fg = '#11111b',
		compose_cursor = '#f2cdcd',
		selection_bg = '#585b70',
		selection_fg = '#cdd6f4',
		active_tab = brights[4],
		hover_tab = brights[5],

		ansi = ansi,
		brights = brights,
	}
end

return M

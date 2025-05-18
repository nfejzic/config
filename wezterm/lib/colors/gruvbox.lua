local M = {}

--- @return Palette
function M.dark_hard()
	--- @type Palette
	return {
		foreground = '#ebdbb2',
		background = '#1d2021',
		background_secondary = '#3c3836',
		cursor_bg = '#ebdbb2',
		cursor_fg = '#1d2021',
		selection_fg = 'ebdbb2',
		selection_bg = '#665c54',
		compose_cursor = '#fe8019',
		active_tab = '#fabd2f',
		hover_tab = '#83a598',
		ansi = {
			"#1d2021",
			"#cc241d",
			"#98971a",
			"#d79921",
			"#458588",
			"#b16286",
			"#689d6a",
			"#a89984",
		},
		brights = {
			"#928374",
			"#fb4934",
			"#b8bb26",
			"#fabd2f",
			"#83a598",
			"#d3869b",
			"#8ec07c",
			"#ebdbb2",
		},
	}
end

return M

local M = {}

--- @param wezterm table
function M.init(wezterm)
	local theme = "Gruvbox dark, hard (base16)"
	-- theme = "Catppuccin Macchiato"
	-- theme = "Kanagawa (Gogh)"
	-- theme = "rose-pine"

	local colors = wezterm.color.get_builtin_schemes()[theme]
	colors.tab_bg = "#3c3836"

	return { colors = colors, theme = theme }
end

return M

local M = {}

---@return ColorTheme
function M.mocha()
	-- TODO: add correct themes
	return {
		background = '#1e1e2e',
		foreground = '#cdd6f4',

		compose_cursor = '#f2cdcd',
		cursor_bg = '#f5e0dc',
		cursor_border = '#f5e0dc',
		cursor_fg = '#11111b',
		scrollbar_thumb = '#585b70',
		selection_bg = '#585b70',
		selection_fg = '#cdd6f4',
		split = '#6c7086',
		visual_bell = '#313244',

		-- Background for the tab bar
		background_secondary = '#3c3836',

		ansi = {
			'#45475a',
			'#f38ba8',
			'#a6e3a1',
			'#f9e2af',
			'#89b4fa',
			'#f5c2e7',
			'#94e2d5',
			'#bac2de',
		},
		brights = {
			'#585b70',
			'#f38ba8',
			'#a6e3a1',
			'#f9e2af',
			'#89b4fa',
			'#f5c2e7',
			'#94e2d5',
			'#a6adc8',
		},

		-- Colors for copy_mode and quick_select
		-- available since: 20220807-113146-c2fee766
		-- In copy_mode, the color of the active text is:
		-- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
		-- 2. selection_* otherwise
		copy_mode_active_highlight_bg = { AnsiColor = 'White' },
		-- use `AnsiColor` to specify one of the ansi color palette values
		-- (index 0-15) using one of the names "Black", "Maroon", "Green",
		--  "Olive", "Navy", "Purple", "Teal", "Silver", "Grey", "Red", "Lime",
		-- "Yellow", "Blue", "Fuchsia", "Aqua" or "White".
		copy_mode_active_highlight_fg = { AnsiColor = 'Black' },
		copy_mode_inactive_highlight_bg = { Color = 'Silver' },
		copy_mode_inactive_highlight_fg = { AnsiColor = 'Black' },

		quick_select_label_bg = { Color = 'Black' },
		quick_select_label_fg = { Color = 'Yellow' },
		quick_select_match_bg = { AnsiColor = 'White' },
		quick_select_match_fg = { Color = 'Black' },

		is_not_standard = function(key)
			return key == "background_secondary" or key == "is_not_standard"
		end
	}
end

return M

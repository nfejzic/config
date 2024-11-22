local M = {}

---@return ColorTheme
function M.colors()
	return {
		foreground = '#ebdbb2',
		background = '#1d2021',

		-- Background for the tab bar
		background_secondary = '#3c3836',

		-- Overrides the cell background color when the current cell is occupied by the
		-- cursor and the cursor style is set to Block
		cursor_bg = '#ebdbb2',

		-- Overrides the text color when the current cell is occupied by the cursor
		cursor_fg = '#1d2021',
		-- Specifies the border color of the cursor when the cursor style is set to Block,
		-- or the color of the vertical or horizontal bar when the cursor style is set to
		-- Bar or Underline.
		cursor_border = '#ebdbb2',

		-- the foreground color of selected text
		selection_fg = 'ebdbb2',
		-- the background color of selected text
		selection_bg = '#665c54',

		-- The color of the scrollbar "thumb"; the portion that represents the current viewport
		scrollbar_thumb = '#222222',

		-- The color of the split lines between panes
		split = '#444444',

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

		-- Since: 20220319-142410-0fcdea07
		-- When the IME, a dead key or a leader key are being processed and are effectively
		-- holding input pending the result of input composition, change the cursor
		-- to this color to give a visual cue about the compose state.
		compose_cursor = 'orange',

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

		tab_bar = function(term_bg, colors)
			return {
				-- The color of the inactive tab bar edge/divider
				inactive_tab_edge = term_bg,
				-- background = colors.background,
				background = term_bg,

				active_tab = {
					-- The color of the background area for the tab
					bg_color = term_bg,
					-- The color of the text for the tab
					fg_color = colors.brights[4],

					-- Specify whether you want "Half", "Normal" or "Bold" intensity for the
					-- label shown for this tab.
					-- The default is "Normal"
					intensity = "Normal",

					-- Specify whether you want "None", "Single" or "Double" underline for
					-- label shown for this tab.
					-- The default is "None"
					underline = "None",

					-- Specify whether you want the text to be italic (true) or not (false)
					-- for this tab.  The default is false.
					italic = false,

					-- Specify whether you want the text to be rendered with strikethrough (true)
					-- or not for this tab.  The default is false.
					strikethrough = false,
				},
				inactive_tab = {
					bg_color = term_bg,
					fg_color = colors.foreground,
					intensity = "Half",
				},
				inactive_tab_hover = {
					bg_color = term_bg,
					fg_color = colors.brights[5],
					italic = false,
				},
				new_tab = {
					bg_color = term_bg,
					fg_color = term_bg,
				},
				new_tab_hover = {
					bg_color = colors.brights[4],
					fg_color = colors.foreground,
				},
			}
		end,

		is_not_standard = function(key)
			return key == "background_secondary" or key == "is_not_standard"
		end,
	}
end

return M

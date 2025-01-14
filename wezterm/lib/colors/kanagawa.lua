local M = {}

local palette = {
	fujiWhite = '#DCD7BA',
	oldWhite = '#C8C093',

	sumiInk0 = '#16161D',
	sumiInk1 = '#1F1F28',
	sumiInk2 = '#2A2A37',
	sumiInk3 = '#363646',
	sumiInk4 = '#54546D',

	waveBlue1 = '#223249',
	waveBlue2 = '#2D4F67',

	waveAqua1 = '#6A9589',
	waveAqua2 = '#7AA89F',

	samuraiRed = '#E82424',
	autumnRed = '#C34043',
	autumnYellow = '#DCA561',
	roninYellow = '#FF9E3B',
	peachRed = '#FF5D62',
	crystalBlue = '#7E9CD8',
	dragonBlue = '#658594',
	springGreen = '#98BB6C',
	springBlue = '#7FB4CA',
	autumnGreen = '#76946A',
	winterGreen = '#2B3328',
	winterYellow = '#49443C',
	winterRed = '#43242B',
	winterBlue = '#252535',
	oniViolet = '#957FB8',
	sakuraPink = '#D27E99',
	lightBlue = '#A3D4D5',

	oldWhite3 = '#002B36',
	oldWhite3_hard = '#00141D',
	surimiOrange = '#FFA066',
	boatYellow2 = '#C0A36E',
	carpYellow = '#E6C384',

	katanaGrey = '#717C7C',

}

---@return ColorTheme
function M.wave()
	return {
		foreground = '#dcd7ba',
		background = '#1f1f28',

		-- Background for the tab bar
		background_secondary = '#2A2A37',

		-- Overrides the cell background color when the current cell is occupied by the
		-- cursor and the cursor style is set to Block
		cursor_bg = '#dcd7ba',

		-- Overrides the text color when the current cell is occupied by the cursor
		cursor_fg = '#1f1f28',
		-- Specifies the border color of the cursor when the cursor style is set to Block,
		-- or the color of the vertical or horizontal bar when the cursor style is set to
		-- Bar or Underline.
		cursor_border = '#dcd7ba',

		-- the foreground color of selected text
		selection_fg = '#c8c093',
		-- the background color of selected text
		selection_bg = '#2d4f67',

		-- The color of the scrollbar "thumb"; the portion that represents the current viewport
		scrollbar_thumb = '#2d4f67',

		-- The color of the split lines between panes
		split = '#2d4f67',

		ansi = {
			"#090618",
			"#c34043",
			"#76946a",
			"#c0a36e",
			"#7e9cd8",
			"#957fb8",
			"#6a9589",
			"#c8c093",
		},
		brights = {
			"#727169",
			"#e82424",
			"#98bb6c",
			"#e6c384",
			"#7fb4ca",
			"#938aa9",
			"#7aa89f",
			"#dcd7ba",
		},

		-- Since: 20220319-142410-0fcdea07
		-- When the IME, a dead key or a leader key are being processed and are effectively
		-- holding input pending the result of input composition, change the cursor
		-- to this color to give a visual cue about the compose state.
		compose_cursor = '#c0a36e',

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
		copy_mode_inactive_highlight_bg = { AnsiColor = 'Silver' },
		copy_mode_inactive_highlight_fg = { AnsiColor = 'Black' },

		quick_select_label_bg = { AnsiColor = 'Maroon' },
		quick_select_label_fg = { AnsiColor = 'White' },
		quick_select_match_bg = { AnsiColor = 'Green' },
		quick_select_match_fg = { AnsiColor = 'White' },

		---@param term_bg string
		---@param colors ColorTheme
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
					fg_color = palette.autumnYellow,

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
					intensity = "Normal",
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

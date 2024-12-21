local M = {}

---@class RosePinePalette
---@field base string
---@field overlay string
---@field muted string
---@field text string
---@field love string
---@field gold string
---@field rose string
---@field pine string
---@field foam string
---@field iris string
---@field highlight_high string
---@field highlight_low string

---@alias RosePineChoice 'main'|'moon'|'dawn'

---@type table<RosePineChoice, RosePinePalette>
local palette = {
	main = {
		base = '#191724',
		overlay = '#26233a',
		muted = '#6e6a86',
		text = '#e0def4',
		love = '#eb6f92',
		gold = '#f6c177',
		rose = '#ebbcba',
		pine = '#31748f',
		foam = '#9ccfd8',
		iris = '#c4a7e7',
		highlight_high = '#524f67',
		highlight_low = '#21202e',
	},
	moon = {
		base = '#232136',
		overlay = '#393552',
		muted = '#6e6a86',
		text = '#e0def4',
		love = '#eb6f92',
		gold = '#f6c177',
		rose = '#ea9a97',
		pine = '#3e8fb0',
		foam = '#9ccfd8',
		iris = '#c4a7e7',
		highlight_high = '#56526e',
		highlight_low = '#2a283e',
	},
	dawn = {
		base = '#faf4ed',
		overlay = '#f2e9e1',
		muted = '#9893a5',
		text = '#575279',
		love = '#b4637a',
		gold = '#ea9d34',
		rose = '#d7827e',
		pine = '#286983',
		foam = '#56949f',
		iris = '#907aa9',
		highlight_high = '#cecacd',
		highlight_low = '#f4ede8',
	}
}

---@param flavor RosePinePalette
local function colorize(flavor)
	return {
		foreground = flavor.text,
		background = flavor.base,

		-- Background for the tab bar
		background_secondary = flavor.overlay,

		-- Overrides the cell background color when the current cell is occupied by the
		-- cursor and the cursor style is set to Block
		cursor_bg = flavor.text,

		-- Specifies the border color of the cursor when the cursor style is set to Block,
		-- or the color of the vertical or horizontal bar when the cursor style is set to
		-- Bar or Underline.
		cursor_border = flavor.text,

		-- Overrides the text color when the current cell is occupied by the cursor
		cursor_fg = flavor.base,

		-- the foreground color of selected text
		selection_fg = flavor.text,
		-- the background color of selected text
		selection_bg = flavor.highlight_low,

		-- The color of the scrollbar "thumb"; the portion that represents the current viewport
		scrollbar_thumb = flavor.overlay,

		-- The color of the split lines between panes
		split = flavor.highlight_high,

		ansi = {
			flavor.overlay,
			flavor.love,
			flavor.pine,
			flavor.gold,
			flavor.foam,
			flavor.iris,
			flavor.rose,
			flavor.text,
		},
		brights = {
			flavor.muted,
			flavor.love,
			flavor.pine,
			flavor.gold,
			flavor.foam,
			flavor.iris,
			flavor.rose,
			flavor.text,
		},

		-- Since: 20220319-142410-0fcdea07
		-- When the IME, a dead key or a leader key are being processed and are effectively
		-- holding input pending the result of input composition, change the cursor
		-- to this color to give a visual cue about the compose state.
		compose_cursor = flavor.gold,

		-- Colors for copy_mode and quick_select
		-- available since: 20220807-113146-c2fee766
		-- In copy_mode, the color of the active text is:
		-- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
		-- 2. selection_* otherwise
		copy_mode_active_highlight_bg = { AnsiColor = 'White' },
		-- use `AnsiColor` to specify one of the ansi color flavor values
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

---@return ColorTheme
function M.main()
	local col = palette.main
	return colorize(col)
end

function M.moon()
	return colorize(palette.moon)
end

function M.dawn()
	return colorize(palette.dawn)
end

return M

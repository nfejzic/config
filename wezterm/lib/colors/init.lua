---@class ColorSpecEnum
---@field Color string|nil
---@field AnsiColor string|nil

---@class ColorTheme
---@field foreground string
---@field background string
---@field background_secondary string
---@field cursor_bg string
---@field cursor_fg string
---@field cursor_border string
---@field selection_fg string
---@field selection_bg string
---@field scrollbar_thumb string
---@field split string
---@field ansi table<number, string>
---@field brights table<number, string>
---@field indexed table<number, string>|nil
---@field compose_cursor string
---@field copy_mode_active_highlight_bg string|ColorSpecEnum
---@field copy_mode_active_highlight_fg string|ColorSpecEnum
---@field copy_mode_inactive_highlight_bg string|ColorSpecEnum
---@field copy_mode_inactive_highlight_fg string|ColorSpecEnum
---@field quick_select_label_bg string|ColorSpecEnum
---@field quick_select_label_fg string|ColorSpecEnum
---@field quick_select_match_bg string|ColorSpecEnum
---@field quick_select_match_fg string|ColorSpecEnum
---@field is_not_standard fun(key: string): boolean
---@field tab_bar fun(term_bg: string, colors: ColorTheme): TabBarTheme

---@alias ColorIntensity 'Half'|'Normal'|'Bold'
---@alias UnderlineSpec 'None'|'Single'|'Double'

---@class TabColorSpec
---@field bg_color ColorSpecEnum
---@field fg_color ColorSpecEnum
---@field intensity ColorIntensity = 'Normal'
---@field underline UnderlineSpec = 'None'
---@field italic boolean = false
---@field strikethrough boolean = false

---@class TabBarTheme
---@field background ColorSpecEnum
---@field active_tab TabColorSpec
---@field inactive_tab TabColorSpec
---@field inactive_tab_hover TabColorSpec
---@field new_tab TabColorSpec
---@field new_tab_hover TabColorSpec

--- @alias AnsiColors [string, string, string, string, string, string, string, string]
--- @alias BrightColors [string, string, string, string, string, string, string, string]

--- @class Palette
--- @field foreground string
--- @field background string
--- @field background_secondary string
--- @field cursor_bg string
--- @field cursor_fg string
--- @field compose_cursor string
--- @field selection_bg string
--- @field selection_fg string
--- @field active_tab string
--- @field hover_tab string
--- @field ansi AnsiColors
--- @field brights BrightColors


local M = {}

--- @param palette Palette
local function colorize(palette)
	return {
		foreground = palette.foreground,
		background = palette.background,

		-- Background for the tab bar
		background_secondary = palette.background_secondary,

		-- Overrides the cell background color when the current cell is occupied by the
		-- cursor and the cursor style is set to Block
		cursor_bg = palette.cursor_bg,

		-- Overrides the text color when the current cell is occupied by the cursor
		cursor_fg = palette.cursor_fg,
		-- Specifies the border color of the cursor when the cursor style is set to Block,
		-- or the color of the vertical or horizontal bar when the cursor style is set to
		-- Bar or Underline.
		cursor_border = palette.cursor_bg,

		-- the foreground color of selected text
		selection_fg = palette.selection_fg,
		-- the background color of selected text
		selection_bg = palette.selection_bg,

		-- The color of the scrollbar "thumb"; the portion that represents the current viewport
		scrollbar_thumb = palette.selection_bg,

		-- The color of the split lines between panes
		split = palette.selection_bg,

		ansi = palette.ansi,
		brights = palette.brights,

		-- Since: 20220319-142410-0fcdea07
		-- When the IME, a dead key or a leader key are being processed and are effectively
		-- holding input pending the result of input composition, change the cursor
		-- to this color to give a visual cue about the compose state.
		compose_cursor = palette.compose_cursor,

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
					fg_color = palette.active_tab,

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
					fg_color = palette.hover_tab,
					italic = false,
				},
				new_tab = {
					bg_color = term_bg,
					fg_color = term_bg,
				},
				new_tab_hover = {
					bg_color = palette.hover_tab,
					fg_color = colors.foreground,
				},
			}
		end,

		is_not_standard = function(key)
			return key == "background_secondary" or key == "is_not_standard"
		end,
	}
end

--- @enum (key) PaletteFn
local palette_fns = {
	["gruvbox-dark-hard"] = require('lib.colors.gruvbox').dark_hard,
	["catppuccin"] = require('lib.colors.catppuccin').mocha,
	["kanagawa-wave"] = require('lib.colors.kanagawa').wave,
	["kanagawa-dragon"] = require('lib.colors.kanagawa').dragon,
	["kanagawa-lotus"] = require('lib.colors.kanagawa').lotus,
	["rose-pine-main"] = require('lib.colors.rose_pine').main,
	["rose-pine-moon"] = require('lib.colors.rose_pine').moon,
	["rose-pine-dawn"] = require('lib.colors.rose_pine').dawn,
}

---@param theme PaletteFn
---@return { colors: ColorTheme, theme: string|ColorTheme }
function M.init(theme)
	local get_palette = palette_fns[theme]
	local palette = get_palette()
	local colors = colorize(palette)

	return { colors = colors, theme = colors }
end

return M

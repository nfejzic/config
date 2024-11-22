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

local M = {}

---@param _wezterm table
---@return { colors: ColorTheme, theme: string|ColorTheme }
---@diagnostic disable-next-line: unused-local
function M.init(_wezterm)
	local colors = require('lib.colors.gruvbox').colors()

	return { colors = colors, theme = colors }
end

return M

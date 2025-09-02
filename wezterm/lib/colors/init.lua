local M = {}

--- @alias AnsiColors [string, string, string, string, string, string, string, string]
--- @alias BrightColors [string, string, string, string, string, string, string, string]

--- @alias ThemeName
--- | "Gruvbox dark, hard (base16)"
--- | "Gruvbox light, medium (base16)"
--- | "catppuccin-frappe"
--- | "catppuccin-latte"
--- | "catppuccin-macchiato"
--- | "catppuccin-mocha"
--- | "catppuccin-mocha"
--- | "Kanagawa (Gogh)"
--- | "Kanagawa Dragon (Gogh)"
--- | "rose-pine"
--- | "rose-pine-dawn"
--- | "rose-pine-moon"

--- @class ThemeConfig
--- @field dark ThemeName
--- @field light ThemeName

--- @alias OsAppearance 'Dark'|'DarkHighContrast'|'Light'|'LightHighContrast'

--- @class Theme
--- @field ansi AnsiColors
--- @field brights BrightColors
--- @field indexed table<number, string>|nil
--- @field background string
--- @field foreground string
--- @field cursor_bg string
--- @field cursor_border string
--- @field cursor_fg string
--- @field selection_bg string
--- @field selection_fg string
--- @field tab_bar_bg string

--- @param theme ThemeName
--- @param colors Theme
--- @return string Color for the tab bar
local function get_tab_bar_cols(theme, colors)
	if theme:match("Gruvbox") then
		return colors.indexed[18]
	elseif theme == "Kanagawa (Gogh)" then
		return "#2A2A37"
	elseif theme == "Kanagawa Dragon (Gogh)" then
		return "#1D1C19"
	elseif theme == "catppuccin-frappe" then
		return "#414559"
	elseif theme == "catppuccin-macchiato" then
		return "#363a4f"
	elseif theme == "catppuccin-mocha" then
		return "#313244"
	elseif theme == "catppuccin-latte" then
		return "#ccd0da"
	elseif theme == "rose-pine" then
		return "#26233a"
	elseif theme == "rose-pine-moon" then
		return "#393552"
	elseif theme == "rose-pine-dawn" then
		return "#f2e9e1"
	else
		return "#000000"
	end
end

local function is_light_mode(os_appearance)
	return os_appearance == 'Light' or os_appearance == 'LightHighContrast'
end

---@param theme ThemeConfig
---@param os_appearance OsAppearance
---@return { colors: Theme, theme: string }
function M.init(theme, os_appearance, wezterm)
	local schemes = wezterm.get_builtin_color_schemes()

	local theme_name = is_light_mode(os_appearance) and theme.light or theme.dark
	local colors = schemes[theme_name]

	colors.tab_bar_bg = get_tab_bar_cols(theme_name, colors)

	return { colors = colors, theme = theme_name }
end

return M

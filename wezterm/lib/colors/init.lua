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

local function is_dark_mode(os_appearance)
	return os_appearance == 'Light' or os_appearance == 'LightHighContrast'
end

---@param theme ThemeConfig
---@param os_appearance OsAppearance
---@return { colors: Theme, theme: string }
function M.init(theme, os_appearance, wezterm)
	local schemes = wezterm.get_builtin_color_schemes()

	local theme_name = is_dark_mode(os_appearance) and theme.dark or theme.light
	local colors = schemes[theme_name]

	return { colors = colors, theme = theme_name }
end

return M

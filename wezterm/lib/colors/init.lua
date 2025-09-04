--- @module "wezterm"

local M = {}

--- @alias ThemeName
--- | "kanagawa-wave"
--- | "kanagawa-lotus"
-- NOTE: following themes are nice, but not yet configured
-- --- | "Gruvbox dark, hard (base16)"
-- --- | "Gruvbox light, medium (base16)"
-- --- | "catppuccin-frappe"
-- --- | "catppuccin-latte"
-- --- | "catppuccin-macchiato"
-- --- | "catppuccin-mocha"
-- --- | "catppuccin-mocha"
-- --- | "rose-pine"
-- --- | "rose-pine-dawn"
-- --- | "rose-pine-moon"

--- @class ThemeConfig
--- @field dark ThemeName
--- @field light ThemeName

--- @alias OsAppearance 'Dark'|'DarkHighContrast'|'Light'|'LightHighContrast'

local function is_light_mode(os_appearance)
	return os_appearance == 'Light' or os_appearance == 'LightHighContrast'
end

---@param theme ThemeConfig
---@param os_appearance OsAppearance
---@return string
function M.get_color_scheme(theme, os_appearance)
	local theme_name = is_light_mode(os_appearance) and theme.light or theme.dark

	return theme_name
end

return M

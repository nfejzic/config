local tab_fns = require("tab_config")
local keys = require("key_config")

local wezterm = require("wezterm")

local theme = "Gruvbox dark, hard (base16)"
-- theme = "Catppuccin Macchiato"
theme = "Kanagawa (Gogh)"

local colors = wezterm.color.get_builtin_schemes()[theme]

require("custom_events").register_events(wezterm, tab_fns, colors, theme)

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.front_end = "WebGpu"

if wezterm.hostname() == "zenith" then
	-- Mac Mini, macos uses default DPI 72 for non HiDPI screens.
	-- However, my LG QHD Monitor has DPI of 108. Set accordingly, otherwise
	-- fonts get too small
	config.dpi = 108
end

-- font test
local _ = "gq 1Il O0 0123456789 --> -> => == === != !== <= >="

-- long time favorite font:
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 12.5

-- ->

config.bold_brightens_ansi_colors = "BrightAndBold"

config.color_scheme = theme

config.window_padding = {
	left = "0cell",
	right = "0cell",
	top = "0cell",
	bottom = "0.0cell",
}

-- window_decorations = "RESIZE"
config.warn_about_missing_glyphs = true
config.hide_mouse_cursor_when_typing = false
config.enable_scroll_bar = false

config.window_decorations = "RESIZE|MACOS_FORCE_DISABLE_SHADOW"
config.window_background_opacity = 0.97
config.window_background_opacity = 1
config.macos_window_background_blur = 30
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.show_new_tab_button_in_tab_bar = false

local is_transparent = config.window_background_opacity ~= 1.0

config.colors = {
	tab_bar = tab_fns.tab_bar_colors(colors, is_transparent),
}

config.leader = keys.get_keybindings(wezterm).leader
config.keys = keys.get_keybindings(wezterm).keys

-- default is 60, so increase to prevent stuttering. Max is 255 (u8 in Rust)
config.max_fps = 255

-- and finally, return the configuration to wezterm
return config

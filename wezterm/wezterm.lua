local tab_fns = require("tab_config")
local keys = require("key_config")

local wezterm = require("wezterm")
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
	local _, _, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

local theme = "Gruvbox dark, hard (base16)"
-- theme = "Catppuccin Mocha"
theme = "Catppuccin Macchiato"
-- theme = "rose-pine"
-- theme = "Kanagawa (Gogh)"
-- theme = "Mariana"
local colors = wezterm.color.get_builtin_schemes()[theme]

wezterm.on("format-tab-title", tab_fns.format_tab_title(colors))

wezterm.on("update-status", function(window, _pane)
	local workspace = window:active_workspace()

	local foreground_color = colors.ansi[1]
	if theme == "rose-pine" then
		foreground_color = colors.brights[8]
	end

	window:set_left_status(wezterm.format({
		{ Attribute = { Intensity = "Normal" } },
		{ Background = { Color = colors.brights[5] } },
		{ Foreground = { Color = foreground_color } },
		{ Text = " [" .. workspace .. "] " },
	}))
end)

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 26

-- config.font = wezterm.font("Consolas")
-- config.font_size = 28
-- config.line_height = 1.05

-- ->
-- config.font = wezterm.font("Monolisa")
-- config.font_size = 24
-- config.line_height = 1.19

-- config.font = wezterm.font("Berkeley Mono")
-- config.font_size = 26
-- config.line_height = 1.1

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

local M = {}

local function set_opts(wezterm, config, hostconf, theme)
	config.front_end = "WebGpu"

	if hostconf.dpi ~= nil then
		config.dpi = 108
	end

	-- font test
	local _ = "gq 1Il O0 0123456789 --> -> => == === != !== <= >= U u"
	--
	-- long time favorite font:
	config.font = wezterm.font("JetBrainsMono Nerd Font")
	config.font_size = hostconf.font_size

	config.bold_brightens_ansi_colors = "BrightAndBold"

	wezterm.log_info("Setting the theme to: " .. theme)
	config.color_scheme = theme

	config.window_padding = {
		left = "0cell",
		right = "0cell",
		top = "0cell",
		bottom = "0.0cell",
	}

	config.warn_about_missing_glyphs = true
	config.hide_mouse_cursor_when_typing = false
	config.enable_scroll_bar = false

	config.window_decorations = "RESIZE"
	config.window_background_opacity = 0.95
	-- config.window_background_opacity = 1
	config.macos_window_background_blur = 30
	config.hide_tab_bar_if_only_one_tab = false
	config.use_fancy_tab_bar = false
	config.tab_bar_at_bottom = true
	config.show_new_tab_button_in_tab_bar = false

	-- default is 60, so increase to prevent stuttering. Max is 255 (u8 in Rust)
	config.max_fps = 255
end

function M.setup(wezterm, config)
	local color_config = require("lib.colors").init(wezterm)
	local tab_fns = require("lib.tab_config")
	local keys = require("lib.key_config")
	local hostconf = require("lib.hostconf")[wezterm.hostname()]

	config.leader = keys.get_keybindings(wezterm).leader
	config.keys = keys.get_keybindings(wezterm).keys

	local is_transparent = config.window_background_opacity ~= 1.0
	config.colors = {
		tab_bar = tab_fns.tab_bar_colors(color_config.colors, is_transparent),
	}

	set_opts(wezterm, config, hostconf, color_config.theme)

	require("lib.custom_events").register_events(wezterm, tab_fns, color_config.colors, color_config.theme, hostconf)
end

return M

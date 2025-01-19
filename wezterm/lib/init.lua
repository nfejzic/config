local M = {}

--- @param wezterm table
--- @param config table
--- @param hostconf HostConfig
--- @param theme string | ColorTheme
local function set_opts(wezterm, config, hostconf, theme)
	if hostconf.dpi ~= nil then
		config.dpi = hostconf.dpi
	end

	-- font test
	local _ = "gq 1Il l O0 0123456789 --> -> => == === != !== <= >= U u"

	config.font = wezterm.font(hostconf.font.family)
	config.font_size = hostconf.font.size

	if hostconf.font.line_height ~= nil then
		config.line_height = hostconf.font.line_height
	end

	if hostconf.font.cell_width ~= nil then
		config.cell_width = hostconf.font.cell_width
	end

	if hostconf.font.freetype_load_flags ~= nil then
		config.freetype_load_flags = hostconf.font.freetype_load_flags
	end

	if hostconf.font.harfbuzz_features ~= nil then
		config.harfbuzz_features = hostconf.font.harfbuzz_features
	end

	config.adjust_window_size_when_changing_font_size = false

	config.bold_brightens_ansi_colors = "BrightAndBold"

	if type(theme) == "string" then
		config.color_scheme = theme
	elseif type(theme) == "table" then
		config.colors = {}
		for key, value in pairs(theme) do
			if not theme.is_not_standard(key) then
				config.colors[key] = value
			end
		end
	end

	if hostconf.window_padding ~= nil then
		config.window_padding = hostconf.window_padding
	else
		config.window_padding = {
			left = "0cell",
			right = "0cell",
			top = "0cell",
			bottom = "0cell",
		}
	end

	config.warn_about_missing_glyphs = true
	config.hide_mouse_cursor_when_typing = true
	config.cursor_blink_rate = 0
	config.enable_scroll_bar = false

	if hostconf.window_decorations ~= nil then
		config.window_decorations = hostconf.window_decorations
	else
		config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
	end

	config.window_background_opacity = 0.95
	config.window_background_opacity = 1
	config.macos_window_background_blur = 30
	config.hide_tab_bar_if_only_one_tab = false
	config.use_fancy_tab_bar = false
	config.tab_bar_at_bottom = true
	config.show_new_tab_button_in_tab_bar = false

	-- default is 60, so increase to prevent stuttering. Max is 255 (u8 in Rust)
	config.max_fps = 255
end

--- @param wezterm table
--- @param config table
function M.setup(wezterm, config)
	local color_config = require("lib.colors").init(wezterm, 'kanagawa-wave')
	local tab_fns = require("lib.tab_config")
	local keys = require("lib.key_config")
	local hostconf = require("lib.hostconf")[wezterm.hostname()]

	local keybindings

	if hostconf.get_keybindings ~= nil then
		keybindings = hostconf.get_keybindings(wezterm, hostconf.program_paths)
	else
		keybindings = keys.get_keybindings(wezterm, hostconf.program_paths)
	end

	config.leader = keybindings.leader
	config.keys = keybindings.keys

	local is_transparent = config.window_background_opacity ~= nil and config.window_background_opacity < 1.0

	set_opts(wezterm, config, hostconf, color_config.theme)

	if config.colors == nil then
		config.colors = {}
	end

	require("lib.hyperlinks").configure_hyperlinks(config, wezterm)

	config.colors.tab_bar = tab_fns.tab_bar_colors(color_config.colors, is_transparent)

	require("lib.custom_events").register_events(wezterm, tab_fns, color_config.colors, hostconf)
end

return M

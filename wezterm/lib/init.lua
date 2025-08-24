---@class Config
local M = {}

--- @param wezterm table
--- @param config table
--- @param hostconf HostConfig
--- @param theme string
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

	config.color_scheme = theme

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
		config.window_decorations = "TITLE|RESIZE"
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

--- @param hostconf_bindings GetKeybindingsFn
--- @param keys KeysConfig
--- @param wezterm Wezterm
--- @param program_paths ProgramPaths
--- @param utils Utils
--- @param tab_api TabApi
--- @param config table
local function configure_keybindings(hostconf_bindings, keys, wezterm, program_paths, utils, tab_api, config)
	local host_bindings = hostconf_bindings(wezterm)
	local keybindings = keys.get_keybindings(wezterm, program_paths, utils, tab_api, host_bindings)

	if host_bindings.custom_keybinds and type(host_bindings.custom_keybinds) == "table" then
		for _, value in pairs(host_bindings.custom_keybinds) do
			table.insert(keybindings.keys, value)
		end
	end

	config.leader = keybindings.leader
	config.keys = keybindings.keys
end

--- @param wezterm table
--- @param config table
function M.setup(wezterm, config)
	local os_appearance = wezterm.gui and wezterm.gui.get_appearance() or 'Dark'

	local color_config = require("lib.colors").init(
		{ dark = 'Gruvbox dark, hard (base16)', light = 'Gruvbox light, medium (base16)' },
		os_appearance,
		wezterm
	)
	local tab_api = require("lib.tab_config")
	local keys = require("lib.key_config")
	local hostconf = require("lib.hostconf").get_hostconf(wezterm.hostname())
	local utils = require('lib.utils')

	local program_paths = {
		fd = require("lib.utils").execute("which fd")
	}

	configure_keybindings(hostconf.get_keybindings, keys, wezterm, program_paths, utils, tab_api, config)
	set_opts(wezterm, config, hostconf, color_config.theme)

	if config.colors == nil then
		config.colors = {}
	end

	require("lib.hyperlinks").configure_hyperlinks(config, wezterm)

	config.colors.tab_bar = tab_api.tab_bar_colors(color_config.colors)

	require("lib.custom_events").register_events(
		wezterm, tab_api,
		color_config.colors, utils
	)

	-- local scale_factor = 2.21
	local scale_factor = 1.8
	local macbook_scale_factor = 1.63

	-- TODO(nfejzic): Is there a better way to handle this?
	local dpi_4k_27in = 124 * scale_factor
	local dpi_4k_32in = 112 * scale_factor
	-- NOTE: macbook is a little different...
	local dpi_macbook_pro_14in = 140 * macbook_scale_factor

	config.dpi_by_screen = {
		["Built-in Retina Display"] = dpi_macbook_pro_14in,
		["LG HDR QHD"] = dpi_4k_27in,
		["LG HDR 4K"] = dpi_4k_27in,
		["LG ULTRAFINE"] = dpi_4k_27in,
		["LEN T27p-10"] = dpi_4k_27in,
		["DELL U2724DE"] = dpi_4k_27in,
		["DELL P3223QE"] = dpi_4k_32in,
		["DELL P3225QE"] = dpi_4k_32in,
	}
end

return M

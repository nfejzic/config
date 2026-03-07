---@class MyConfig
local M = {}

--- @module "wezterm"
--- @param wezterm Wezterm
--- @param config Config
--- @param hostconf HostConfig
--- @param color_scheme string
local function set_opts(wezterm, config, hostconf, color_scheme)
	config.unix_domains = {
		-- NOTE: as per docs only this is necessary:
		--       See: https://wezterm.org/multiplexing.html#unix-domains
		---@diagnostic disable-next-line: missing-fields
		{ name = 'unix' }
	}
	config.default_gui_startup_args = { 'connect', 'unix' }


	config.dpi = hostconf.dpi or config.dpi
	config.font = wezterm.font(hostconf.font.family)
	config.font_size = hostconf.font.size
	config.line_height = hostconf.font.line_height or config.line_height
	config.cell_width = hostconf.font.cell_width or config.cell_width
	config.freetype_load_flags = hostconf.font.freetype_load_flags or config.freetype_load_flags
	config.harfbuzz_features = hostconf.font.harfbuzz_features or config.harfbuzz_features
	config.adjust_window_size_when_changing_font_size = false
	config.bold_brightens_ansi_colors = true
	config.color_scheme = color_scheme

	config.window_padding = hostconf.window_padding or {
		left = "0cell",
		right = "0cell",
		top = "0cell",
		bottom = "0cell",
	}

	config.window_content_alignment = {
		horizontal = 'Center',
		vertical = 'Center',
	}

	config.warn_about_missing_glyphs = true
	config.hide_mouse_cursor_when_typing = true
	config.cursor_blink_rate = 0
	config.enable_scroll_bar = false

	config.window_decorations = hostconf.window_decorations or "TITLE|RESIZE"

	config.window_background_opacity = 0.95
	config.window_background_opacity = 1
	config.macos_window_background_blur = 30
	config.hide_tab_bar_if_only_one_tab = false
	config.use_fancy_tab_bar = false
	config.tab_bar_at_bottom = true
	config.show_new_tab_button_in_tab_bar = false
	config.enable_kitty_keyboard = true

	-- default is 60, so increase to prevent stuttering. Max is 255 (u8 in Rust)
	config.max_fps = 255
end

--- @param hostconf_bindings GetKeybindingsFn
--- @param keys KeysConfig
--- @param wezterm Wezterm
--- @param program_paths ProgramPaths
--- @param utils Utils
--- @param tab_api TabApi
--- @param smart_splits SmartSplits
--- @param config table
local function configure_keybindings(
	hostconf_bindings,
	keys,
	wezterm,
	program_paths,
	utils,
	tab_api,
	smart_splits,
	config
)
	local host_bindings = hostconf_bindings(wezterm)
	local keybindings = keys.get_keybindings(
		wezterm, program_paths, utils, tab_api, host_bindings,
		smart_splits)

	if host_bindings.custom_keybinds and type(host_bindings.custom_keybinds) == "table" then
		for _, value in pairs(host_bindings.custom_keybinds) do
			table.insert(keybindings.keys, value)
		end
	end

	config.leader = keybindings.leader
	config.keys = keybindings.keys

	smart_splits.apply_to_config(config, {
		modifiers = {
			move = {
				wezterm = host_bindings.super,
				neovim = "ALT",
			},
			resize = {
				wezterm = host_bindings.super_shift,
				neovim = "ALT|SHIFT",
			},
		},
	})
end

--- @param wezterm table
--- @param config Config
--- @param plugins UserPlugins
function M.setup(wezterm, config, plugins)
	local os_appearance = wezterm.gui and wezterm.gui.get_appearance() or 'Dark'

	local color_scheme = require("lib.colors").get_color_scheme(
		{ dark = 'gruvbox-dark-hard', light = 'kanagawa-lotus' },
		os_appearance
	)
	local tab_api = require("lib.tab_api")
	local keys = require("lib.key_config")
	local hostconf = require("lib.hostconf").get_hostconf(wezterm.hostname())
	local utils = require('lib.utils')

	local program_paths = {
		fd = require("lib.utils").execute("which fd")
	}

	configure_keybindings(hostconf.get_keybindings, keys, wezterm, program_paths,
		utils, tab_api, plugins.smart_splits, config)

	set_opts(wezterm, config, hostconf, color_scheme)

	require("lib.hyperlinks").configure_hyperlinks(config, wezterm)

	require("lib.custom_events").register_events(wezterm, tab_api, utils)

	-- local scale_factor = 2.21
	local scale_factor = 1.2
	local macbook_scale_factor = 1.05

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

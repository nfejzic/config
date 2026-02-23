---@module "wezterm"
---@diagnostic disable: unused-local

--- @param wezterm Wezterm
--- @type GetKeybindingsFn
local function get_keybindings(wezterm)
	local act = wezterm.action
	local super = 'SUPER'
	local super_shift = 'SUPER|SHIFT'

	local custom_keybinds = {
		{
			key = 'Backspace',
			mods = 'OPT',
			action = act.SendKey {
				key = 'w',
				mods = 'CTRL',
			},
		}
	}

	for _, key in pairs({ "h", "j", "k", "l" }) do
		table.insert(custom_keybinds, {
			key = key,
			mods = super,
			action = act.DisableDefaultAssignment,
		})
	end

	-- table.insert(custom_keybinds, {
	-- 	key = key,
	-- 	mods = super_shift,
	-- 	action = act.SendKey {
	-- 		key = key,
	-- 		mods = 'OPT|SHIFT',
	-- 	}
	-- })

	--- @type KeybindsConfig
	return {
		super = super,
		super_shift = super_shift,
		custom_keybinds = custom_keybinds,
	}
end

local font_size = 19

--- @type FontConfig
local monolisa = {
	family = "MonoLisa",
	size = font_size - 1,
	line_height = 1.00,
	cell_width = 1,
	harfbuzz_features = {
		"ss11", -- centered 'x' in 0xF
		"calt=0", -- no white-space ligatures
	},
}

local utils = require("lib.utils")

--- @type FontConfig
local comic_code = utils.tbl.copy_and_overwrite(monolisa, {
	family = "Comic Code",
	line_height = 1.15,
	harfbuzz_features = { "zero", "dlig" },
})

--- @type HostConfig
local config = {
	dpi = 108,
	font = monolisa,
	update_dpi = false,
	program_paths = {
		fd = require("lib.utils").execute("which fd")
	},
	get_keybindings = get_keybindings,
	window_padding = {
		top = "0cell",
		right = "0cell",
		bottom = "0cell",
		left = "0cell"
	},
	window_decorations = "MACOS_USE_BACKGROUND_COLOR_AS_TITLEBAR_COLOR|TITLE|RESIZE",
}

config.font = monolisa
config.font.freetype_load_flags = "NO_AUTOHINT"

-- table.insert(config.font.harfbuzz_features, "calt=0")
-- table.insert(config.font.harfbuzz_features, "liga=0")
-- table.insert(config.font.harfbuzz_features, "dlig=0")

return config

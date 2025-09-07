---@module "wezterm"
---@diagnostic disable: unused-local

--- @param wezterm Wezterm
--- @type GetKeybindingsFn
local function get_keybindings(wezterm)
	local act = wezterm.action

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
			mods = 'SUPER',
			action = act.DisableDefaultAssignment,
		})

		table.insert(custom_keybinds, {
			key = key,
			mods = 'SUPER',
			action = act.SpawnTab("CurrentPaneDomain"),
		})

		table.insert(custom_keybinds, {
			key = key,
			mods = 'SUPER|SHIFT',
			action = act.SendKey {
				key = key,
				mods = 'OPT|SHIFT',
			}
		})
	end

	--- @type KeybindsConfig
	return {
		super = 'SUPER',
		super_shift = 'SUPER|SHIFT',
		custom_keybinds = custom_keybinds,
	}
end

local font_size = 21.5

--- @type FontConfig
local defaults = {
	family = "MonoLisa",
	size = font_size,
	line_height = 1.00,
	cell_width = 1,
	harfbuzz_features = {
		-- "ss02", -- cursive letters
		-- "ss04", -- single-loop 'g'
		-- "ss07", -- more agressive '{' and '}'
		-- "ss11", -- centered 'x' in 0xF
		-- "calt=0", -- no white-space ligatures
	},
}

local utils = require("lib.utils")

--- @type FontConfig
local jetbrains_mono = utils.tbl.copy_and_overwrite(defaults, {
	family = "JetBrains Mono",
	size = font_size + 0.5,
	line_height = 1.02,
})

--- @type FontConfig
local comic_code = utils.tbl.copy_and_overwrite(defaults, {
	family = "Comic Code",
	line_height = 1.15,
	harfbuzz_features = { "zero", "dlig" },
})

--- @type FontConfig
local monolisa = {
	family = "MonoLisa",
	size = font_size - 1,
	line_height = 1.0,
	cell_width = 1,
	harfbuzz_features = {
		-- "ss02", -- cursive letters
		-- "ss04", -- single-loop 'g'
		-- "ss07", -- more agressive '{' and '}'
		"ss11", -- centered 'x' in 0xF
		"calt=0", -- no white-space ligatures
	},
}

--- @type FontConfig
local sf_mono = utils.tbl.copy_and_overwrite(defaults, {
	family = "SF Mono",
	line_height = 1.15,
})

--- @type FontConfig
local codelia = utils.tbl.copy_and_overwrite(defaults, {
	family = "Codelia Ligatures",
	line_height = 1.07,
	harfbuzz_features = {
		--                    ////
		"zero", -- dotted '0' ///
		"ss02", -- serif 'l'  // ->  == !=
	},
})


--- @type FontConfig
local commit_mono = utils.tbl.copy_and_overwrite(defaults, {
	family = "CommitMonoHS",
	line_height = 1.2,
	harfbuzz_features = {
		"calt=0",
		"ss01", -- math ligatures e.g. '<='
		"ss02", -- arrow ligatures e.g. '->' or '=>'
	},
})

--- @type FontConfig
local berkeley_mono = {
	family = "TX-02",
	size = font_size - 0.5,
	line_height = 1.0,
	cell_width = 1.0,
	harfbuzz_features = {
		-- NOTE: this font does not implement ligatures well unfortunately...
		"calt=0",
	},
}

--- @type FontConfig
local recursive_mono_linear = utils.tbl.copy_and_overwrite(defaults, {
	family = "Recursive Mono Linear Static",
	line_height = 1.1,
	harfbuzz_features = {
		"ss03", -- simplified 'f'
		"ss10", -- dotted '0'
		"ss12", -- simplified '@'
		"liga", -- ->
		"dlig",
	},
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
	window_decorations =
	"MACOS_USE_BACKGROUND_COLOR_AS_TITLEBAR_COLOR|TITLE|RESIZE"
	-- window_decorations = "TITLE|RESIZE"
}

local noto_sans_mono = require("lib.utils").tbl.copy_and_overwrite(monolisa, {
	family = "Noto Sans Mono",
	size = font_size + 1,
	line_height = 0.97,
	harfbuzz_features = {},
})

config.font = monolisa
-- config.font = sf_mono
config.font = berkeley_mono
-- config.font = comic_code
-- config.font = noto_sans_mono
-- config.font = atkinson_hyperlegible
-- config.font = maple_mono
-- config.font = codelia
-- config.font = jetbrains_mono
config.font.freetype_load_flags = "NO_AUTOHINT"

-- table.insert(config.font.harfbuzz_features, "calt=0")
-- table.insert(config.font.harfbuzz_features, "liga=0")
-- table.insert(config.font.harfbuzz_features, "dlig=0")

return config

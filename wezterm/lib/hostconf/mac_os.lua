--- @type GetKeybindingsFn
local function get_keybindings(wezterm)
	local act = wezterm.action

	--- @type KeybindsConfig
	return {
		super = 'SUPER',
		super_shift = 'SUPER|SHIFT',
		custom_keybinds = {
			{
				key = 'Backspace',
				mods = 'OPT',
				action = act.SendKey {
					key = 'w',
					mods = 'CTRL',
				},
			},
		}
	}
end

local font_size = 14.25

--- @type FontConfig
--- @diagnostic disable-next-line: unused-local
local jetbrains_mono = {
	family = "JetBrains Mono",
	size = font_size + 0.5,
	cell_width = 1,
	line_height = 1.02,
}

--- @type FontConfig
--- @diagnostic disable-next-line: unused-local
local comic_code = {
	family = "Comic Code",
	size = font_size,
	line_height = 1.15,
	cell_width = 1.00,
	harfbuzz_features = { "zero", "dlig" },
}

--- @type FontConfig
--- @diagnostic disable-next-line: unused-local
local atkinson_hyperlegible = {
	family = "Atkinson Hyperlegible Mono",
	size = font_size,
	line_height = 1.15,
	cell_width = 1.00,
	harfbuzz_features = {
		-- -> != !==
		"liga",
		"calt",
		"dlig",
		"zero",
	},
}

--- @type FontConfig
--- @diagnostic disable-next-line: unused-local
local monolisa = {
	family = "MonoLisa",
	size = font_size,
	line_height = 1.00,
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
--- @diagnostic disable-next-line: unused-local
local codelia = {
	family = "Codelia Ligatures",
	size = font_size,
	line_height = 1.07,
	cell_width = 1,
	harfbuzz_features = {
		--                    ////
		"zero", -- dotted '0' ///
		"ss02", -- serif 'l'  //
	},
}


--- @type FontConfig
--- @diagnostic disable-next-line: unused-local
local commit_mono = {
	family = "CommitMonoHS",
	size = font_size,
	line_height = 1.2,
	cell_width = 1,
	harfbuzz_features = {
		"calt=0",
		"ss01", -- math ligatures e.g. '<='
		"ss02", -- arrow ligatures e.g. '->' or '=>'
	},
}

--- @type FontConfig
--- @diagnostic disable-next-line: unused-local
local berkeley_mono = {
	family = "TX-02",
	size = font_size + 0.5,
	line_height = 1.1,
	cell_width = 1.0,
	harfbuzz_features = {
		-- ->
		"ss06",
		"calt=1" -- /// // |
	},
}

--- @type FontConfig
--- @diagnostic disable-next-line: unused-local
local recursive_mono_linear = {
	family = "Recursive Mono Linear Static",
	size = font_size,
	line_height = 1.1,
	cell_width = 1.0,
	harfbuzz_features = {
		"ss03", -- simplified 'f'
		"ss10", -- dotted '0'
		"ss12", -- simplified '@'
		"liga", -- ->
		"dlig",
	},
}

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
	window_decorations = "MACOS_USE_BACKGROUND_COLOR_AS_TITLEBAR_COLOR|TITLE|RESIZE"
	-- window_decorations = "TITLE|RESIZE"
}

config.font = monolisa
-- config.font = berkeley_mono
config.font = comic_code
-- config.font = atkinson_hyperlegible
-- config.font = codelia
-- config.font = jetbrains_mono
config.font.freetype_load_flags = "NO_AUTOHINT"
config.font.harfbuzz_features = {
	"liga=0"
}

return config

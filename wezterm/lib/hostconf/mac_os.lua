---@type GetKeybindingsFn
local function get_keybindings(wezterm, _, _, tab_api)
	local act = wezterm.action

	return {
		keys = {
			-- send Ctrl-w on Ctrl-Backspace | Opt-Backspace
			{
				key = 'Backspace',
				mods = 'OPT',
				action = act.SendKey {
					key = 'w',
					mods = 'CTRL',
				},
			},

			{
				key = 'Backspace',
				mods = 'CTRL',
				action = act.SendKey {
					key = 'w',
					mods = 'CTRL',
				},
			},

			{
				key = "d",
				mods = "SUPER",
				action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
			},

			{
				key = "d",
				mods = "SUPER|SHIFT",
				action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
			},

			{
				key = "w",
				mods = "SUPER",
				action = act.CloseCurrentPane({ confirm = false }),
			},

			-- go to pane to the left of current pane
			{
				key = "h",
				mods = "SUPER",
				action = act.ActivatePaneDirection("Left"),
			},

			-- go to pane to the right of current pane
			{
				key = "l",
				mods = "SUPER",
				action = act.ActivatePaneDirection("Right"),
			},

			-- go to pane below current pane
			{
				key = "j",
				mods = "SUPER",
				action = act.ActivatePaneDirection("Down"),
			},

			-- go to pane above current pane
			{
				key = "k",
				mods = "SUPER",
				action = act.ActivatePaneDirection("Up"),
			},

			-- pane resizing
			{
				key = "H",
				mods = "SUPER|SHIFT",
				action = act.AdjustPaneSize({ "Left", 5 }),
			},

			{
				key = "J",
				mods = "SUPER|SHIFT",
				action = act.AdjustPaneSize({ "Down", 5 }),
			},

			{
				key = "K",
				mods = "SUPER|SHIFT",
				action = act.AdjustPaneSize({ "Up", 5 }),
			},

			{
				key = "L",
				mods = "SUPER|SHIFT",
				action = act.AdjustPaneSize({ "Right", 5 }),
			},

			-- create tab next to the active tab
			{
				key = "t",
				mods = "SUPER",
				action = wezterm.action_callback(tab_api
					.spawn_tab_next_to_active(wezterm)),
			},

			{
				key = "t",
				mods = "SUPER|SHIFT",
				action = act.SpawnTab("CurrentPaneDomain"),
			},

			-- go to next tab
			{
				key = "n",
				mods = "SUPER",
				action = act.ActivateTabRelative(1),
			},

			-- go to previous tab
			{
				key = "p",
				mods = "SUPER",
				action = act.ActivateTabRelative(-1),
			},

		},
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

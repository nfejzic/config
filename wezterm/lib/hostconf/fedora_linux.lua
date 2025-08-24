---@type GetKeybindingsFn
local function get_keybindings(wezterm)
	local act = wezterm.action

	--- @type KeybindsConfig
	return {
		super = 'ALT',
		super_shift = 'ALT|SHIFT',
		custom_keybinds = {
			-- mimic macos Cmd-V for paste
			{
				key = "v",
				mods = "ALT",
				action = act.PasteFrom('Clipboard'),
			},
		}
	}
end

--- @type FontConfig
---@diagnostic disable-next-line: unused-local
local comic_code = {
	family = "Comic Code",
	size = 17,
	cell_width = 1.00,
	line_height = 1.12,
	harfbuzz_features = {
		-- dotted zero
		"zero"
	}
}

--- @type FontConfig
---@diagnostic disable-next-line: unused-local
local jetbrains_mono = {
	family = "JetBrains Mono",
	size = 15,
	cell_width = 1,
}

--- @type FontConfig
---@diagnostic disable-next-line: unused-local
local jetbrains_mono_comfy = {
	family = "JetBrains Mono",
	size = 16,
	cell_width = 1,
}

--- @type FontConfig
--- @diagnostic disable-next-line: unused-local
local monolisa = {
	-- Font custom-hosted here: https://github.com/nfejzic/monolisa
	family = "MonoLisa",
	size = 23,
	cell_width = 1,
	line_height = 1.00,
	freetype_load_flags = "NO_HINTING",
	harfbuzz_features = {
		-- centered hexadecimal 0xF
		"ss11",
	},
}

--- @type HostConfig
local config = {
	dpi = nil,
	font = comic_code,
	update_dpi = false,
	program_paths = { fd = "/usr/bin/fd" },
	get_keybindings = get_keybindings,
	window_decorations = "NONE",
}

return config

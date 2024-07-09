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
---@diagnostic disable-next-line: unused-local
local comic_code = {
	family = "Comic Code Ligatures",
	size = 12,
	line_height = 1.1,
	cell_width = 1,
}

--- @type FontConfig
--- @diagnostic disable-next-line: unused-local
local monolisa = {
	-- Font custom-hosted here: https://github.com/nfejzic/monolisa
	family = "MonoLisa",
	size = 15,
	cell_width = 1,
	freetype_load_flags = "NO_HINTING",
	harfbuzz_features = {
		-- strike-through '$'
		"ss13",

		-- centered hexadecimal 0xF
		"ss11",
	},
}

--- @type HostConfig
local config = {
	dpi = nil,
	font = monolisa,
	-- font = monolisa,
	update_dpi = false,
	program_paths = { fd = "/usr/bin/fd" },
}

return config

--- @type FontConfig
---@diagnostic disable-next-line: unused-local
local jetbrains_mono = {
	family = "JetBrains Mono",
	size = 13,
	cell_width = 1,
}

--- @type FontConfig
---@diagnostic disable-next-line: unused-local
local jetbrains_mono_comfy = {
	family = "JetBrains Mono",
	size = 20,
	cell_width = 1,
	line_height = 1,
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
	size = 12.5,
	harfbuzz_features = {
		-- strike-through '$'
		"ss13",

		-- centered hexadecimal 0xF
		"ss11",
	},
}

--- @type FontConfig
--- @diagnostic disable-next-line: unused-local
local monolisa_comfy = {
	-- Font custom-hosted here: https://github.com/nfejzic/monolisa
	family = "MonoLisa",
	size = 14.0,
	harfbuzz_features = {
		-- strike-through '$'
		"ss13",

		-- centered hexadecimal 0xF
		"ss11",
	},
}

--- @type FontConfig
---@diagnostic disable-next-line: unused-local
local geist_mono = {
	family = "Geist Mono",
	size = 13.5,
	cell_width = 1,
}

--- @type HostConfig
local config = {
	dpi = 108,
	font = monolisa,
	update_dpi = true,
	program_paths = {
		fd = "/opt/homebrew/bin/fd",
	},
}

-- I can always go back to this one...

config.font = jetbrains_mono
config.font = monolisa

return config

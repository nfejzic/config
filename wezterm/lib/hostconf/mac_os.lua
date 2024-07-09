--- @type FontConfig
---@diagnostic disable-next-line: unused-local
local jetbrains_mono = {
	family = "JetBrains Mono",
	size = 13,
	cell_width = 1,
	harfbuzz_features = {
		"cv03", -- looped 'g'
		"cv07", -- looped 'g'
		"cv10", -- serif on 'r'
		"cv11", -- rounded 'y'
		"cv12", -- regular 'u'
		"ss20", -- raised bar 'f'
	},
}

--- @type FontConfig
---@diagnostic disable-next-line: unused-local
local jetbrains_mono_comfy = {
	family = "JetBrains Mono",
	size = 15,
	-- cell_width = 1,
	-- line_height = 1.0,
	harfbuzz_features = {
		"cv03", -- looped 'g'
		"cv07", -- looped 'g'
		"cv10", -- serif on 'r'
		"cv11", -- rounded 'y'
		"cv12", -- regular 'u'
		"ss20", -- raised bar 'f'
	},
}

--- @type FontConfig
---@diagnostic disable-next-line: unused-local
local comic_code = {
	family = "Comic Code Ligatures",
	size = 13,
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
	size = 15,
	-- line_height = 0.95,
	-- cell_width = 1,
	harfbuzz_features = {
		-- strike-through '$'
		"ss13",

		-- centered hexadecimal 0xF
		"ss11",
	},
}

--- @type FontConfig
--- @diagnostic disable-next-line: unused-local
local monolisa_huge = {
	-- Font custom-hosted here: https://github.com/nfejzic/monolisa
	family = "MonoLisa",
	size = 18,
	line_height = 1,
	cell_width = 1,
	harfbuzz_features = {
		-- strike-through '$'
		"ss13",

		-- centered hexadecimal 0xF
		"ss11",
	},
}

--- @type FontConfig
---@diagnostic disable-next-line: unused-local
local fira_code = {
	family = "Fira Code",
	size = 12.75,
	cell_width = 1,
	line_height = 1.07,
}

--- @type FontConfig
---@diagnostic disable-next-line: unused-local
local fira_code_comfy = {
	family = "Fira Code",
	size = 15,
	cell_width = 1,
	line_height = 1.07,
	harfbuzz_features = {},
}

--- @type FontConfig
---@diagnostic disable-next-line: unused-local
local fira_code_huge = {
	family = "Fira Code",
	size = 18,
	cell_width = 1,
	line_height = 1.12,
	harfbuzz_features = {
		"zero", -- dotted zero
		"cv14", -- sharp 3
	},
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

config.font = jetbrains_mono
config.font = monolisa
config.font = jetbrains_mono_comfy
-- config.font.size = 19
config.font = monolisa_comfy
-- config.font = monolisa_huge

return config

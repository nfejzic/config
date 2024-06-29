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
	size = 15,
	cell_width = 1,
	line_height = 1,
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
	line_height = 0.95,
	cell_width = 1,
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
	line_height = 0.95,
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
local geist_mono = {
	family = "Geist Mono",
	size = 13.5,
	cell_width = 1,
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
local maple_mono = {
	family = "Maple Mono",
	size = 13.0,
	cell_width = 1,
}

--- @type FontConfig
---@diagnostic disable-next-line: unused-local
local noto_sans_mono = {
	family = "Noto Sans Mono",
	size = 13.0,
	cell_width = 1,
	line_height = 0.95,
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

--- @type FontConfig
---@diagnostic disable-next-line: unused-local
local commit_mono = {
	family = "CommitMono",
	size = 13.5,
	cell_width = 1,
	line_height = 1.15,
}

-- I can always go back to this one...

config.font = jetbrains_mono
config.font = monolisa
config.font = jetbrains_mono_comfy
config.font.size = 18
config.font = monolisa_huge

return config

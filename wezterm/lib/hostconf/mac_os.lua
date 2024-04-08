--- @type HostConfig
local config = {
	dpi = 108,
	font = {
		-- Font custom-hosted here: https://github.com/nfejzic/monolisa
		family = "MonoLisa",
		size = 11.5,
		harfbuzz_features = {
			-- strike-through '$'
			"ss13",

			-- centered hexadecimal 0xF
			"ss11",
		},
	},
	update_dpi = true,
	program_paths = {
		fd = "/opt/homebrew/bin/fd",
	},
}

-- I can always go back to this one...

-- config.font = {
-- 	family = "JetBrains Mono",
-- 	size = 12,
-- 	cell_width = 1,
-- }

return config

local wezterm = require("wezterm")

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
local config = wezterm.config_builder()

local library = require("lib.init")
library.setup(wezterm, config)

return config

--- @type Wezterm
local wezterm = require("wezterm")

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
local config = wezterm.config_builder()

local smart_splits = wezterm.plugin.require('https://github.com/mrjones2014/smart-splits.nvim')

--- @class UserPlugins
local plugins = {
	smart_splits = smart_splits,
}

local library = require("lib.init")
library.setup(wezterm, config, plugins)

config.automatically_reload_config = false

return config

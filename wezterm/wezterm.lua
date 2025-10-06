--- @type Wezterm
local wezterm = require("wezterm")

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
local config = wezterm.config_builder()

local smart_splits = wezterm.plugin.require('https://github.com/mrjones2014/smart-splits.nvim')

--- @class SmartSplits
--- @field apply_to_config function(config_builder: Config, plugin_config: SmartSplitsWeztermConfig|nil): Config
--- @field is_vim function(pane: Wezterm.Pane): boolean

--- @class UserPlugins
local plugins = {
	--- @type SmartSplits
	smart_splits = smart_splits,
}

---@alias IsVimFn function(pane: wezterm.Pane): boolean

local library = require("lib.init")
library.setup(wezterm, config, plugins)

config.automatically_reload_config = false

return config

--- @module "wezterm"

---@class FontConfig
---@field family string
---@field size number
---@field line_height number|nil
---@field cell_width number|nil
---@field freetype_load_flags string|nil
---@field harfbuzz_features table<number, string>|nil

--- @class KeybindsConfig
--- @field super string
--- @field super_shift string
--- @field custom_keybinds table

---@alias GetKeybindingsFn fun(wezterm: Wezterm): KeybindsConfig

---@class HostConfig
---@field dpi integer|nil
---@field font FontConfig
---@field update_dpi boolean
---@field get_keybindings GetKeybindingsFn
---@field window_decorations string|nil
---@field window_padding WindowPadding|nil

--- @type table<string, HostConfig>
local configs = {
	["zenith"] = require("lib.hostconf.mac_os"),
	["edification"] = require("lib.hostconf.fedora_linux"),
}

local M = {}

---@param hostname string name of the host
---@return HostConfig
function M.get_hostconf(hostname)
	if configs[hostname] ~= nil then
		return configs[hostname]
	else
		return configs["zenith"]
	end
end

return M

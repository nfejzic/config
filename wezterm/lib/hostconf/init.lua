---@class FontConfig
---@field family string
---@field size number
---@field line_height number|nil
---@field cell_width number|nil
---@field freetype_load_flags string|nil
---@field harfbuzz_features table<number, string>|nil

---@class WindowPadding
---@field top string
---@field right string
---@field bottom string
---@field left string

---@class HostConfig
---@field dpi integer|nil
---@field font FontConfig
---@field update_dpi boolean
---@field get_keybindings function|nil
---@field window_decorations string|nil
---@field window_padding WindowPadding|nil

---@type HostConfig
local mac_hostconf = require("lib.hostconf.mac_os")

---@type HostConfig
local mirza_mac_conf = require("lib.utils").table.copy(mac_hostconf)
mirza_mac_conf.dpi = nil
mirza_mac_conf.window_padding.top = "28pt"

--- @type table<string, HostConfig>
local configs = {
	["zenith"] = mac_hostconf,
	["Mirzas-mac.local"] = mirza_mac_conf,
	["edification"] = require("lib.hostconf.fedora_linux"),
	["percolation"] = require("lib.hostconf.percolation"),
}

local M = {}

---@param hostname string name of the host
---@return HostConfig
function M.get_hostconf(hostname)
	if configs[hostname] ~= nil then
		return configs[hostname]
	else
		return mac_hostconf
	end
end

return M

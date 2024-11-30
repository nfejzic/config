---@class FontConfig
---@field family string
---@field size number
---@field line_height number|nil
---@field cell_width number|nil
---@field freetype_load_flags string|nil
---@field harfbuzz_features table<number, string>|nil

---@class ProgramPaths
---@field fd string

---@class WindowPadding
---@field top string
---@field right string
---@field bottom string
---@field left string

---@class HostConfig
---@field dpi integer|nil
---@field font FontConfig
---@field update_dpi boolean
---@field program_paths ProgramPaths
---@field get_keybindings function|nil
---@field window_decorations string|nil
---@field window_padding WindowPadding|nil

--- @type table<string, HostConfig>
local configs = {
	["zenith"] = require("lib.hostconf.mac_os"),
	["edification"] = require("lib.hostconf.fedora_linux"),
	["percolation"] = require("lib.hostconf.percolation"),
}

return configs

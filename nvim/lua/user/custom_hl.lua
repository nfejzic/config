---@param hl_name string
---@param hl_opts vim.api.keyset.highlight
local function mod_hl(hl_name, hl_opts)
	local is_ok, hl_def = pcall(vim.api.nvim_get_hl, 0, { name = hl_name })

	if is_ok then
		for k, v in pairs(hl_opts) do
			hl_def[k] = v
		end

		---@diagnostic disable-next-line: param-type-mismatch
		vim.api.nvim_set_hl(0, hl_name, hl_def)
	end
end

--- Copy highlights from one to another
---@param from_hl string
---@param to_hl string
local function copy_hl(from_hl, to_hl)
	local is_ok1, from_hl_def = pcall(vim.api.nvim_get_hl, 0, { name = from_hl })
	local to_hl_def = {}

	if is_ok1 then
		for k, v in pairs(from_hl_def) do
			to_hl_def[k] = v
		end

		vim.api.nvim_set_hl(0, to_hl, to_hl_def)
	end
end

mod_hl("LspInlayHint", { bg = "none" })

local customization_map = {
	["zenbones"] = require("user.colorscheme.zenbones").customize,
	["rose-pine"] = require("user.colorscheme.rose-pine").customize,
	["solarized-high"] = require("user.colorscheme.solarized").customize("high"),
}

local M = {}

function M.customize()
	local current_scheme = vim.api.nvim_exec2("colorscheme", { output = true }).output
	local customize_scheme = customization_map[current_scheme]

	if customize_scheme ~= nil then
		customize_scheme(mod_hl)
	end
end

return M

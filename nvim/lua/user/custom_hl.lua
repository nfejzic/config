---@param hl_name string
---@param hl_opts vim.api.keyset.highlight
local function mod_hl(hl_name, hl_opts)
	local is_ok, hl_def = pcall(vim.api.nvim_get_hl, 0, { name = hl_name })

	if is_ok then
		for k, v in pairs(hl_opts) do
			hl_def[k] = v
		end

		vim.api.nvim_set_hl(0, hl_name, hl_def)
	end
end

mod_hl("LspInlayHint", { bg = "none" })

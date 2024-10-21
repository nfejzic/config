local M = {}

---@param mod_hl function(string, vim.api.keyset.highlight)
function M.customize(mod_hl)
	mod_hl("@variable", { italic = false })
	mod_hl("@variable.parameter", { italic = false })
	mod_hl("@lsp.type.parameter.lua", { italic = false })
end

return M

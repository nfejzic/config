local M = {}

---@param mod_hl function(string, vim.api.keyset.highlight)
local function customize_high(mod_hl)
	print("Customizing solarized high")

	local line_nr = vim.api.nvim_get_hl(0, { name = "LineNr" })

	mod_hl("SignColumn", { link = "LineNr" })
	mod_hl("DiagnosticSignError", { bg = line_nr.bg })
	mod_hl("DiagnosticSignWarn", { bg = line_nr.bg })
	mod_hl("DiagnosticSignInfo", { bg = line_nr.bg })
	mod_hl("DiagnosticSignHint", { bg = line_nr.bg })
	mod_hl("NormalFloat", { link = "Normal" })
end

---@param variant "high"
function M.customize(variant)
	if variant == "high" then
		return customize_high
	end
end

return M

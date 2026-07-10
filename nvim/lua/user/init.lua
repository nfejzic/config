require("user.opts")
require("plugins")
-- require("user.lazy")
require("user.keymaps")
require("user.autocommands")

local utils = require("user.utils")

if not utils.is_llm_prompt() then
	require("user.lsp").setup()
end

local colorscheme = vim.g.nfejzic_colorscheme or "rose-pine"

vim.cmd("colo " .. colorscheme)

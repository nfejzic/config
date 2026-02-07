require("user.opts")
require("user.lazy")
require("user.keymaps")
require("user.autocommands")

local utils = require("user.utils")

if not utils.is_llm_prompt() then
	require("user.lsp").setup()
end

vim.cmd("colo colorize")

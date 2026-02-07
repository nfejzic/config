local utils = require("user.utils")

return {
	{ "neovim/nvim-lspconfig" },

	cond = not utils.is_llm_prompt(),

	-- TODO: figure out what to do with typescript-tools
	-- {
	-- 	"https://github.com/pmizio/typescript-tools.nvim",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"neovim/nvim-lspconfig"
	-- 	},
	--
	-- 	lazy = true,
	-- 	config = true,
	-- 	ft = { "typescript", "typescriptreact", "tsx", "javascript", "javascriptreact", "jsx", "vue" },
	-- },

	{
		"williamboman/mason.nvim",
		version = "2.*",

		lazy = false,
	},

	-- fidget spinner shows LSP loading progress
	{
		"j-hui/fidget.nvim",
		lazy = true,
	},
}

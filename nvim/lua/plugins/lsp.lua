return {
	{
		"https://github.com/pmizio/typescript-tools.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"neovim/nvim-lspconfig"
		},

		lazy = true,
		config = true,
		ft = { "typescript", "typescriptreact", "tsx", "javascript", "javascriptreact", "jsx", "vue" },
	},
	{
		"williamboman/mason.nvim",
		version = "1.*",
		opts = {
			ui = {
				border = "rounded",
			},
		},
	},

	-- fidget spinner shows LSP loading progress
	{
		"j-hui/fidget.nvim",
		lazy = true,
	},
}

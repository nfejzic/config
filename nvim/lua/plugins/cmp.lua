return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "L3MON4D3/LuaSnip", lazy = true },
			{ "saadparwaiz1/cmp_luasnip", lazy = true },
			{ "nvim-lua/plenary.nvim" },
		},

		lazy = false,
		priority = 100,

		config = function()
			require("user.completion")
		end,
	},
}

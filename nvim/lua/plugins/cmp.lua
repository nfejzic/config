return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" },
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "L3MON4D3/LuaSnip", lazy = true },
			{ "saadparwaiz1/cmp_luasnip", lazy = true },
			{ "nvim-lua/plenary.nvim" },

			-- Icons in auto-complete of LSP (i.e. function, variable etc)
			{ "onsails/lspkind-nvim" },
		},

		lazy = true,
		event = { "InsertEnter", "CmdlineEnter" },

		config = function()
			require("user.completion")
		end,
	},
}

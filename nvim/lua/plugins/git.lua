return {
	-- git signs in gutter
	{
		"lewis6991/gitsigns.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },

		lazy = true,
		event = "VeryLazy",

		config = function()
			local gs = require("gitsigns")
			gs.setup({
				signs = {},
				numhl = false,
				current_line_blame = false,
				preview_config = {
					border = "rounded",
				},
			})

			require("user.keymaps").gitsigns(gs)
		end,
	},

	-- git conflicts visualisation and resolving
	{
		"akinsho/git-conflict.nvim",
		version = "*",
		config = true,
		lazy = true,
		event = "VeryLazy",
	},

	{
		"tpope/vim-fugitive",
		lazy = true,
		cmd = "Git",

		config = function()
			---@diagnostic disable-next-line: inject-field
			vim.g.fugitive_dynamic_colors = 1
		end,
	},
}

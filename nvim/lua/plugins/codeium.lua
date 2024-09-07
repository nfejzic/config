return {
	{
		"Exafunction/codeium.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},

		lazy = true,
		event = "InsertEnter",

		config = function()
			if string.match(vim.fn.hostname(), "percolation") then
				-- AI tools not allowed at work
				return
			end

			require("codeium").setup({})
		end,
	},
}

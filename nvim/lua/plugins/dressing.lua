return {
	{
		"stevearc/dressing.nvim",
		opts = {
			input = {
				start_in_insert = false,
				insert_only = false,
				win_options = {
					winblend = 0,
				},
			},
			select = {
				enabled = false,
			}
		},
		lazy = true,
		event = "VeryLazy",
	},
}

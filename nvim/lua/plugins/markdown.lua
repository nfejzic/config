return {
	{
		"toppair/peek.nvim",
		lazy = true,
		ft = "markdown",
		build = "deno task --quiet build:fast",
		enabled = false,
		config = function()
			require("peek").setup({
				app = "browser",
			})

			vim.api.nvim_create_autocmd({ "FileType" }, {
				pattern = "markdown",
				once = true,
				callback = function()
					vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
					vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
				end,
			})
		end,
	},
}

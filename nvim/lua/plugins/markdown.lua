return {
	{
		"toppair/peek.nvim",
		lazy = true,
		ft = "markdown",
		build = "deno task --quiet build:fast",
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

	{
		'MeanderingProgrammer/render-markdown.nvim',
		enabled = false,
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			file_types = { 'markdown', 'Avante', 'nofile' },
			log_level = 'debug',
			overrides = {
				buftype = {
					nofile = {
						render_modes = { "n", "c", "i" },
						debounce = 5,
						code = {
							left_pad = 0,
							right_pad = 0,
							language_pad = 0,
						},
					},
				},
				filetype = {},
			},
		},
		ft = { 'markdown', 'Avante', 'nofile' },
	}
}

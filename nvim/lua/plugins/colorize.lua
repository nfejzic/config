return {
	'nfejzic/colorize.nvim',
	lazy = false,
	dev = true,
	priority = 1000,

	config = function()
		local colorize = require('colorize')

		vim.g.colorize_lualine_bold = true

		colorize.setup({
			compile = true, -- enable compiling the colorscheme
			undercurl = true, -- enable undercurls
			commentStyle = { italic = true },
			functionStyle = {},
			keywordStyle = { italic = false, bold = false },
			statementStyle = { bold = false },
			typeStyle = { italic = false, bold = false },
			transparent = false,
			dimInactive = false,
			terminalColors = true,
			theme = "gruvbox-dark-hard",
			background = {
				dark = "gruvbox-dark-hard",
				light = "gruvbox-light",
			},
			semantic_highlighting = "minimal",
		})
	end
}

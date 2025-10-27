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
			keywordStyle = { italic = false, bold = true },
			statementStyle = { bold = true },
			typeStyle = { italic = false, bold = false },
			transparent = false,
			dimInactive = false,
			terminalColors = true,
			theme = "gruvbox-dark-hard",
			background = {
				dark = "kanagawa-wave",
				light = "kanagawa-lotus",
			},
			semantic_highlighting = false,
		})
	end
}

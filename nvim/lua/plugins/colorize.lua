return {
	{
		'nfejzic/colorize.nvim',
		lazy = false,
		dev = true,
		priority = 1000,
		opts = {
			compile = false, -- enable compiling the colorscheme
			undercurl = true, -- enable undercurls
			commentStyle = { italic = false },
			functionStyle = {},
			keywordStyle = { italic = false, bold = false },
			statementStyle = { bold = false },
			typeStyle = { italic = false, bold = false },
			transparent = false, -- do not set background color
			dimInactive = false, -- dim inactive window `:h hl-NormalNC`
			terminalColors = true, -- define vim.g.terminal_color_{0,17}
			theme = "kanagawa", -- Load "kanagawa" theme when 'background' option is not set
			semantic_highlighting = "minimal",
		}
	}
}

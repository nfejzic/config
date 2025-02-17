return {
	{
		'nfejzic/colorize.nvim',
		lazy = false,
		dev = true,
		priority = 1000,
		lualine_bold = true,
		config = function()
			local colorize = require('colorize')

			vim.g.colorize_lualine_bold = true

			colorize.setup({
				compile = false, -- enable compiling the colorscheme
				undercurl = true, -- enable undercurls
				commentStyle = { italic = true },
				functionStyle = {},
				keywordStyle = { italic = false, bold = false },
				statementStyle = { bold = false },
				typeStyle = { italic = false, bold = false },
				transparent = false, -- do not set background color
				dimInactive = false, -- dim inactive window `:h hl-NormalNC`
				terminalColors = true, -- define vim.g.terminal_color_{0,17}
				theme = "kanagawa", -- Load "kanagawa" theme when 'background' option is not set
				semantic_highlighting = "minimal",
			})
		end
	}
}

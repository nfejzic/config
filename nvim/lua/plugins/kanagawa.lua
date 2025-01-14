return {
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		enabled = true,
		opts = {
			compile = true, -- enable compiling the colorscheme
			undercurl = true, -- enable undercurls
			commentStyle = { italic = true },
			functionStyle = {},
			keywordStyle = { italic = false, bold = false },
			statementStyle = { bold = false },
			typeStyle = { italic = false, bold = false },
			transparent = false, -- do not set background color
			dimInactive = false, -- dim inactive window `:h hl-NormalNC`
			terminalColors = true, -- define vim.g.terminal_color_{0,17}
			theme = "wave", -- Load "wave" theme when 'background' option is not set
		},
	},
}

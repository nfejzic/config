vim.g.colorize_lualine_bold = true

require("colorize").setup({
	compile = true, -- enable compiling the colorscheme
	undercurl = true, -- enable undercurls
	commentStyle = { italic = false },
	functionStyle = {},
	keywordStyle = { italic = false, bold = false },
	statementStyle = { bold = false },
	typeStyle = { italic = false, bold = false },
	transparent = false, -- do not set background color
	dimInactive = false, -- dim inactive window `:h hl-NormalNC`
	terminalColors = true, -- define vim.g.terminal_color_{0,17}
	theme = "kanagawa-wave", -- Load "kanagawa-wave" theme when 'background' option is not set
	semantic_highlighting = "minimal",
})

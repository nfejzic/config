---@class ThemeConfig
---@field dark ThemeChoice
---@field light ThemeChoice

---@type table<string, ThemeConfig>
local theme_options = {
	['catppuccin_frappe'] = {
		light = 'catppuccin-frappe',
		dark = 'catppuccin-latte',
	},
	['catppuccin_mocha'] = {
		light = 'catppuccin-mocha',
		dark = 'catppuccin-latte',
	},
	['catppuccin_macchiato'] = {
		light = 'catppuccin-macchiato',
		dark = 'catppuccin-latte',
	},
	['catppuccin_latte'] = {
		light = 'catppuccin-latte',
		dark = 'catppuccin-latte',
	},
	['gruvbox_dark_hard'] = {
		light = 'gruvbox-light-soft',
		dark = 'gruvbox-dark-hard',
	},
	['solarized_light'] = {
		light = 'solarized-dark',
		dark = 'solarized-dark',
	},
	['solarized_dark'] = {
		light = 'solarized-dark',
		dark = 'solarized-dark',
	},
	['solarized_dark_hard'] = {
		light = 'solarized-dark-hard',
		dark = 'solarized-dark-hard',
	},
	['kanagawa'] = {
		light = 'kanagawa-lotus',
		dark = 'kanagawa-wave',
	},
	['rose_pine'] = {
		light = 'rose-pine-dawn',
		dark = 'rose-pine-main',
	},
	['zenbones'] = {
		light = 'kanso-pearl',
		dark = 'kanso-zen',
	},
	['transparent'] = {
		light = 'gruvbox-dark-hard',
		dark = 'gruvbox-light-soft',
	},
}

return {
	'nfejzic/colorize.nvim',
	lazy = false,
	dev = true,
	priority = 1000,
	lualine_bold = true,
	config = function()
		local colorize = require('colorize')

		vim.g.colorize_lualine_bold = true

		local cli_theme_var = os.getenv("CLI_THEME") or "transparent"
		local theme_opt = theme_options[cli_theme_var]

		colorize.setup({
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
			background = {
				dark = theme_opt.dark,
				light = theme_opt.light,
			},
			semantic_highlighting = "minimal",
		})
	end
}

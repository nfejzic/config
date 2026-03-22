return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,

		opts = {
			background = { -- :h background
				light = "latte",
				dark = "macchiato",
			},
		}
	},

	{
		'nfejzic/colorize.nvim',
		lazy = false,
		dev = true,
		priority = 1000,

		config = function()
			local colorize = require('colorize')

			vim.g.colorize_lualine_bold = true

			colorize.setup({
				compile = true, -- enable compiling the colorscheme
				undercurl = false, -- enable undercurls
				commentStyle = { italic = false },
				functionStyle = {},
				keywordStyle = { italic = false, bold = false },
				statementStyle = { bold = false },
				typeStyle = { italic = false, bold = false },
				transparent = false,
				dimInactive = false,
				terminalColors = true,
				semantic_highlighting = "minimal",
			})
		end
	},

	{
		"rebelot/kanagawa.nvim",

		opts = {
			compile = true, -- enable compiling the colorscheme
			theme = "wave", -- Load "wave" theme
			background = { -- map the value of 'background' option to a theme
				dark = "wave", -- try "dragon" !
				light = "lotus"
			},
		}
	},

	{
		"rose-pine/neovim",
		name = "rose-pine",

		config = function()
			require("rose-pine").setup({
				variant = "auto", -- auto, main, moon, or dawn
				dark_variant = "moon", -- main, moon, or dawn

				dim_inactive_windows = true,
				disable_background = false,
				styles = {
					italic = false,
				},

				highlight_groups = {
					QuickFixLine = { fg = "none", bg = "highlight_low", bold = true },
				},
			})
		end
	},
}

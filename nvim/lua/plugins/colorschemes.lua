return {
	-- some nice themes
	{ "folke/tokyonight.nvim",        lazy = true,    event = "BufWinEnter", enabled = false },
	{ "EdenEast/nightfox.nvim",       lazy = true,    event = "BufWinEnter", enabled = false },
	{ "wincent/base16-nvim",          enabled = false },
	{ "ishan9299/nvim-solarized-lua", lazy = true,    event = "BufWinEnter", enabled = false },
	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = true,
		event = "BufWinEnter",
		enabled = false,
		config = function()
			require("rose-pine").setup({
				variant = "auto",
				disable_float_background = true,
				styles = {
					bold = true,
					italic = true,
					transparency = false,
				},
				groups = {
					keywords = "rose",
				},
				-- Change specific vim highlight groups
				-- https://github.com/rose-pine/neovim/wiki/Recipes
				highlight_groups = {
					Comment = { fg = "rose" },
					["@comment.documentation"] = { fg = "iris" },
					DiagnosticSignInfo = { bg = "surface" },
					DiagnosticSignWarn = { bg = "surface" },
					DiagnosticSignError = { bg = "surface" },
					DiagnosticSignHint = { bg = "surface" },
				},
			})
		end,
	},

	{ "shaunsingh/nord.nvim", lazy = true, event = "BufWinEnter", enabled = false },
	{ "savq/melange-nvim",    lazy = true, event = "BufWinEnter", enabled = false },
	{
		"loctvl842/monokai-pro.nvim",
		lazy = true,
		event = "BufWinEnter",
		enabled = false,
		opts = {
			styles = {
				comment = { italic = true },
				keyword = { italic = true },
				type = { italic = false },
				storageclass = { italic = false },
				structure = { italic = false },
				parameter = { italic = false },
				annotation = { italic = false },
				tag_attribute = { italic = false },
			},
			filter = "pro",   -- classic | octagon | pro | machine | ristretto | spectrum
			-- Enable this will disable filter option
			inc_search = "background", -- underline | background
			background_clear = {
				"toggleterm",
				"telescope",
				"renamer",
				"notify",
			}, -- "float_win", "toggleterm", "telescope", "which-key", "renamer", "neo-tree", "nvim-tree", "bufferline"
		},
	},

	{
		"mcchrish/zenbones.nvim",
		dependencies = { "rktjmp/lush.nvim" },
		lazy = false,
		enabled = false,
		priority = 1000,
		config = function()
			vim.g.zenbones = {
				solid_line_nr = true,
				transparent_background = false,
			}
		end
	},
}

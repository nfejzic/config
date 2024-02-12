return {
	-- some nice themes
	{ "folke/tokyonight.nvim", lazy = false },

	{ "EdenEast/nightfox.nvim", lazy = false },

	{ "RRethy/nvim-base16", lazy = false },

	-- { "wincent/base16-nvim" },

	{ "ishan9299/nvim-solarized-lua", lazy = false },

	{
		"rose-pine/neovim",
		name = "rose-pine",
		lazy = false,
		config = function()
			require("rose-pine").setup({
				variant = "auto",
				disable_float_background = true,

				groups = {
					keywords = "rose",
				},

				-- Change specific vim highlight groups
				-- https://github.com/rose-pine/neovim/wiki/Recipes
				highlight_groups = {
					Comment = { fg = "subtle" },
					["@comment.documentation"] = { fg = "iris" },
					-- ["@lsp.type.comment.rust"] = {},
					-- ["@mut_specifier"] = { fg = colors.yellow },
					-- ["@ref_specifier"] = { link = "@mut_specifier" },

					-- SignColumn = { fg = "text", bg = "surface" },
					-- LineNr = { link = "SignColumn" },

					-- GitSignsAdd = { bg = "surface" },
					-- GitSignsModified = { bg = "surface" },
					-- GitSignsChange = { bg = "surface" },
					-- GitSignsDelete = { bg = "surface" },

					-- NeoTreeGitAdded = { fg = colors.green },
					-- NeoTreeGitModified = { fg = colors.yellow },
					-- NeoTreeGitDeleted = { fg = colors.red },
					-- NeoTreeGitConflict = { fg = colors.peach, style = { "italic" } },
					-- NeoTreeGitUntracked = { link = "NeoTreeGitConflict" },

					DiagnosticSignInfo = { bg = "surface" },
					DiagnosticSignWarn = { bg = "surface" },
					DiagnosticSignError = { bg = "surface" },
					DiagnosticSignHint = { bg = "surface" },

					-- NormalFloat = {},

					-- LspInlayHint = { link = "Comment" },

					-- TreesitterContext = { link = "SignColumn" }
				},
			})
		end,
	},

	{ "shaunsingh/nord.nvim", lazy = true },

	{ "savq/melange-nvim", lazy = true },

	{
		"loctvl842/monokai-pro.nvim",
		lazy = true,
		opts = {
			transparent_background = false,
			terminal_colors = true,
			devicons = true, -- highlight the icons of `nvim-web-devicons`
			styles = {
				comment = { italic = true },
				keyword = { italic = true }, -- any other keyword
				type = { italic = true }, -- (preferred) int, long, char, etc
				storageclass = { italic = true }, -- static, register, volatile, etc
				structure = { italic = true }, -- struct, union, enum, etc
				parameter = { italic = true }, -- parameter pass in function
				annotation = { italic = true },
				tag_attribute = { italic = true }, -- attribute of tag in reactjs
			},
			filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
			-- Enable this will disable filter option
			day_night = {
				enable = false, -- turn off by default
				day_filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
				night_filter = "spectrum", -- classic | octagon | pro | machine | ristretto | spectrum
			},
			inc_search = "background", -- underline | background
			background_clear = {
				-- "float_win",
				"toggleterm",
				"telescope",
				-- "which-key",
				"renamer",
				"notify",
				-- "nvim-tree",
				-- "neo-tree",
				-- "bufferline", -- better used if background of `neo-tree` or `nvim-tree` is cleared
			}, -- "float_win", "toggleterm", "telescope", "which-key", "renamer", "neo-tree", "nvim-tree", "bufferline"
			plugins = {
				bufferline = {
					underline_selected = false,
					underline_visible = false,
				},
				indent_blankline = {
					context_highlight = "default", -- default | pro
					context_start_underline = false,
				},
			},
			-- ---@param _c Colorscheme
			-- override = function(_c) end,
		},
	},

	{
		"mcchrish/zenbones.nvim",
		dependencies = { "rktjmp/lush.nvim" },
		lazy = true,
	},
}

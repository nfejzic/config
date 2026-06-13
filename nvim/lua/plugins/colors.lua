return {
	{
		"ellisonleao/gruvbox.nvim",

		config = function()
			local gruvbox = require("gruvbox")
			local p = gruvbox.palette

			local function choose(light, dark)
				return vim.o.background == 'light' and light or dark
			end

			local function create_config()
				return {
					terminal_colors = true,
					undercurl = true,
					underline = true,
					bold = true,
					italic = {
						strings = false,
						emphasis = true,
						comments = true,
						operators = false,
						folds = true,
					},
					strikethrough = true,
					invert_selection = false,
					invert_signs = false,
					invert_tabline = false,
					inverse = true,
					contrast = "hard",
					palette_overrides = {},
					overrides = {
						-- QuickFixLine = { fg = "none", bg = "highlight_low", bold = true },
						GitSignsAddInline = { link = "DiffText" },
						GitSignsChangeInline = { link = "DiffText" },
						GitSignsDeleteInline = { link = "DiffText" },
						-- ["@lsp.type.formatSpecifier"] = { fg = "love" },
						["@lsp.type.builtinType"] = { link = "@type.builtin" },
						["@lsp.type.interface"] = { link = "Type" },

						-- make coloring consistent...
						["@variable"] = { link = "Variable" },
						["@variable.member"] = { link = "Variable" },
						["@variable.parameter"] = { link = "Variable" },
						["@lsp.type.variable"] = { link = "Variable" },
						["@parameter"] = { link = "Variable" },
						-- the '_' in Rust... who linked this to 'Character'
						["@character.special.rust"] = { link = "Variable" },
						["@property"] = { link = "Variable" },
						["@punctuation"] = { link = "GruvboxFg3" },
						["@punctuation.bracket"] = { link = "@punctuation" },
						["@punctuation.delimiter"] = { link = "@punctuation" },
						["@operator"] = { link = "@punctuation" },
						["@constructor"] = { link = "@punctuation" },

						Function = { link = "GruvboxBlue" },
						["@lsp.type.namespace"] = { link = "@module" },
						["@lsp.type.method"] = { link = "Function" },
						["@lsp.type.comment.lua"] = { link = "none" },

						Keyword = { link = "GruvboxPurple" },
						["@constant.macro"] = { link = "PreProc" },
						["@function.macro.rust"] = { link = "PreProc" },
						["@keyword.exception"] = { link = "PreProc" },
						["@mutable_specifier"] = { link = "PreProc" },

						Constant = { link = "GruvboxOrange" },
						Number = { link = "Constant" },
						DiagnosticUnnecessary = { link = "DiagnosticUnderlineWarn", },
						BlinkCmpDocBorder = { link = "FloatBorder" },
						Directory = { link = "GruvboxBlueBold" },

						LineNr = { link = "CursorLineFold" },

						NormalFloat = { bg = choose(p.light1, p.dark1) },
						FloatTitle = { link = "GruvboxGreenSign" },
						SnacksNormal = { link = "NormalFloat" },
						SnacksPicker = { link = "NormalFloat" },
						SnacksPickerListCursorLine = { bg = choose(p.light2, p.dark2) },
						SnacksPickerMatch = { fg = p.bright_aqua, bold = true },
						SnacksInputNormal = { link = "NormalFloat" },
						SnacksInputBorder = { link = "NormalFloat" },
						SnacksInputTitle = { bg = choose(p.light1, p.dark1) },

						Todo = { fg = p.bright_yellow, bg = "none" },
						["@comment.error.comment"] = { fg = p.bright_red },
						["@constant.comment"] = { fg = p.bright_purple },

						-- NOTE: custom treesitter queries for accented keywords
						["@accent"] = { link = "GruvboxYellow" },
					},
					dim_inactive = false,
					transparent_mode = false,
				}
			end

			gruvbox.setup(create_config())

			-- HACK(nfejzic): force gruvbox to choose light and dark colors
			--				  based on background when background changes
			local grp = vim.api.nvim_create_augroup("gruvbox-background-change", { clear = true })
			vim.api.nvim_create_autocmd("OptionSet", {
				group = grp,
				pattern = "background",
				callback = function()
					if vim.g.colors_name ~= "gruvbox" then
						return
					end

					gruvbox.setup(create_config())
					gruvbox.load()
				end,
			})
		end,
	},

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
		enabled = false,

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
				dimInactive = true,
				terminalColors = true,
				semantic_highlighting = "minimal",
				background = {
					dark = "kanagawa-wave",
					light = "kanagawa-lotus",
				}
			})
		end
	},

	{
		"rebelot/kanagawa.nvim",

		opts = {
			compile = true, -- enable compiling the colorscheme
			theme = "wave", -- Load "wave" theme
			transparent = false,
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
					italic = true,
				},

				highlight_groups = {
					QuickFixLine = { fg = "none", bg = "highlight_low", bold = true },
					GitSignsAddInline = { link = "DiffText" },
					GitSignsChangeInline = { link = "DiffText" },
					GitSignsDeleteInline = { link = "DiffText" },
					["@lsp.type.formatSpecifier"] = { fg = "love" },
					["@lsp.type.builtinType"] = { link = "@type.builtin" },

					-- make coloring consistent...
					Variable = { fg = "text" },
					["@variable.builtin"] = { fg = "gold", italic = true },
					["@variable"] = { link = "Variable" },
					["@variable.member"] = { link = "Variable" },
					["@variable.parameter"] = { link = "Variable" },
					["@lsp.type.variable"] = { link = "Variable" },
					["@parameter"] = { link = "Variable" },
					-- the '_' in Rust... who linked this to 'Character'
					["@character.special.rust"] = { link = "Variable" },
					["@property"] = { link = "Variable" },

					["@lsp.type.namespace"] = { link = "@module" },
					["@lsp.mod.defaultLibrary"] = { bold = true },
					["@lsp.type.const"] = { link = "Constant" },

					["@keyword.operator"] = { link = "Keyword" },
					["@constant.macro"] = { link = "PreProc" },
					["@function.macro.rust"] = { link = "PreProc" },
					["@keyword.exception"] = { link = "PreProc" },
					["@accent"] = { fg = "love" },

					DiagnosticUnnecessary = { link = "DiagnosticUnderlineWarn", },

					BlinkCmpDocBorder = { link = "FloatBorder" },

					-- NOTE: custom treesitter queries for accented keywords
					["@accent"] = { fg = "love" },
				},
			})
		end
	},
}

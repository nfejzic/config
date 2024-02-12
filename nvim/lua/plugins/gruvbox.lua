return {
	-- original gruvbox colorscheme
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			-- setup must be called before loading the colorscheme
			-- Default options:
			local gruvbox = require("gruvbox")

			vim.o.background = "dark"
			local contrast = "hard"

			local function get_colors()
				local p = gruvbox.palette

				local bg = vim.o.background

				local color_groups = {
					dark = {
						bg0 = p.dark0,
						bg1 = p.dark1,
						bg2 = p.dark2,
						bg3 = p.dark3,
						bg4 = p.dark4,
						fg0 = p.light0,
						fg1 = p.light1,
						fg2 = p.light2,
						fg3 = p.light3,
						fg4 = p.light4,
						red = p.bright_red,
						green = p.bright_green,
						yellow = p.bright_yellow,
						blue = p.bright_blue,
						purple = p.bright_purple,
						aqua = p.bright_aqua,
						orange = p.bright_orange,
						neutral_red = p.neutral_red,
						neutral_green = p.neutral_green,
						neutral_yellow = p.neutral_yellow,
						neutral_blue = p.neutral_blue,
						neutral_purple = p.neutral_purple,
						neutral_aqua = p.neutral_aqua,
						dark_red = p.dark_red,
						dark_green = p.dark_green,
						dark_aqua = p.dark_aqua,
						gray = p.gray,
					},
					light = {
						bg0 = p.light0,
						bg1 = p.light1,
						bg2 = p.light2,
						bg3 = p.light3,
						bg4 = p.light4,
						fg0 = p.dark0,
						fg1 = p.dark1,
						fg2 = p.dark2,
						fg3 = p.dark3,
						fg4 = p.dark4,
						red = p.faded_red,
						green = p.faded_green,
						yellow = p.faded_yellow,
						blue = p.faded_blue,
						purple = p.faded_purple,
						aqua = p.faded_aqua,
						orange = p.faded_orange,
						neutral_red = p.neutral_red,
						neutral_green = p.neutral_green,
						neutral_yellow = p.neutral_yellow,
						neutral_blue = p.neutral_blue,
						neutral_purple = p.neutral_purple,
						neutral_aqua = p.neutral_aqua,
						dark_red = p.light_red,
						dark_green = p.light_green,
						dark_aqua = p.light_aqua,
						gray = p.gray,
					},
				}

				if contrast ~= nil and contrast ~= "" then
					color_groups[bg].bg0 = p[bg .. "0_" .. contrast]
					color_groups[bg].dark_red = p[bg .. "_red_" .. contrast]
					color_groups[bg].dark_green = p[bg .. "_green_" .. contrast]
					color_groups[bg].dark_aqua = p[bg .. "_aqua_" .. contrast]
				end

				return color_groups[bg]
			end

			local colors = get_colors()

			gruvbox.setup({
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
				invert_indent_guides = false,
				inverse = true, -- invert background for search, diffs, statuslines and errors
				contrast = contrast, -- can be "hard", "soft" or empty string
				palette_overrides = {},
				overrides = {
					Function = { fg = colors.blue, bg = "none" },
					Identifier = { fg = colors.fg2, bg = "none" },
					["@field"] = { fg = colors.fg2, bg = "none" },

					["@lsp.type.interface"] = { link = "@type.definition" },
					["@lsp.type.enumMember"] = { link = "@lsp.type.enum" },
					["@lsp.type.lifetime"] = { fg = colors.aqua },
					["@storageclass.lifetime"] = { fg = colors.aqua },
					["@lsp.mod.constant.rust"] = { link = "Constant" },

					Comment = { fg = colors.orange },
					["@comment"] = { link = "Comment" },

					["@comment.note.comment"] = { link = "GruvboxAqua" },

					["@comment.documentation"] = { fg = colors.aqua },
					["@lsp.mod.documentation"] = {},
					["@lsp.type.comment"] = {},
					["@lsp.typemod.comment.injected"] = { link = "Comment" },
					-- ["@lsp.typemod.comment.injected.rust"] = { link = "Comment" },
					-- ["@lsp.typemod.comment.documentation.rust"] = { link = "@comment.documentation" },

					["@punctuation.delimiter"] = { fg = colors.fg2 },
					["@punctuation.bracket"] = { fg = colors.fg2 },
					["@label"] = { link = "@lsp.type.lifetime" },

					["@lsp.type.keyword"] = { link = "@keyword" },
					["@lsp.type.punctuation"] = { link = "@punctuation.bracket" },
					["@lsp.type.operator"] = { link = "Operator" },

					TreesitterContext = { bg = colors.bg1 },

					-- NormalFloat = { fg = colors.fg4, bg = colors.bg0 },
					NormalFloat = { link = "Normal" },
					SignColumn = { link = "LineNr" },

					DiagnosticSignError = { fg = colors.red },
					DiagnosticSignWarn = { fg = colors.yellow },
					DiagnosticSignHint = { fg = colors.aqua },
					DiagnosticSignInfo = { fg = colors.blue },

					-- dap ui not optimized...
					DapUIStopNC = { bg = "none" },
					DapUIRestartNC = { bg = "none" },
					DapUIStepOutNC = { bg = "none" },
					DapUIStepBackNC = { bg = "none" },
					DapUIStepIntoNC = { bg = "none" },
					DapUIStepOverNC = { bg = "none" },
					DapUIPlayPauseNC = { bg = "none" },
					DapUIUnavailableNC = { bg = "none" },
					DapUINormalNC = { bg = "none" },

					DapUIStop = { bg = "none" },
					DapUIRestart = { bg = "none" },
					DapUIStepOut = { bg = "none" },
					DapUIStepBack = { bg = "none" },
					DapUIStepInto = { bg = "none" },
					DapUIStepOver = { bg = "none" },
					DapUIPlayPause = { bg = "none" },
					DapUIUnavailable = { bg = "none" },
					DapUINormal = { bg = "none" },

					["@lsp.type.builtinType.rust"] = {},
					["@lsp"] = {},

					-- neotest -> no support...
					NeotestDir = { fg = colors.fg0 },
					NeotestFile = { fg = colors.fg0 },
					NeotestTest = { fg = colors.blue },
					NeotestNamespace = { fg = colors.fg0 },
					NeotestAdapterName = { fg = colors.aqua },

					NeotestFocused = { fg = colors.yellow },

					NeotestFailed = { fg = colors.red },
					NeotestMarked = { fg = colors.orange },
					NeotestPassed = { fg = colors.green },
					NeotestTarget = { fg = colors.blue },
					NeotestRunning = { fg = colors.yellow },
					NeotestSkipped = { fg = colors.gray },
					NeotestUnknown = { fg = colors.purple },
					NeotestWatching = { fg = colors.yellow },
					NeotestWinSelect = { fg = colors.yellow },

					NeotestIndent = { fg = colors.gray },
					NeotestExpandMarker = { fg = colors.gray },
				},
				dim_inactive = false,
				transparent_mode = true,
			})
			-- vim.cmd("colo gruvbox")
		end,
	},
}

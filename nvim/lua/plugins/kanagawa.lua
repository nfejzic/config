return {
	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		opts = {
			compile = true, -- enable compiling the colorscheme
			undercurl = true, -- enable undercurls
			commentStyle = { italic = true },
			functionStyle = {},
			keywordStyle = { italic = false },
			statementStyle = { bold = true },
			typeStyle = {},
			transparent = false, -- do not set background color
			dimInactive = false, -- dim inactive window `:h hl-NormalNC`
			terminalColors = true, -- define vim.g.terminal_color_{0,17}
			colors = {
				-- add/modify theme and palette colors
				palette = {},
				theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
			},
			overrides = function(colors) -- add/modify highlights
				return {
					Function = { fg = colors.blue, bg = "none" },
					Identifier = { fg = colors.fg2, bg = "none" },
					["@field"] = { fg = colors.fg2, bg = "none" },

					["@lsp.type.interface"] = { link = "@type.definition" },
					["@lsp.type.enumMember"] = { fg = colors.orange },
					["@lsp.type.lifetime"] = { fg = colors.aqua },
					["@storageclass.lifetime"] = { fg = colors.aqua },

					Comment = { fg = colors.orange },
					["@comment"] = { link = "Comment" },
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
					-- SignColumn = { fg = colors.gray, bg = colors.bg1 },
					-- LineNr = { link = "SignColumn" },

					NeoTreeGitAdded = { fg = colors.green },
					NeoTreeGitDeleted = { fg = colors.red },
					NeoTreeGitModified = { fg = colors.aqua },

					GitSignsAdd = { fg = colors.green, bg = colors.bg1 },
					GitSignsModified = { fg = colors.orange, bg = colors.bg1 },
					GitSignsChange = { fg = colors.yellow, bg = colors.bg1 },
					GitSignsDelete = { fg = colors.red, bg = colors.bg1 },

					-- in neo-tree etc. (currently nightly-only)
					DiagnosticSignCustomError = { fg = colors.red, bg = "none" },
					DiagnosticSignCustomWarn = { fg = colors.yellow, bg = "none" },
					DiagnosticSignCustomHint = { fg = colors.aqua, bg = "none" },
					DiagnosticSignCustomInfo = { fg = colors.blue, bg = "none" },
				}
			end,
			theme = "wave", -- Load "wave" theme when 'background' option is not set
			background = {
				-- map the value of 'background' option to a theme
				dark = "wave", -- try "dragon" !
				light = "lotus",
			},
		},
	},
}

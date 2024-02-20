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
			typeStyle = { italic = false },
			transparent = false, -- do not set background color
			dimInactive = false, -- dim inactive window `:h hl-NormalNC`
			terminalColors = true, -- define vim.g.terminal_color_{0,17}
			overrides = function(_colors) -- add/modify highlights
				local theme = _colors.theme
				return {
					["@field"] = { fg = theme.syn.variable, bg = "none" },
					["@module"] = { link = "@variable" },
					Identifier = { fg = theme.syn.variable },

					Type = { fg = theme.syn.identifier },
					-- ["@lsp.type.interface"] = { fg = colors.surimiYellow },
					["@lsp.type.lifetime"] = { fg = theme.syn.string },
					["@storageclass.lifetime"] = { fg = theme.syn.string },

					Comment = { fg = theme.syn.constant },
					["@comment"] = { link = "Comment" },
					["@comment.documentation"] = { fg = theme.syn.string },
					["@lsp.mod.documentation"] = {},
					["@lsp.type.comment"] = {},
					["@lsp.typemod.comment.injected"] = { link = "Comment" },

					["@punctuation.delimiter"] = { fg = theme.ui.fg },
					["@punctuation.bracket"] = { fg = theme.ui.fg },
					["@constructor.lua"] = { fg = theme.ui.fg },
					["@label"] = { link = "@lsp.type.lifetime" },

					["@lsp.type.keyword"] = { link = "@keyword" },
					["@lsp.type.punctuation"] = { link = "@punctuation.bracket" },
					Operator = { fg = theme.syn.constant },
					["@lsp.type.operator"] = { link = "Operator" },

					-- transparent floating windows
					NormalFloat = { bg = "none" },
					FloatBorder = { bg = "none" },
					FloatTitle = { bg = "none" },

					-- Save an hlgroup with dark background and dimmed foreground
					-- so that you can use it where your still want darker windows.
					-- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
					NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

					-- Popular plugins that open floats will link to NormalFloat by default;
					-- set their background accordingly if you wish to keep them dark and borderless
					LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
					MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
				}
			end,
			theme = "wave", -- Load "wave" theme when 'background' option is not set
		},
	},
}

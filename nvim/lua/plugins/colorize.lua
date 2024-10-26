return {
	{
		'nfejzic/colorize.nvim',
		lazy = false,
		dev = true,
		priority = 1000,
		opts =
		{
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
			overrides = function(colors) -- add/modify highlights
				local theme = colors.theme
				return {
					Boolean = { bold = false },

					Comment = { fg = theme.syn.comment },
					["@comment"] = { link = "Comment" },
					["@comment.documentation"] = { fg = theme.syn.docComment },
					["@markup.heading.gitcommit"] = { fg = theme.syn.variable },
					["@constant.comment"] = { link = "Constant" },

					["@lsp.mod.documentation"] = {},
					["@lsp.type.comment"] = {},
					["@lsp.typemod.comment.injected"] = { link = "Comment" },
					["@lsp.typemod.comment.documentation"] = { link = "@comment.documentation" },
					["@lsp.type.selfKeyword"] = { fg = theme.syn.constant },
					["@keyword.modifier"] = { fg = theme.syn.preproc },
					["@attribute"] = { fg = theme.syn.docComment },
					["@attribute.builtin"] = { link = "@attribute" },
					["@lsp.type.lifetime"] = { link = "@attribute" },

					-- ["@comment.note"] = { fg = theme.ui.fg },
					-- ["@comment.error"] = { fg = theme.ui.fg, bg = theme.diag.error },
					-- ["@comment.warning"] = { fg = theme.ui.fg, bg = theme.diff.text },
					-- ["@keyword.modifier"] = { fg = theme.syn.preproc }, -- these are important!
					-- Todo = { fg = theme.ui.bg, bg = theme.syn.constant },
					--
					-- ["@punctuation.delimiter"] = { fg = theme.ui.fg },
					-- ["@punctuation.bracket"] = { fg = theme.ui.fg },
					-- ["@constructor.lua"] = { fg = theme.ui.fg },
					-- ["@label"] = { link = "@lsp.type.lifetime" },
					--
					["@lsp.type.keyword"] = { link = "none" },
					["@module"] = { link = "@variable" },
					["@lsp.type.namespace"] = { link = "none" },

					-- -- transparent floating windows
					NormalFloat = { bg = "none" },
					FloatBorder = { bg = "none" },
					FloatTitle = { bg = "none" },

					-- -- Save an hlgroup with dark background and dimmed foreground
					-- -- so that you can use it where your still want darker windows.
					-- -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
					-- NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
					--
					-- -- Popular plugins that open floats will link to NormalFloat by default;
					-- -- set their background accordingly if you wish to keep them dark and borderless
					-- LazyNormal = { fg = theme.ui.fg_dim },
					-- MasonNormal = { fg = theme.ui.fg_dim },
					--
					TelescopeTitle = { fg = theme.syn.identifier, bold = false },
					-- TelescopePromptNormal = { bg = "none" },
					-- TelescopePromptBorder = { bg = "none" },
					-- TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = "none" },
					-- TelescopeResultsBorder = { bg = "none" },
					-- TelescopePreviewNormal = { bg = "none" },
					-- TelescopePreviewBorder = { bg = "none" },
					--
					-- -- neotest -> no support...
					-- NeotestDir = { fg = theme.syn.fun },
					-- NeotestFile = { fg = theme.syn.fun },
					-- NeotestTest = { fg = theme.syn.identifier },
					-- NeotestNamespace = { fg = theme.syn.fun },
					-- NeotestAdapterName = { fg = theme.syn.string },
					--
					-- NeotestFocused = { fg = theme.syn.constant },
					--
					-- NeotestFailed = { fg = theme.syn.special2 },
					-- NeotestMarked = { fg = theme.syn.constant },
					-- NeotestPassed = { fg = theme.syn.string },
					-- NeotestTarget = { fg = theme.syn.identifier },
					-- NeotestRunning = { fg = theme.syn.constant },
					-- NeotestSkipped = { fg = theme.syn.comment },
					-- NeotestUnknown = { fg = theme.syn.keyword },
					-- NeotestWatching = { fg = theme.syn.constant },
					-- NeotestWinSelect = { fg = theme.syn.constant },
					--
					-- NeotestIndent = { fg = theme.syn.comment },
					-- NeotestExpandMarker = { fg = theme.syn.comment },
					--
					-- NvimDapVirtualText = { link = "LspInlayHint" },
				}
			end,
			theme = "dh", -- Load "wave" theme when 'background' option is not set
		}
	}
}

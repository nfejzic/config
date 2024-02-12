return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		config = function()
			local function customHighlights(colors)
				return {
					-- disable @lsp highlight
					["@lsp"] = {},

					Comment = { fg = colors.maroon },
					["@comment.documentation"] = { fg = colors.teal },
					["@lsp.type.comment.rust"] = {},
					["@lsp.type.enumMember.rust"] = { link = "@lsp.type.enum" },
					["@mut_specifier"] = { fg = colors.yellow },
					["@ref_specifier"] = { link = "@mut_specifier" },
					["@constant.rust"] = { link = "Constant" },

					LineNr = { link = "SignColumn" },
					CursorLineNr = { link = "SignColumn" },
					TreesitterContextLineNumber = { link = "SignColumn" },
					CursorColumn = { link = "CursorLine" },

					NeoTreeGitAdded = { fg = colors.green },
					NeoTreeGitModified = { fg = colors.yellow },
					NeoTreeGitDeleted = { fg = colors.red },
					NeoTreeGitConflict = { fg = colors.peach, style = { "italic" } },
					NeoTreeGitUntracked = { link = "NeoTreeGitConflict" },

					DiagnosticSignCustomError = { fg = colors.red, bg = "none" },
					DiagnosticSignCustomWarn = { fg = colors.yellow, bg = "none" },
					DiagnosticSignCustomHint = { fg = colors.aqua, bg = "none" },
					DiagnosticSignCustomInfo = { fg = colors.blue, bg = "none" },

					NeoTreeDiagnosticSignInfo = { bg = "none" },
					NeoTreeDiagnosticSignWarn = { bg = "none" },
					NeoTreeDiagnosticSignError = { bg = "none" },
					NeoTreeDiagnosticSignHint = { bg = "none" },

					NormalFloat = { bg = colors.base },

					LspInlayHint = { link = "Comment" },

					TreesitterContext = { link = "SignColumn" },
				}
			end

			--- This is a doc comment
			require("catppuccin").setup({
				transparent_background = true,
				styles = {
					comments = { "italic" },
					conditionals = {},
					loops = {},
					functions = {},
					keywords = {},
					strings = {},
					variables = {},
					numbers = {},
					booleans = {},
					properties = {},
					types = {},
					operators = {},
				},
				integrations = {
					cmp = true,
					dap = {
						enabled = true,
						enable_ui = true,
					},
					fidget = true,
					gitsigns = true,
					indent_blankline = {
						enabled = true,
						colored_indent_levels = false,
					},
					markdown = true,
					mason = true,
					native_lsp = {
						enabled = true,
					},
					neogit = false,
					neotree = true,
					notify = true,
					neotest = true,
					octo = false,
					symbols_outline = false,

					telekasten = false,
					telescope = true,
					treesitter = true,
					treesitter_context = true,
					ts_rainbow = false,
					window_picker = true,
					which_key = true,
				},
				-- this is a comment
				color_overrides = {},
				highlight_overrides = {
					latte = customHighlights,
					mocha = customHighlights,
					frappe = customHighlights,
					macchiato = customHighlights,
				},
			})

			---@diagnostic disable-next-line: inject-field
			vim.g.catppuccin_flavour = "macchiato"
			-- vim.cmd("colo catppuccin")
		end,
	},
}

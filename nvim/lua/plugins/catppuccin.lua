return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		priority = 1000,
		event = "BufWinEnter",

		config = function()
			local function customHighlights(colors)
				return {
					-- don't bold visual selection
					Visual = { style = {} },

					-- disable @lsp highlight
					["@lsp"] = {},

					Comment = { fg = colors.peach },
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

					LspInlayHint = { bg = "none" },

					TreesitterContext = { link = "SignColumn" },
				}
			end

			--- This is a doc comment
			require("catppuccin").setup({
				styles = {
					comments = { "italic" },
					conditionals = {},
				},
				integrations = {
					fidget = true,
					mason = true,
					native_lsp = {
						enabled = true,
					},
					neogit = false,
					neotest = true,

					telescope = {
						enabled = true,
					},
					which_key = true,
				},
				highlight_overrides = {
					latte = customHighlights,
					mocha = customHighlights,
					frappe = customHighlights,
					macchiato = customHighlights,
				},
			})

			vim.g.catppuccin_flavour = "macchiato"
		end,
	},
}

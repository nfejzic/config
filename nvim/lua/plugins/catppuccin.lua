return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = true,
		config = function()
			local flavor = "macchiato"

			local colors = require("catppuccin.palettes").get_palette(flavor)

			if colors == nil then
				return
			end

			--- This is a doc comment
			require("catppuccin").setup({
				transparent_background = false,
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
					barbar = true,
					bufferline = true,
					cmp = true,
					dap = {
						enabled = true,
						enable_ui = true,
					},
					dashboard = true,
					gitsigns = true,
					indent_blankline = {
						enabled = true,
						colored_indent_levels = false,
					},
					markdown = true,
					native_lsp = {
						enabled = true,
					},
					neogit = false,
					neotree = true,
					notify = true,
					octo = false,
					symbols_outline = true,

					telekasten = false,
					telescope = true,
					treesitter = true,
					ts_rainbow = false,
					which_key = true,
				},
				-- this is a comment
				custom_highlights = {
					-- disable @lsp highlight
					["@lsp"] = {},

					Comment = { fg = colors.maroon },
					["@comment.documentation"] = { fg = colors.teal },
					["@lsp.type.comment.rust"] = {},
					["@lsp.type.enumMember.rust"] = { link = "@lsp.type.enum" },
					["@mut_specifier"] = { fg = colors.yellow },
					["@ref_specifier"] = { link = "@mut_specifier" },
					["@constant.rust"] = { link = "Constant" },

					SignColumn = { fg = colors.text, bg = colors.surface0 },
					LineNr = { link = "SignColumn" },

					GitSignsAdd = { fg = colors.green, bg = colors.surface0 },
					GitSignsModified = { fg = colors.peach, bg = colors.surface0 },
					GitSignsChange = { fg = colors.yellow, bg = colors.surface0 },
					GitSignsDelete = { fg = colors.red, bg = colors.surface0 },

					NeoTreeGitAdded = { fg = colors.green },
					NeoTreeGitModified = { fg = colors.yellow },
					NeoTreeGitDeleted = { fg = colors.red },
					NeoTreeGitConflict = { fg = colors.peach, style = { "italic" } },
					NeoTreeGitUntracked = { link = "NeoTreeGitConflict" },

					DiagnosticSignInfo = { bg = colors.surface0 },
					DiagnosticSignWarn = { bg = colors.surface0 },
					DiagnosticSignError = { bg = colors.surface0 },
					DiagnosticSignHint = { bg = colors.surface0 },

					NeoTreeDiagnosticSignInfo = { bg = "none" },
					NeoTreeDiagnosticSignWarn = { bg = "none" },
					NeoTreeDiagnosticSignError = { bg = "none" },
					NeoTreeDiagnosticSignHint = { bg = "none" },

					NormalFloat = { bg = colors.base },

					LspInlayHint = { link = "Comment" },

					TreesitterContext = { link = "SignColumn" },
				},
				color_overrides = {},
			})

			---@diagnostic disable-next-line: inject-field
			vim.g.catppuccin_flavour = flavor
			-- vim.cmd("colo catppuccin")
		end,
	},
}

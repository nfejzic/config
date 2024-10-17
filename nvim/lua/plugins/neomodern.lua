return {
	{
		"cdmill/neomodern.nvim",
		lazy = false,

		config = function()
			require("neomodern").setup({
				-- Main options --
				style = "iceclimber", -- choose between 'iceclimber', 'coffeecat', 'darkforest', 'roseprime', 'daylight'
				toggle_style_key = nil,
				-- toggle_style_list = M.styles_list,
				transparent = false, -- don't set background
				term_colors = true, -- if true enable the terminal
				colored_docstrings = true, -- if true, docstrings will be highlighted like strings, otherwise they will be highlighted like comments
				colored_brackets = true, -- if false, brackets will be highlighted similar to default fg color
				plain_float = false, -- don't set background of floating windows. recommended for when using floating windows with borders
				show_eob = true, -- show the end-of-buffer tildes
				diagnostics = {
					darker = true, -- darker colors for diagnostic
					undercurl = true, -- use undercurl for diagnostics
					background = true, -- use background color for virtual text
				},

				-- Changing Formats --
				code_style = {
					comments = "italic",
					conditionals = "none",
					functions = "none",
					keywords = "none",
					headings = "bold", -- markdown headings
					operators = "none",
					keyword_return = "none",
					strings = "none",
					variables = "none",
				},

				-- Plugin Related --
				plugin = {
					lualine = {
						bold = true,
						plain = false, -- don't set section/component backgrounds
					},
					cmp = {
						plain = false, --don't highlight lsp-kind items
						reverse = false, -- reverse item kind highlights in cmp menu
					},
					telescope = "bordered", -- options are 'borderless' or 'bordered'
				},

				-- Custom Highlights --
				colors = {}, -- Override default colors
				highlights = {}, -- Override highlight groups
			})
			require("neomodern").load()
		end,
	},
}

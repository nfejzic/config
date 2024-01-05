return {
	-- Syntax (TreeSitter)
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-textobjects" },
			{ "nvim-treesitter/playground" },
			{
				"nvim-treesitter/nvim-treesitter-context",
				opts = {
					max_lines = 2, -- How many lines the window should span. Values <= 0 mean no limit.
					separator = nil,
				},
			},
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				modules = {},
				auto_install = false,
				sync_install = false,
				ignore_install = {},
				ensure_installed = {
					"rust",
				},
				highlight = {
					enable = true, -- false will disable the whole extension
					disable = {
						"html",
						"html5",
						-- "lua",
					},
					-- custom_captures = {
					--       ["ref_specifier"] = "rustTSRefSpecifier",
					--       ["mutable_specifier"] = "rustTSMutableSpecifier",
					-- },
				},
				playground = {
					enable = true,
					disable = { "c" },
					updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
					persist_queries = false, -- Whether the query persists across vim sessions
					keybindings = {},
				},
				incremental_selection = {
					enable = true,
					disable = { "c" },
					keymaps = {
						init_selection = "<A-o>",
						node_incremental = "<A-o>",
						scope_incremental = "grc",
						node_decremental = "<A-i>",
					},
				},
				indent = {
					enable = true,
				},
				context_commentstring = {
					enable = true,
				},
				textobjects = {
					select = {
						enable = true,
						disable = { "c" },
						lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
					move = {
						enable = true,
						disable = { "c" },
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]f"] = "@function.outer",
							["]]"] = "@class.outer",
							["]c"] = "@comment.outer",
							["]a"] = "@parameter.inner",
						},
						goto_next_end = {
							["]F"] = "@function.outer",
							["]["] = "@class.outer",
							["]C"] = "@comment.outer",
							["]A"] = "@parameter.inner",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[["] = "@class.outer",
							["[c"] = "@comment.outer",
							["[a"] = "@parameter.inner",
						},
						goto_previous_end = {
							["[F"] = "@function.outer",
							["[]"] = "@class.outer",
							["[C"] = "@comment.outer",
							["[A"] = "@parameter.inner",
						},
					},
				},
				query_linter = {
					enable = true,
					use_virtual_text = true,
					lint_events = { "BufWrite", "CursorHold" },
				},
			})
		end,
	},
}

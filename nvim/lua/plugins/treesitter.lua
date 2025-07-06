return {
	-- Syntax (TreeSitter)
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		branch = "main",

		-- NOTE: this plugin does not support lazy loading!
		lazy = false,

		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-textobjects",
				branch = "main",
			},
			{
				"nvim-treesitter/nvim-treesitter-context",
				opts = {
					max_lines = 2, -- How many lines the window should span. Values <= 0 mean no limit.
					separator = nil,
				},
			},
		},


		config = function()
			require('nvim-treesitter').install({
				-- languages
				"rust", "lua", "fish", "c", "cpp", "typescript", "javascript", "tsx", "jsx", "markdown",
				-- git
				"gitcommit", "gitignore", "gitattribute", "git_rebase", "git_config",
			})

			require("nvim-treesitter-textobjects").setup({
				select = {
					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,
					-- You can choose the select mode (default is charwise 'v')
					--
					-- Can also be a function which gets passed a table with the keys
					-- * query_string: eg '@function.inner'
					-- * method: eg 'v' or 'o'
					-- and should return the mode ('v', 'V', or '<c-v>') or a table
					-- mapping query_strings to modes.
					selection_modes = {
						['@parameter.outer'] = 'v', -- charwise
						['@function.outer'] = 'V', -- linewise
						['@class.outer'] = '<c-v>', -- blockwise
					},
					-- If you set this to `true` (default is `false`) then any textobject is
					-- extended to include preceding or succeeding whitespace. Succeeding
					-- whitespace has priority in order to act similarly to eg the built-in
					-- `ap`.
					--
					-- Can also be a function which gets passed a table with the keys
					-- * query_string: eg '@function.inner'
					-- * selection_mode: eg 'v'
					-- and should return true of false
					include_surrounding_whitespace = false,
				},
			})

			local parsersInstalled = require("nvim-treesitter.config").get_installed('parsers')
			for _, parser in pairs(parsersInstalled) do
				local filetypes = vim.treesitter.language.get_filetypes(parser)
				vim.api.nvim_create_autocmd({ "FileType" }, {
					pattern = filetypes,
					callback = function()
						vim.treesitter.start()
					end,
				})
			end

			local select = require("nvim-treesitter-textobjects.select")
			local move = require("nvim-treesitter-textobjects.move")

			-- You can use the capture groups defined in `textobjects.scm`
			vim.keymap.set({ "x", "o" }, "af", function()
				select.select_textobject("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "if", function()
				select.select_textobject("@function.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ac", function()
				select.select_textobject("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ic", function()
				select.select_textobject("@class.inner", "textobjects")
			end)
			-- You can also use captures from other query groups like `locals.scm`
			vim.keymap.set({ "x", "o" }, "as", function()
				select.select_textobject("@local.scope", "locals")
			end)

			vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end)
			vim.keymap.set({ "n", "x", "o" }, "]]", function() move.goto_next_start("@class.outer", "textobjects") end)
			vim.keymap.set({ "n", "x", "o" }, "]c", function() move.goto_next_start("@comment.outer", "textobjects") end)
			vim.keymap.set({ "n", "x", "o" }, "]a",
				function() move.goto_next_start("@parameter.inner", "textobjects") end)

			vim.keymap.set({ "n", "x", "o" }, "]F", function() move.goto_next_end("@function.outer", "textobjects") end)
			vim.keymap.set({ "n", "x", "o" }, "][", function() move.goto_next_end("@class.outer", "textobjects") end)
			vim.keymap.set({ "n", "x", "o" }, "]C", function() move.goto_next_end("@comment.outer", "textobjects") end)
			vim.keymap.set({ "n", "x", "o" }, "]A", function() move.goto_next_end("@parameter.inner", "textobjects") end)

			vim.keymap.set({ "n", "x", "o" }, "[f",
				function() move.goto_previous_start("@function.outer", "textobjects") end)
			vim.keymap.set({ "n", "x", "o" }, "[[",
				function() move.goto_previous_start("@class.outer", "textobjects") end)
			vim.keymap.set({ "n", "x", "o" }, "[c",
				function() move.goto_previous_start("@comment.outer", "textobjects") end)
			vim.keymap.set({ "n", "x", "o" }, "[a",
				function() move.goto_previous_start("@parameter.inner", "textobjects") end)

			vim.keymap.set({ "n", "x", "o" }, "[F",
				function() move.goto_previous_end("@function.outer", "textobjects") end)
			vim.keymap.set({ "n", "x", "o" }, "[]", function() move.goto_previous_end("@class.outer", "textobjects") end)
			vim.keymap.set({ "n", "x", "o" }, "[C",
				function() move.goto_previous_end("@comment.outer", "textobjects") end)
			vim.keymap.set({ "n", "x", "o" }, "[A",
				function() move.goto_previous_end("@parameter.inner", "textobjects") end)

			-- require("nvim-treesitter.configs").setup({
			-- 	modules = {},
			-- 	auto_install = false,
			-- 	sync_install = false,
			-- 	ignore_install = {},
			-- 	ensure_installed = {
			-- 		"rust",
			-- 	},
			-- 	highlight = {
			-- 		enable = true, -- false will disable the whole extension
			-- 		disable = function(lang, bufnr)
			-- 			local is_big_c = lang == "c" and vim.api.nvim_buf_line_count(bufnr) > 5000
			--
			-- 			return is_big_c
			-- 		end,
			-- 	},
			-- 	playground = {
			-- 		enable = false,
			-- 		updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
			-- 		persist_queries = false, -- Whether the query persists across vim sessions
			-- 		keybindings = {},
			-- 	},
			-- 	incremental_selection = {
			-- 		enable = true,
			-- 		keymaps = {
			-- 			init_selection = "<A-o>",
			-- 			node_incremental = "<A-o>",
			-- 			scope_incremental = "grc",
			-- 			node_decremental = "<A-i>",
			-- 		},
			-- 	},
			-- 	indent = {
			-- 		-- this does not seem to be working good, so let's disable it...
			-- 		enable = false,
			-- 	},
			--
			-- 	textobjects = {
			-- 		select = {
			-- 			enable = true,
			-- 			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			-- 			keymaps = {
			-- 				-- You can use the capture groups defined in textobjects.scm
			-- 				["af"] = "@function.outer",
			-- 				["if"] = "@function.inner",
			-- 				["ac"] = "@class.outer",
			-- 				["ic"] = "@class.inner",
			-- 			},
			-- 		},
			-- 		move = {
			-- 			enable = true,
			-- 			set_jumps = true, -- whether to set jumps in the jumplist
			-- 			goto_next_start = {
			-- 				["]f"] = "@function.outer",
			-- 				["]]"] = "@class.outer",
			-- 				["]c"] = "@comment.outer",
			-- 				["]a"] = "@parameter.inner",
			-- 			},
			-- 			goto_next_end = {
			-- 				["]F"] = "@function.outer",
			-- 				["]["] = "@class.outer",
			-- 				["]C"] = "@comment.outer",
			-- 				["]A"] = "@parameter.inner",
			-- 			},
			-- 			goto_previous_start = {
			-- 				["[f"] = "@function.outer",
			-- 				["[["] = "@class.outer",
			-- 				["[c"] = "@comment.outer",
			-- 				["[a"] = "@parameter.inner",
			-- 			},
			-- 			goto_previous_end = {
			-- 				["[F"] = "@function.outer",
			-- 				["[]"] = "@class.outer",
			-- 				["[C"] = "@comment.outer",
			-- 				["[A"] = "@parameter.inner",
			-- 			},
			-- 		},
			-- 	},
			-- 	query_linter = {
			-- 		enable = true,
			-- 		use_virtual_text = true,
			-- 		lint_events = { "BufWrite", "CursorHold" },
			-- 	},
			-- })
		end,
	},
}

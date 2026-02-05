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
				config = function()
					local ctx = require("treesitter-context")
					ctx.setup({
						max_lines = 2, -- How many lines the window should span. Values <= 0 mean no limit.
						multiwindow = false, -- Enable multiwindow support.
						separator = nil,
					})

					local function only()
						local cw = vim.api.nvim_get_current_win()
						vim
							.iter(vim.api.nvim_tabpage_list_wins(0))
							:filter(
								function(w) return w ~= cw and vim.api.nvim_win_get_config(w).focusable and true or false end
							)
							:each(function(w) pcall(vim.api.nvim_win_close, w, true) end)
					end

					require("user.keymaps").set_keys({
						{ "n", "<C-W>o", only, "Close all other non-floating windows except for the focused one" },
					})
				end,
				lazy = true,
			},
		},

		config = function()
			require('nvim-treesitter').install({
				-- languages
				"rust", "lua", "fish", "c", "cpp", "typescript", "javascript", "tsx", "jsx", "markdown",
				"toml", "yaml", "json", "nix",
				-- git
				"gitcommit", "gitignore", "gitattributes", "git_rebase", "git_config",

				-- neovim query langauges
				"scheme", "query",
			})

			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
					selection_modes = {
						['@parameter.outer'] = 'v', -- charwise
						['@function.outer'] = 'V', -- linewise
						['@class.outer'] = '<c-v>', -- blockwise
					},
					include_surrounding_whitespace = false,
				},
			})

			local parsersInstalled = require("nvim-treesitter.config").get_installed('parsers')
			for _, parser in pairs(parsersInstalled) do
				local filetypes = vim.treesitter.language.get_filetypes(parser)
				vim.api.nvim_create_autocmd({ "FileType" }, {
					pattern = filetypes,
					callback = function(_)
						vim.treesitter.start()
						vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
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
		end,
	},
}

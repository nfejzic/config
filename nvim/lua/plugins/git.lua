return {
	-- git signs in gutter
	{
		"lewis6991/gitsigns.nvim",

		lazy = true,
		event = "VeryLazy",

		config = function()
			local gs = require("gitsigns")
			gs.setup({
				signs = {},
				numhl = false,
				current_line_blame = false,
				preview_config = {
					border = "rounded",
				},
			})

			require("user.keymaps").set_keys({
				{ "n", "]g",         function() gs.nav_hunk('next') end, "Next git hunk" },
				{ "n", "[g",         function() gs.nav_hunk('prev') end, "Previous git hunk" },
				{ "n", "<leader>gb", gs.blame_line,                      "Blame current line" },
				{ "n", "<leader>gB", function()
					gs.blame_line({ full = true })
				end, "Blame current line with full commit message and hunk preview" },
				{ "n",          "<leader>gj", function() gs.nav_hunk('next') end, "Next hunk" },
				{ "n",          "<leader>gk", function() gs.nav_hunk('prev') end, "Previous hunk" },
				{ "n",          "<leader>gp", gs.preview_hunk,                    "Preview hunk" },
				{ "n",          "<leader>gP", gs.preview_hunk_inline,             "Preview hunk inline" },
				{ { "n", "v" }, "<leader>gs", gs.stage_hunk,                      "Stage hunk" },
				{ { "n", "v" }, "<leader>gu", gs.stage_hunk,                      "Undo stage hunk" },
				{ "n",          "<leader>gr", gs.reset_hunk,                      "Reset hunk" },
				{ "n",          "<leader>gd", gs.diffthis,                        "Diff this" },
				{ "n",          "<leader>gq", gs.setqflist,                       "Show changes in quickfix list" },
				{ "n",          "<leader>gl", "<CMD>Git log<CR>",                 "Show changes in quickfix list" },
			})
		end,
	},

	{
		"tpope/vim-fugitive",
		lazy = true,
		cmd = "Git",

		config = function()
			---@diagnostic disable-next-line: inject-field
			vim.g.fugitive_dynamic_colors = 1
		end,
	},
}

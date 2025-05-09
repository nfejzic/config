return {
	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		enabled = false,
		lazy = true,
		event = { "VeryLazy" },
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{
				"isak102/telescope-git-file-history.nvim",
				dependencies = { "tpope/vim-fugitive" },
			},
			{ "folke/neoconf.nvim" },
		},

		config = function()
			local neoconf = require("neoconf")

			local file_ignore_patterns = {
				"node_modules",
			}

			local neoconf_ignore_patterns = neoconf.get("telescope.ignore")

			if neoconf_ignore_patterns then
				for _, pattern in ipairs(neoconf_ignore_patterns) do
					table.insert(file_ignore_patterns, pattern)
				end
			end

			require("telescope").setup({
				defaults = {
					file_ignore_patterns,
					layout_strategy = "vertical",
					layout_config = {
						vertical = {
							preview_cutoff = 25,
						},
					},
					mappings = {
						n = {
							["dd"] = require("telescope.actions").delete_buffer,
						},
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_cursor(),
					},
				},
			})

			-- Use Telescope for LSP Code Actions
			require("telescope").load_extension("ui-select")

			-- Enable telescope fzf native
			require("telescope").load_extension("fzf")

			-- Enable extension for browsing through git history of a file
			require("telescope").load_extension("git_file_history")

			local telescope = require("telescope")
			local t_builtin = require("telescope.builtin")

			local function openTodos()
				local expr =
				"(TODO|FIXME|BUG|NOTE|HACK|XXX|IDEA|REVIEW|NB|BUG|REFACTOR|OPTIMIZE|WARNING|DEBUG|INFO|DONE|QUESTION|COMBAK|TEMP)(\\(.*\\))?:"

				t_builtin.live_grep({ default_text = expr, initial_mode = "normal" })
			end

			vim.api.nvim_create_user_command("TodoTelescope", openTodos, {})

			require("user.keymaps").telescope_keymaps(telescope, t_builtin)
		end,
	},
}

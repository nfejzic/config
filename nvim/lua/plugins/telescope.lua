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
			{ "folke/neoconf.nvim", opts = { import = { vscode = true } } },
		},

		config = function()
			local neoconf = require("neoconf")

			local file_ignore_patterns = {
				"node_modules",
			}

			local neoconf_ignore_patterns = neoconf.get("vscode.search.exclude")

			if neoconf_ignore_patterns ~= nil then
				for pattern, is_disabled in pairs(neoconf_ignore_patterns) do
					if is_disabled then
						table.insert(file_ignore_patterns, pattern)
					end
				end
			end

			require('user.utils').print_table(file_ignore_patterns)

			require("telescope").setup({
				defaults = {
					file_ignore_patterns = file_ignore_patterns,
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

			require("user.keymaps").set_keys({
				{ "n", "<leader>ff", function()
					-- t_builtin.find_files({ find_command = { "rg", "--files", "--follow", "--ignore-file", ".gitignore" } })
					t_builtin.find_files()
				end, "Find file" },

				-- Ctrl-P make it be the same
				{ "n", "<C-p>", function()
					t_builtin.find_files()
				end, "Find file (in git repository)" },

				{ "n", "<leader>fa", function()
					t_builtin.find_files({ find_command = { "rg", "--files", "--hidden", "--follow", "--no-ignore" } })
				end, "Find all files, including hidden" },

				{ "n", "<leader>fd", "<cmd>TodoTelescope<CR>", "Todo / Fixme etc" },
				{ "n", "<leader>fg", t_builtin.git_status,     "git - modified files" },
				{ "n", "<leader>;",  t_builtin.buffers,        "Telescope search buffers" },

				{
					"n",
					"<leader>gh",
					telescope.extensions.git_file_history.git_file_history,
					"Browse through git history of current file" }
				,

				{ "n",          "<leader>b",  t_builtin.buffers,     "Telescope search buffers" },

				-- Search menu for which-key
				{ "n",          "<leader>s",  "",                    "Search" },
				{ { "n", "v" }, "<leader>sd", t_builtin.grep_string, "Grep string" },
				{ "n",          "<leader>sl", t_builtin.live_grep,   "Live grep string" },
				{ "n", "<leader>sL", function()
					t_builtin.live_grep({
						additional_args = function()
							return { "--case-sensitive" }
						end,
					})
				end, "Live grep string, case sensitive" },

				{ "n", "<leader>sg", function()
					t_builtin.live_grep({
						additional_args = function()
							return { "--hidden" }
						end,
					})
				end, "Live grep string, including hidden" },

				{ "n", "<leader>ss", function()
					t_builtin.current_buffer_fuzzy_find({ find_command = "rg" })
				end, "Fuzzy search in buffer" },
			})
		end,
	},
}

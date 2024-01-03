return {
	-- Telescope
	{
		"nvim-telescope/telescope.nvim",
		lazy = false,
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			{ "nvim-telescope/telescope-ui-select.nvim" },
		},

		config = function()
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = {
						"node_modules",
					},
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

			-- Add extension to list projects
			require("telescope").load_extension("projects")

			-- Enable telescope fzf native
			require("telescope").load_extension("fzf")

			-- NOTE: Currently (on neovim nightly) there's a problem with telescope where
			-- fin_files opens the file in insert mode. This is a workaround for that
			-- problem
			vim.api.nvim_create_autocmd("WinLeave", {
				callback = function()
					-- Prevent entering buffers in insert mode.
					if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
						vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
					end
				end,
			})

			local telescope = require("telescope")
			local t_builtin = require("telescope.builtin")

			local function openTodos()
				local expr =
					"(TODO|FIXME|BUG|NOTE|HACK|XXX|IDEA|REVIEW|NB|BUG|REFACTOR|OPTIMIZE|WARNING|DEBUG|INFO|DONE|QUESTION|COMBAK|TEMP)(\\(.*\\))?:"

				t_builtin.live_grep({ default_text = expr, initial_mode = "normal" })
			end

			vim.api.nvim_create_user_command("TodoTelescope", function()
				openTodos()
			end, {})

			require("user.keymaps").telescope_keymaps(telescope, t_builtin)
		end,
	},
}

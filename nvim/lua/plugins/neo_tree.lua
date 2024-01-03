return {
	-- nice file tree
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		lazy = false,
		cmd = "Neotree",
		keys = function()
			return require("user.keymaps").neo_tree_trigger_keys
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			{
				"s1n7ax/nvim-window-picker",
				version = "v2.*",

				opts = {
					autoselect_one = true,
					hint = "floating-big-letter",
					-- include_current = true,
					filter_rules = {
						include_current_win = false,
						-- filter using buffer options
						bo = {
							-- if the file type is one of following, the window will be ignored
							filetype = { "neo-tree", "neo-tree-popup", "notify" },

							-- if the buffer type is one of following, the window will be ignored
							buftype = { "terminal", "quickfix" },
						},
					},
				},
			},
		},
		config = function()
			local neo_tree = require("neo-tree")
			neo_tree.setup({
				popup_border_style = "rounded", -- "double", "none", "rounded", "shadow", "single" or "solid"
				use_default_mappings = false,
				use_popups_for_input = true, -- If false, inputs will use vim.ui.input() instead of custom floats.
				enable_normal_mode_for_inputs = true,
				source_selector = {
					winbar = true, -- toggle to show selector on winbar
				},
				window = {
					mappings = {
						-- NOTE: disabled as it conflicts with which-key.nvim
						-- ["<space>"] = {
						--     "toggle_node",
						--     nowait = true, -- disable `nowait` if you have existing combos starting with this char that you want to use
						-- },

						["<2-LeftMouse>"] = "open",
						["<cr>"] = "open",
						["<esc>"] = "revert_preview",
						["P"] = { "toggle_preview", config = { use_float = true } },
						["l"] = "focus_preview",
						["S"] = "open_split",
						["s"] = "open_vsplit",
						["t"] = "open_tabnew",
						["w"] = "open_with_window_picker",
						["C"] = "close_node",
						["z"] = "close_all_nodes",
						["a"] = {
							"add",
							-- this command supports BASH style brace expansion ("x{a,b,c}" -> xa,xb,xc). see `:h neo-tree-file-actions` for details
							-- some commands may take optional config options, see `:h neo-tree-mappings` for details
							config = {
								show_path = "none", -- "none", "relative", "absolute"
							},
						},
						["A"] = "add_directory", -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
						["d"] = "delete",
						["r"] = "rename",
						["y"] = "copy_to_clipboard",
						["x"] = "cut_to_clipboard",
						["p"] = "paste_from_clipboard",
						["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
						["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
						["q"] = "close_window",
						["R"] = "refresh",
						["?"] = "show_help",
						["<"] = "prev_source",
						[">"] = "next_source",
					},
				},
				git_status = {
					window = {
						position = "float",
						mappings = {
							["A"] = "git_add_all",
							["gu"] = "git_unstage_file",
							["ga"] = "git_add_file",
							["gr"] = "git_revert_file",
							["gc"] = "git_commit",
							["gp"] = "git_push",
							["gg"] = "git_commit_and_push",
						},
					},
				},
				filesystem = {
					follow_current_file = {
						enabled = false, -- This will find and focus the file in the active buffer every time
					},
					hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
					use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
					window = {
						mappings = {
							["<bs>"] = "navigate_up",
							["."] = "set_root",
							["H"] = "toggle_hidden",
							["/"] = "fuzzy_finder",
							["D"] = "fuzzy_finder_directory",
							["f"] = "filter_on_submit",
							["<c-x>"] = "clear_filter",
							["[g"] = "prev_git_modified",
							["]g"] = "next_git_modified",
						},
					},
				},
				buffers = {
					bind_to_cwd = true,

					-- This will find and focus the file in the active buffer every time
					-- the current file is changed while the tree is open.
					follow_current_file = {
						enabled = true,
					},
					mapping_options = {
						noremap = true,
						nowait = true,
					},
					window = {
						mappings = {
							["bd"] = "buffer_delete",
							["<bs>"] = "navigate_up",
							["."] = "set_root",
						},
					},
				},
			})

			---@diagnostic disable-next-line: inject-field
			vim.g.loaded_netrwPlugin = 1 -- use neotree instead
			vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

			require("user.keymaps").neo_tree()
		end,
	},
}

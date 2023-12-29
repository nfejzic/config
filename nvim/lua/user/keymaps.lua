local wk = require("which-key")

wk.setup({
	disable = {
		filetypes = {
			"TelescopePrompt",
			"neo-tree",
			"NeoTree",
		},
		buftypes = {
			"nofile",
		},
	},
})

local M = {}

M.general = function()
	wk.register({
		["<leader>"] = {
			f = {
				name = "Find/File",
				f = {
					"<cmd>lua require('telescope.builtin').find_files({ find_command = { 'rg', '--files', '--follow', '--ignore-file', '.gitignore' } })<CR>",
					"Find file",
				},
				F = {
					function()
						require("telescope.builtin").find_files({
							find_command = {
								"rg",
								"--files",
								"--hidden",
								"--follow",
								"--ignore-file",
								".gitignore",
							},
						})
					end,
					"Find file",
				},
				t = { "<cmd>Neotree toggle<CR>", "Open File Tree" },
				r = { "<cmd>Neotree reveal<CR>", "Reveal current file in the sidebar" },
				p = { "<cmd>Telescope projects<CR>", "Recent projects" },
				d = { "<cmd>TodoTelescope<CR>", "Todo / Fixme etc." },
				g = { "<cmd>Telescope git_status<CR>", "git - modified files" },
			},
			b = { "<cmd>lua require('telescope.builtin').buffers()<CR>", "Telescope search buffers" },
			B = {
				name = "Buffer",
				c = { "<cmd>BufferClose<CR>", "Close buffer" },
				C = { "<cmd>BufferClose!<CR>", "Close buffer ignore changes" },
				b = { require("telescope.builtin").buffers, "Telescope search buffers" },
			},
			s = {
				name = "Search",
				d = { require("telescope.builtin").grep_string, "Grep string" },
				l = { require("telescope.builtin").live_grep, "Live grep string" },
				L = {
					function()
						require("telescope.builtin").live_grep({
							additional_args = function()
								return { "--case-sensitive" }
							end,
						})
					end,
					"Live grep string",
				},
				g = {
					function()
						require("telescope.builtin").live_grep({
							additional_args = function()
								return { "--hidden" }
							end,
						})
					end,
					"Live grep string",
				},
				s = {
					function()
						require("telescope.builtin").current_buffer_fuzzy_find({ find_command = "rg" })
					end,
					"Fuzzy search in buffer",
				},
			},
			k = {
				name = "Collapse / Fold",
				k = { "<cmd>foldclose<CR>", "Fold" },
				K = { "<cmd>foldclose<CR>", "Fold all" },
				o = { "<cmd>foldopen<CR>", "Unfold (open fold)" },
				O = { "zR", "Unfold all (open fold)" },
			},
			["<space>"] = { "<C-^>", "Switch to previous buffer" },
			e = "Lsp Diagnostics popup",
			["?"] = { "<cmd>lua require('telescope.builtin').oldfiles()<CR>", "Telescope - Old Files" },
		},
		-- ['<C-l>'] = { "<cmd>BufferNext<CR>", "Go to next buffer" },
		-- ['<C-h>'] = { "<cmd>BufferPrevious<CR>", "Go to previous buffer" },
		["]"] = {
			q = { "<cmd>cn<CR>", "Next quickfix entry" },
			b = { "<cmd>bnext<CR>", "Go to next buffer" },
		},
		["["] = {
			q = { "<cmd>cp<CR>", "Previous quickfix entry" },
			b = { "<cmd>bprevious<CR>", "Go to previous buffer" },
		},
	})
end

M.dap = function()
	local function toggle_dap_sidebar(opt)
		opt = opt or "scopes"

		local widgets = require("dap.ui.widgets")
		local sidebar

		if opt == "frames" then
			sidebar = widgets.sidebar(widgets.frames)
		else
			sidebar = widgets.sidebar(widgets.scopes)
		end

		return sidebar.toggle
	end

	wk.register({
		["<leader>"] = {
			-- Debug:
			d = {
				name = "Debug / DAP",

				-- Breakpoints
				a = { require("dap").clear_breakpoints, "Remove all breakpoints" },
				p = { require("dap").toggle_breakpoint, "Toggle breakpoint" },

				-- Stepping through debug
				c = { require("dap").continue, "Debug Continue" },
				i = { require("dap").step_into, "Debug Step Into" },
				o = { require("dap").step_out, "Debug Step Out" },
				j = { require("dap").step_over, "Debug Step Over" },
				k = { require("dap").step_back, "Debug Step Back" },

				-- REPL toggle
				r = { require("dap").repl.toggle, "Debug Toggle REPL" },

				-- DAP Widgets (Sidebars)
				h = { require("dap.ui.widgets").hover, "Value under cursor in floating window" },
				s = { toggle_dap_sidebar("scopes"), "Scopes" },
				f = { toggle_dap_sidebar("frames"), "Frames" },
				u = { require("dapui").toggle, "Toggle DAP UI" },
			},
		},
	})
end

M.gitsigns = function(gs)
	wk.register({
		["]"] = {
			g = { "<cmd>Gitsigns next_hunk<CR>", "Next git hunk" },
		},
		["["] = {
			g = { "<cmd>Gitsigns prev_hunk<CR>", "Previous git hunk" },
		},
		["<leader>"] = {
			g = {
				name = "Git",
				b = { "<cmd>Gitsigns blame_line<CR>", "Blame current line" },
				B = {
					function()
						gs.blame_line({ full = true })
					end,
					"Blame current line with full commit message and hunk preview",
				},
				j = { "<cmd>Gitsigns next_hunk<CR>", "Next hunk" },
				k = { "<cmd>Gitsigns prev_hunk<CR>", "Previous hunk" },
				p = { "<cmd>Gitsigns preview_hunk<CR>", "Preview hunk" },
				P = { "<cmd>Gitsigns preview_hunk_inline<CR>", "Preview hunk inline" },
				s = { "<cmd>Gitsigns stage_hunk<CR>", "Stage hunk" },
				u = { "<cmd>Gitsigns undo_stage_hunk<CR>", "Undo stage hunk" },
				r = { "<cmd>Gitsigns reset_hunk<CR>", "Reset hunk" },
				d = { "<cmd>Gitsigns diffthis<CR>", "Diff this" },
				q = { "<cmd>Gitsigns setqflist<CR>", "Show changes in quickfix list" },
			},
		},
	})
end

return M

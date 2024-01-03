local M = {}

M.telescope_keymaps = function(telescope, t_builtin)
	vim.keymap.set("n", "<leader>ff", function()
		t_builtin.find_files({ find_command = { "rg", "--files", "--follow", "--ignore-file", ".gitignore" } })
	end, { desc = "Find file" })

	vim.keymap.set("n", "<leader>fF", function()
		t_builtin.find_files({ find_command = { "rg", "--files", "--hidden", "--follow", "--no-ignore" } })
	end, { desc = "Find file, including hidden" })

	vim.keymap.set("n", "<leader>fp", telescope.extensions.projects.projects, { desc = "Recent projects" })
	vim.keymap.set("n", "<leader>fd", "<cmd>TodoTelescope<CR>", { desc = "Todo / Fixme etc" })
	vim.keymap.set("n", "<leader>fg", t_builtin.git_status, { desc = "git - modified files" })
	vim.keymap.set("n", "<leader>fb", t_builtin.buffers, { desc = "Telescope search buffers" })

	vim.keymap.set("n", "<leader>b", t_builtin.buffers, { desc = "Telescope search buffers" })

	-- Search menu for which-key
	vim.keymap.set("n", "<leader>s", "", { desc = "Search" })
	vim.keymap.set("n", "<leader>sd", t_builtin.grep_string, { desc = "Grep string" })
	vim.keymap.set("n", "<leader>sl", t_builtin.live_grep, { desc = "Live grep string" })
	vim.keymap.set("n", "<leader>sL", function()
		t_builtin.live_grep({
			additional_args = function()
				return { "--case-sensitive" }
			end,
		})
	end, { desc = "Live grep string, case sensitive" })
	vim.keymap.set("n", "<leader>sg", function()
		t_builtin.live_grep({
			additional_args = function()
				return { "--hidden" }
			end,
		})
	end, { desc = "Live grep string, includeing hidden" })
	vim.keymap.set("n", "<leader>ss", function()
		t_builtin.current_buffer_fuzzy_find({ find_command = "rg" })
	end, { desc = "Fuzzy search in buffer" })

	vim.keymap.set("n", "<leader>?", t_builtin.oldfiles, { desc = "Telescope - Old Files" })
end

M.neo_tree_trigger_keys = "<leader>f"
M.neo_tree = function()
	vim.keymap.set("n", "<leader>ft", "<cmd>Neotree toggle<CR>", { desc = "Open File Tree" })
	vim.keymap.set("n", "<leader>fr", "<cmd>Neotree reveal<CR>", { desc = "Reveal current file in the sidebar" })
end

M.dap_trigger_keys = "<leader>d"
M.dap = function(dap, dapui, widgets)
	local function toggle_dap_sidebar(opt)
		opt = opt or "scopes"

		local sidebar

		if opt == "frames" then
			sidebar = widgets.sidebar(widgets.frames)
		else
			sidebar = widgets.sidebar(widgets.scopes)
		end

		return sidebar.toggle
	end

	-- Breakpoints
	vim.keymap.set("n", "<leader>da", dap.clear_breakpoints, { desc = "Remove all breakpoints" })
	vim.keymap.set("n", "<leader>dp", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })

	-- Stepping
	vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug Continue" })
	vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debug Step Into" })
	vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Debug Step Out" })
	vim.keymap.set("n", "<leader>dj", dap.step_over, { desc = "Debug Step Over" })
	vim.keymap.set("n", "<leader>dk", dap.step_back, { desc = "Debug Step Back" })

	-- REPL toggle
	vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Debug Toggle REPL" })

	-- DAP Widgets (Sidebars)
	vim.keymap.set("n", "<leader>dh", widgets.hover, { desc = "Value under cursor in floating window" })
	vim.keymap.set("n", "<leader>ds", toggle_dap_sidebar("scopes"), { desc = "Scopes" })
	vim.keymap.set("n", "<leader>df", toggle_dap_sidebar("frames"), { desc = "Frames" })
	vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
end

M.gitsigns = function(gs)
	vim.keymap.set("n", "]g", gs.next_hunk, { desc = "Next git hunk" })
	vim.keymap.set("n", "[g", gs.prev_hunk, { desc = "Previous git hunk" })
	vim.keymap.set("n", "<leader>gb", gs.blame_line, { desc = "Blame current line" })
	vim.keymap.set("n", "<leader>gB", function()
		gs.blame_line({ full = true })
	end, { desc = "Blame current line with full commit message and hunk preview" })
	vim.keymap.set("n", "<leader>gj", gs.next_hunk, { desc = "Next hunk" })
	vim.keymap.set("n", "<leader>gk", gs.prev_hunk, { desc = "Previous hunk" })
	vim.keymap.set("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
	vim.keymap.set("n", "<leader>gP", gs.preview_hunk_inline, { desc = "Preview hunk inline" })
	vim.keymap.set("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
	vim.keymap.set("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
	vim.keymap.set("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
	vim.keymap.set("n", "<leader>gd", gs.diffthis, { desc = "Diff this" })
	vim.keymap.set("n", "<leader>gq", gs.setqflist, { desc = "Show changes in quickfix list" })
end

local function setup_wk_prefixes(wk)
	wk.register({
		["<leader>"] = {
			B = {
				name = "Buffer",
			},
			d = {
				name = "Debug / DAP",
			},
			f = {
				name = "Find/File",
			},
			g = {
				name = "Git",
			},
			k = {
				name = "Collapse / Fold",
			},
			l = {
				name = "LSP",
			},
			s = {
				name = "Search",
			},
		},
	})
end

M.general = function()
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

	setup_wk_prefixes(wk)

	-- Buffer
	vim.keymap.set("n", "<leader>Bc", "<cmd>BufferClose<CR>", { desc = "Close buffer" })
	vim.keymap.set("n", "<leader>BC", "<cmd>BufferClose!<CR>", { desc = "Close buffer, ignore changes" })
	vim.keymap.set("n", "<leader><space>", "<C-^>", { desc = "Switch to previous buffer" })
	vim.keymap.set("n", "]b", "<cmd>bnext<CR>", { desc = "Go to next buffer" })
	vim.keymap.set("n", "[b", "<cmd>bprevious<CR>", { desc = "Go to previous buffer" })

	-- Collapse / Fold
	vim.keymap.set("n", "<leader>kk", "<cmd>foldclose<CR>", { desc = "Fold" })
	vim.keymap.set("n", "<leader>kk", "<cmd>foldclose!<CR>", { desc = "Fold all" })
	vim.keymap.set("n", "<leader>ko", "<cmd>foldopen<CR>", { desc = "Unfold (open fold)" })
	vim.keymap.set("n", "<leader>kO", "zR", { desc = "Unfold all (open fold)" })

	-- Quickfix
	vim.keymap.set("n", "]q", "<cmd>cn<CR>", { desc = "Next quickfix entry" })
	vim.keymap.set("n", "[q", "<cmd>cp<CR>", { desc = "Previous quickfix entry" })
end

return M

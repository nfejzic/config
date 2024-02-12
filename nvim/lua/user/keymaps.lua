local M = {}

M.lsp = function(t_builtin, inlay_hint_supported)
	vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
	vim.keymap.set("n", "<leader>ld", t_builtin.lsp_definitions, { desc = "Go to Declaration" })

	vim.keymap.set("n", "<leader>le", vim.diagnostic.open_float, { desc = "Show diagnostics message" })
	vim.keymap.set("n", "<leader>lj", vim.diagnostic.goto_next, { desc = "Go to next LSP diagnostics problem" })
	vim.keymap.set("n", "<leader>lk", vim.diagnostic.goto_prev, { desc = "Go to previous LSP diagnostics problem" })
	vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename, { desc = "Refactor Rename" })
	vim.keymap.set("n", "<leader>lp", vim.lsp.buf.hover, { desc = "Show hover popup" })
	vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "Populate loclist with diagnostics" })

	vim.keymap.set("n", "<leader>lr", t_builtin.lsp_references, { desc = "Go to References" })
	vim.keymap.set("n", "<leader>li", t_builtin.lsp_implementations, { desc = "Implementations" })
	vim.keymap.set("n", "<leader>ls", t_builtin.lsp_document_symbols, { desc = "Document symbols" })
	vim.keymap.set("n", "<leader>lw", t_builtin.lsp_workspace_symbols, { desc = "Workspace symbols" })
	vim.keymap.set("n", "<leader>lM", t_builtin.diagnostics, { desc = "Diagnostic messages in all buffers" })
	vim.keymap.set("n", "<leader>lm", function()
		t_builtin.diagnostics({ bufnr = 0 })
	end, { desc = "Diagnostic messages in current buffer" })

	vim.keymap.set("n", "<leader>a", vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder" })
	vim.keymap.set("n", "<leader>r", vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder" })
	vim.keymap.set("n", "<leader>l", function()
		-- print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		vim.lsp.buf.list_workspace_folders()
	end, { desc = "List workspace folders" })

	vim.keymap.set({ "n", "v" }, "<leader>.", function()
		local code_actions_available = false
		local code_action_chck_grp = vim.api.nvim_create_augroup("CodeActionCheck", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
			group = code_action_chck_grp,
			callback = function()
				code_actions_available = true
			end,
		})

		-- check if code action succeeded
		vim.lsp.buf.code_action()

		if not code_actions_available then
			-- then try with codelens
			vim.lsp.codelens.run()
		end
	end, { desc = "Code actions" })

	vim.keymap.set("n", "gd", t_builtin.lsp_definitions, { desc = "Definitions" })
	vim.keymap.set("n", "gr", t_builtin.lsp_references, { desc = "References" })
	vim.keymap.set("n", "gI", t_builtin.lsp_implementations, { desc = "Implementations" })
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
	vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { desc = "Go to Type Definition" })
	vim.keymap.set("n", "gh", vim.diagnostic.open_float, { desc = "Show diagnostics message/help" })
	vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP Hover" })

	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next LSP diagnostics problem" })
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous LSP diagnostics problem" })

	if inlay_hint_supported then
		vim.keymap.set("n", "<leader>lh", "<cmd>LspToggleInlayHints<cr>", { desc = "Toggle inlay hints" })
	end
end

M.conform = function()
	vim.keymap.set("n", "<leader>lf", "<cmd>Format<cr>", { desc = "Format buffer" })
	vim.keymap.set("v", "<leader>lf", "<cmd>'<,'>Format<cr>", { desc = "Format buffer" })
end

function M.neotest(neotest)
	vim.keymap.set("n", "]t", function()
		neotest.jump.next()
	end, { desc = "Go to next test (in buffer)" })

	vim.keymap.set("n", "[t", function()
		neotest.jump.prev()
	end, { desc = "Go to next test (in buffer)" })
end

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
			w = {
				name = "Lsp Workspace",
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

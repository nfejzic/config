local M = {}

M.lsp = function(t_builtin, inlay_hint_supported)
	vim.keymap.set("n", "<leader>lD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
	vim.keymap.set("n", "<leader>ld", t_builtin.lsp_definitions, { desc = "Go to definition" })

	vim.keymap.set("n", "<leader>le", vim.diagnostic.open_float, { desc = "Show diagnostics message" })
	vim.keymap.set("n", "<leader>lj", vim.diagnostic.goto_next, { desc = "Go to next LSP diagnostics problem" })
	vim.keymap.set("n", "<leader>lk", vim.diagnostic.goto_prev, { desc = "Go to previous LSP diagnostics problem" })
	vim.keymap.set("n", "<leader>ln", vim.lsp.buf.rename, { desc = "Refactor Rename" })
	vim.keymap.set("n", "<leader>lp", vim.lsp.buf.hover, { desc = "Show hover popup" })
	vim.keymap.set("n", "<leader>ll", vim.diagnostic.setloclist, { desc = "Populate location list with diagnostics" })
	vim.keymap.set("n", "<leader>lq", vim.diagnostic.setqflist, { desc = "Populate quickfix list with diagnostics" })

	vim.keymap.set("n", "<leader>lr", t_builtin.lsp_references, { desc = "Go to References" })
	vim.keymap.set("n", "<leader>li", t_builtin.lsp_implementations, { desc = "Implementations" })
	vim.keymap.set("n", "<leader>ls", t_builtin.lsp_document_symbols, { desc = "Document symbols" })
	vim.keymap.set("n", "<leader>lw", t_builtin.lsp_workspace_symbols, { desc = "Workspace symbols" })
	vim.keymap.set("n", "<leader>lM", vim.diagnostic.setqflist, { desc = "Diagnostic messages in all buffers" })
	vim.keymap.set("n", "<leader>lm", function()
		t_builtin.diagnostics({ bufnr = 0 })
	end, { desc = "Diagnostic messages in current buffer" })

	vim.keymap.set("n", "<leader>la", vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder" })
	vim.keymap.set("n", "<leader>lr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder" })
	-- TODO: this does not work right now (and I never use it). Try it out later
	-- vim.keymap.set("n", "<leader>ll", vim.lsp.buf.list_workspace_folders, { desc = "List workspace folders" })

	local code_action_fn = function()
		local code_actions_available = false
		local code_action_chck_grp = vim.api.nvim_create_augroup("CodeActionCheck", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
			group = code_action_chck_grp,
			callback = function()
				code_actions_available = true
			end,
		})

		-- check whether code action succeeded
		vim.lsp.buf.code_action()

		if not code_actions_available then
			-- then try with codelens
			vim.lsp.codelens.run()
		end
	end

	vim.keymap.set({ "n", "v" }, "<leader>.", code_action_fn, { desc = "Code actions" })
	vim.keymap.set({ "n", "v" }, "<leader>a", code_action_fn, { desc = "Code actions" })

	vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Definitions" })
	vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "References" })
	vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { desc = "Implementations" })
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

	local function go_cmds()
		vim.api.nvim_create_user_command("GoTestDebug", function()
			require("dap-go").debug_test()
		end, {})

		vim.keymap.set("n", "<leader>dt", "GoTestDebug", { desc = "Debug test under cursor" })
	end

	if vim.bo.filetype == "go" then
		vim.api.nvim_create_user_command("GoTestDebug", function()
			require("dap-go").debug_test()
		end, {})

		vim.keymap.set("n", "<leader>dt", "GoTestDebug", { desc = "Debug test under cursor" })
	end

	vim.api.nvim_create_autocmd("BufRead", {
		pattern = "*.go",
		callback = go_cmds,
	})
end

M.neogen = function(neogen)
	vim.keymap.set(
		"n",
		"<leader>lc",
		neogen.generate,
		{ noremap = true, silent = true, desc = "Generate annotation for the current item." }
	)
end

M.telescope_keymaps = function(telescope, t_builtin)
	vim.keymap.set("n", "<leader>ff", function()
		t_builtin.find_files({ find_command = { "rg", "--files", "--follow", "--ignore-file", ".gitignore" } })
	end, { desc = "Find file" })

	-- Ctrl-P make it be the same
	vim.keymap.set("n", "<C-p>", function()
		t_builtin.find_files({ find_command = { "rg", "--files", "--follow", "--ignore-file", ".gitignore" } })
	end, { desc = "Find file (in git repository)" })

	vim.keymap.set("n", "<leader>fa", function()
		t_builtin.find_files({ find_command = { "rg", "--files", "--hidden", "--follow", "--no-ignore" } })
	end, { desc = "Find all files, including hidden" })

	vim.keymap.set("n", "<leader>fd", "<cmd>TodoTelescope<CR>", { desc = "Todo / Fixme etc" })
	vim.keymap.set("n", "<leader>fg", t_builtin.git_status, { desc = "git - modified files" })
	vim.keymap.set("n", "<leader>;", t_builtin.buffers, { desc = "Telescope search buffers" })

	vim.keymap.set(
		"n",
		"<leader>gh",
		telescope.extensions.git_file_history.git_file_history,
		{ desc = "Browse through git history of current file" }
	)

	vim.keymap.set("n", "<leader>b", t_builtin.buffers, { desc = "Telescope search buffers" })

	-- Search menu for which-key
	vim.keymap.set("n", "<leader>s", "", { desc = "Search" })
	vim.keymap.set({ "n", "v" }, "<leader>sd", t_builtin.grep_string, { desc = "Grep string" })
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
	end, { desc = "Live grep string, including hidden" })
	vim.keymap.set("n", "<leader>ss", function()
		t_builtin.current_buffer_fuzzy_find({ find_command = "rg" })
	end, { desc = "Fuzzy search in buffer" })
end

-- M.neo_tree_trigger_keys = "<leader>f"
-- M.neo_tree = function()
-- 	vim.keymap.set("n", "<leader>ft", "<cmd>Neotree toggle<CR>", { desc = "Open File Tree" })
-- 	vim.keymap.set("n", "<leader>fr", "<cmd>Neotree reveal<CR>", { desc = "Reveal current file in the sidebar" })
-- end

M.dap_trigger_keys = "<leader>d"
M.dap = function(dap, dapui)
	-- Breakpoints
	vim.keymap.set("n", "<leader>dp", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })

	-- Stepping
	vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug Continue" })
	vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debug Step Into" })
	vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Debug Step Out" })
	vim.keymap.set("n", "<leader>dj", dap.step_over, { desc = "Debug Step Over" })
	vim.keymap.set("n", "<leader>dk", dap.step_back, { desc = "Debug Step Back" })
	vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "Debug Restart" })

	-- REPL toggle
	-- vim.keymap.set("n", "<leader>dr", req_dap.repl.toggle, { desc = "Debug Toggle REPL" })

	-- DAP Widgets and UI (Sidebars)
	vim.keymap.set("n", "<space>?", function()
		dapui.eval(nil, { enter = true })
	end, { desc = "Evaluate value under the cursor in floating window." })

	vim.keymap.set("n", "<leader>du", function()
		dapui.toggle()
	end, { desc = "Toggle DAP UI" })

	-- Rust specific
	local function rust_mapping()
		local function with_args(cmd)
			return function()
				vim.ui.input({ prompt = "Args for executable: " }, function(args_for_executable)
					if type(args_for_executable) == "string" and string.len(args_for_executable) > 0 then
						-- vim.cmd("RustLsp debuggables " .. args_for_executable)
						vim.cmd(cmd .. " " .. args_for_executable)
					end
				end)
			end
		end

		vim.keymap.set("n", "<leader>dd", "<cmd>RustLsp debug<CR>", { desc = "Debug RustLsp debuggable under cursor" })
		vim.keymap.set(
			"n",
			"<leader>dD",
			with_args("RustLsp debug"),
			{ desc = "Debug RustLsp debuggable under cursor with arguments" }
		)

		vim.keymap.set("n", "<leader>da", "<CMD>RustLsp debuggables<CR>", { desc = "All RustLsp debuggables" })
		vim.keymap.set(
			"n",
			"<leader>dA",
			with_args("RustLsp debuggables"),
			{ desc = "All RustLsp debuggables with arguments" }
		)

		vim.keymap.set(
			"n",
			"<leader>ds",
			"<cmd>RustLsp! debuggables<CR>",
			{ desc = "Run same RustLsp debuggable as last time" }
		)
	end

	if vim.bo.filetype == "rust" then
		rust_mapping()
	end

	vim.api.nvim_create_autocmd("BufEnter", {
		pattern = "*.rs",
		callback = rust_mapping,
	})
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
	wk.add({
		{ "<leader>B", group = "Buffer" },
		{ "<leader>d", group = "Debug / DAP" },
		{ "<leader>f", group = "Find/File" },
		{ "<leader>g", group = "Git" },
		-- { "<leader>k", group = "Collapse / Fold" },
		{ "<leader>l", group = "LSP" },
		{ "<leader>s", group = "Search" },
		{ "<leader>w", group = "Lsp Workspace" },
	})
end

M.oil = function(oil)
	-- opens oil with current file being under the cursor
	vim.keymap.set("n", "<leader>ft", oil.open, { desc = "Open File Explorer (Oil)" })
	vim.keymap.set("n", "-", oil.open, { desc = "Open File Explorer (Oil)" })
	vim.keymap.set("n", "<leader>fr", oil.toggle_float, { desc = "Open floating file explorer (Oil)" })
end

M.general = function()
	local wk = require("which-key")

	wk.setup({
		preset = "modern",
		disable = {
			ft = {
				"TelescopePrompt",
				"neo-tree",
				"NeoTree",
			},
			bt = {
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
	-- vim.keymap.set("n", "<leader>kk", "<cmd>foldclose<CR>", { desc = "Fold" })
	-- vim.keymap.set("n", "<leader>kk", "<cmd>foldclose!<CR>", { desc = "Fold all" })
	-- vim.keymap.set("n", "<leader>ko", "<cmd>foldopen<CR>", { desc = "Unfold (open fold)" })
	-- vim.keymap.set("n", "<leader>kO", "zR", { desc = "Unfold all (open fold)" })

	local go_quickfix = function(next, list)
		return function()
			local command = "c"
			if list then
				command = "l"
			end

			if next then
				return "<cmd>" .. vim.v.count .. command .. "n<CR>"
			else
				return "<cmd>" .. vim.v.count .. command .. "p<CR>"
			end
		end
	end

	-- Quickfix
	vim.keymap.set("n", "]q", go_quickfix(true, false), { desc = "Next quickfix entry", expr = true })
	vim.keymap.set("n", "[q", go_quickfix(false, false), { desc = "Previous quickfix entry", expr = true })
	vim.keymap.set("n", "<C-j>", go_quickfix(true, false), { desc = "Next quickfix entry", expr = true })
	vim.keymap.set("n", "<C-k>", go_quickfix(false, false), { desc = "Previous quickfix entry", expr = true })

	-- Move lines using Ctrl = J|K (down|up) in visual mode
	vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv")
	vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv")
end

return M

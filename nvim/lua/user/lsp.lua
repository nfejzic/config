local M = {}

local _border = "rounded"

function M.setup_ui()
	local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

	---@type table|nil
	local diagnostic_cfg = {
		enable = true,
		virtual_text = true,
		virtual_lines = false,
		underline = true,
		float = {
			border = _border,
			source = "always",
		},
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = signs.Error,
				[vim.diagnostic.severity.WARN] = signs.Warn,
				[vim.diagnostic.severity.HINT] = signs.Hint,
				[vim.diagnostic.severity.INFO] = signs.Info,
			},
			severity_sort = true,
		},
	}

	vim.diagnostic.config(diagnostic_cfg)

	vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError" })
	vim.fn.sign_define("DapStopped", { text = "->", texthl = "DiagnosticSignInfo" })
end

local function on_attach(client, bufnr)
	require("fidget").setup({
		notification = {
			window = {
				winblend = 100,
			},
		},
	})

	local picker = require("snacks").picker
	local inlay_hint_supported = vim.lsp.inlay_hint ~= nil and client.supports_method("textDocument/inlayHint")

	if inlay_hint_supported then
		vim.api.nvim_create_user_command("LspToggleInlayHints", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), {})
		end, {})

		vim.lsp.inlay_hint.enable(false, {}) -- disable inlay hints by default
	end

	local function next_diagnostic()
		vim.diagnostic.jump({ count = 1, float = true })
	end

	local function prev_diagnostic()
		vim.diagnostic.jump({ count = -1, float = true })
	end


	local function code_action_fn()
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


	if inlay_hint_supported then
		vim.keymap.set("n", "<leader>lh", "<cmd>LspToggleInlayHints<cr>", { desc = "Toggle inlay hints" })
	end

	local keymaps = require("user.keymaps")

	-- Diagnostic keymaps
	keymaps.set_keys({
		-- When lines are on, text is off. Text on, lines off. Minimize clutter.
		{ '', 'gl', function()
			vim.diagnostic.config({
				virtual_lines = not vim.diagnostic.config().virtual_lines,
				virtual_text = not vim.diagnostic.config().virtual_text,
			})
		end, 'Toggle dia[g]nostic [l]ines' },

		{ "n", "<leader>lD", vim.lsp.buf.declaration,   "Go to Declaration" },
		{ "n", "<leader>ld", picker.lsp_definitions,    "Go to definition" },

		{ "n", "<leader>le", vim.diagnostic.open_float, "Show diagnostics message" },
		{ "n", "<leader>lj", next_diagnostic,           "Go to next LSP diagnostics problem" },
		{ "n", "<leader>lk", prev_diagnostic,           "Go to previous LSP diagnostics problem" },
		{ "n", "<leader>lp", vim.lsp.buf.hover,         "Show hover popup" },
		{ "n", "<leader>lq", vim.diagnostic.setqflist,
			"Populate quickfix list with diagnostics" },

		{ "n",          "<leader>lr", picker.lsp_references,        "Go to References" },
		{ "n",          "<leader>li", picker.lsp_implementations,   "Implementations" },
		{ "n",          "<leader>ls", picker.lsp_symbols,           "Document symbols" },
		{ "n",          "<leader>lw", picker.lsp_workspace_symbols, "Workspace symbols" },
		{ "n",          "<leader>lM", vim.diagnostic.setqflist,     "Diagnostic messages in all buffers" },
		{ "n",          "<leader>lm", picker.diagnostics_buffer,    "Diagnostic messages in current buffer" },
		{ { "n", "v" }, "<leader>.",  code_action_fn,               "Code actions" },
		{ { "n", "v" }, "<leader>a",  code_action_fn,               "Code actions" },
		{ { "n", "v" }, "<leader>ll", vim.lsp.codelens.run,         "Run Code Lens" },

		{ "n",          "gd",         vim.lsp.buf.definition,       "Definitions" },
		{ "n",          "gI",         vim.lsp.buf.implementation,   "Implementations" },
		{ "n",          "gD",         vim.lsp.buf.declaration,      "Go to Declaration" },
		{ "n",          "gt",         vim.lsp.buf.type_definition,  "Go to Type Definition" },
		{ "n",          "gh",         vim.diagnostic.open_float,    "Show diagnostics message/help" },
		{ "n",          "K",          vim.lsp.buf.hover,            "LSP Hover" },
		{ "n",          "gs",         vim.lsp.buf.signature_help,   "Show signature help" },
		{ "i",          "<C-h>",      vim.lsp.buf.signature_help,   "Show signature help" },

		{ "n",          "]d",         next_diagnostic,              "Go to next LSP diagnostics problem" },
		{ "n",          "[d",         prev_diagnostic,              "Go to previous LSP diagnostics problem" },
	})

	-- rust specific
	if vim.fn.exists(':RustLsp') then
		keymaps.set_keys({
			{ "n", "<leader>lx", "<cmd>RustLsp expandMacro<cr>",      "RustLsp expand macro" },
			{ "n", "gh",         "<cmd>RustLsp renderDiagnostic<cr>", "RustLsp render diagnostic" },
		})
	end

	vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })
	-- disable semantic highlighting
	-- client.server_capabilities.semanticTokensProvider = nil
end

--- @param servers [string, string][]
local function enable_if_installed(servers)
	for _, binary_server in pairs(servers) do
		local binary = binary_server[1]
		local server = binary_server[2]
		if vim.fn.executable(binary) == 1 then
			vim.lsp.enable(server)
		end
	end
end

function M.setup()
	local blink = require("blink.cmp")

	-- NOTE: load mason to make binaries available
	require("mason").setup()

	-- NOTE: make sure that lspconfig is loaded so that configs are setup
	require("lspconfig")

	local lsp_grp = vim.api.nvim_create_augroup("user_lsp", { clear = true })
	vim.api.nvim_create_autocmd("LspAttach", {
		group = lsp_grp,
		callback = function(ev)
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			local bufnr = ev.buf

			on_attach(client, bufnr)
		end
	})

	vim.lsp.config("*", {
		capabilities = blink.get_lsp_capabilities(),
	})

	-- NOTE: no need to enable rust_analyzer. Rustaceanvim does that automatically
	enable_if_installed({
		{ "clangd",                        "clangd" },
		{ "zls",                           "zig_lsp" },
		{ "gopls",                         "gopls" },
		{ "lua-language-server",           "lua_ls" },
		{ "fish-lsp",                      'fish_lsp' },
		{ "nil",                           "nil_ls" },
		{ "buf",                           "buf_ls" },
		{ "ruff",                          "ruff" },

		{ "just-lsp",                      "just" },
		{ "gitlab-ci-ls",                  "gitlab_ci_ls" },
		{ "taplo",                         "taplo" },

		-- webdev
		{ "vscode-eslint-language-server", "eslint" },
		{ "vscode-json-language-server",   "jsonls" },
		{ "vue-language-server",           "vue_ls" },
		{ "vtsls",                         "vtsls" },

		-- infrastructure
		{ "terraform-ls",                  "terraform-ls" },
		{ "bash-language-server",          "bashls" },
	})

	M.setup_ui()
end

return M

vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/williamboman/mason.nvim",    version = vim.version.range("2.*") },
	{ src = "https://github.com/j-hui/fidget.nvim" },
	{ src = "https://github.com/folke/lazydev.nvim" },
	{ src = "https://github.com/justinsgithub/wezterm-types" },
	{ src = "https://github.com/mrcjkb/rustaceanvim",        version = vim.version.range("^6") },

	-- completion
	{ src = "https://github.com/saghen/blink.cmp",           version = vim.version.range("1") },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
})

-- TODO: Figure out if you need typescript-tools.nvim plugin
-- {
-- 	"https://github.com/pmizio/typescript-tools.nvim",
-- 	dependencies = {
-- 		"nvim-lua/plenary.nvim",
-- 		"neovim/nvim-lspconfig"
-- 	},
--
-- 	lazy = true,
-- 	config = true,
-- 	ft = { "typescript", "typescriptreact", "tsx", "javascript", "javascriptreact", "jsx", "vue" },
-- },

require("mason").setup()

--- @param name string Name of the executable
--- @param server string Name of the LSP
local function enable_if_installed(name, server)
	if vim.fn.executable(name) == 1 then
		vim.lsp.enable(server)
	end
end

local M = {}

function M.setup_ui()
	local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

	---@type table|nil
	local diagnostic_cfg = {
		enable = true,
		virtual_text = true,
		virtual_lines = false,
		underline = true,
		-- float = {
		-- 	-- focusable = false,
		-- 	-- style = "minimal",
		-- 	source = "always",
		-- },
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = signs.Error,
				[vim.diagnostic.severity.WARN] = signs.Warn,
				[vim.diagnostic.severity.HINT] = signs.Hint,
				[vim.diagnostic.severity.INFO] = signs.Info,
			},
		}
		-- 	texthl = {
		-- 		[vim.diagnostic.severity.ERROR] = "DiagnosticDefault",
		-- 		[vim.diagnostic.severity.WARN] = "DiagnosticDefault",
		-- 		[vim.diagnostic.severity.HINT] = "DiagnosticDefault",
		-- 		[vim.diagnostic.severity.INFO] = "DiagnosticDefault",
		-- 	},
		-- 	numhl = {
		-- 		[vim.diagnostic.severity.ERROR] = "DiagnosticDefault",
		-- 		[vim.diagnostic.severity.WARN] = "DiagnosticDefault",
		-- 		[vim.diagnostic.severity.HINT] = "DiagnosticDefault",
		-- 		[vim.diagnostic.severity.INFO] = "DiagnosticDefault",
		-- 	},
		-- 	severity_sort = true,
		-- },
	}

	vim.diagnostic.config(diagnostic_cfg)

	vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError" })
	vim.fn.sign_define("DapStopped", { text = "->", texthl = "DiagnosticSignInfo" })
end

function M.gopls()
	vim.lsp.enable("gopls")
end

function M.jsonls()
	vim.lsp.enable("jsonls")
end

function M.vue_ls()
	vim.lsp.enable("vue_ls")
end

function M.override_and_get_handlers()
	local hover = vim.lsp.buf.hover
	---@diagnostic disable-next-line: duplicate-set-field
	vim.lsp.buf.hover = function(opts)
		local config = vim.tbl_deep_extend("keep", { border = "rounded" }, opts or {})
		hover(config)
	end

	local signature_help = vim.lsp.buf.signature_help
	---@diagnostic disable-next-line: duplicate-set-field
	vim.lsp.buf.signature_help = function(opts)
		local config = vim.tbl_deep_extend("keep", { border = "rounded" }, opts or {})
		signature_help(config)
	end

	local handlers = {
		["textDocument/hover"] = vim.lsp.buf.hover,
		["textDocument/signatureHelp"] = vim.lsp.buf.signature_help,
	}

	return handlers
end

function M.get_on_attach()
	return function(client, bufnr)
		require("fidget").setup({
			notification = {
				window = {
					winblend = 100,
				},
			},
		})

		-- load conform
		require("user.plugins.conform").instance()

		local picker = require("user.plugins.snacks").instance().picker

		local inlay_hint_supported = vim.lsp.inlay_hint ~= nil and client:supports_method("textDocument/inlayHint")

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

		local keymaps = require("user.core.keymaps")

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
			{ "n",          "<leader>lm", picker.diagnostics,           "Diagnostic messages in current buffer" },
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
end

function M.setup()
	local blink = require("blink.cmp")

	blink.setup({
		keymap = {
			preset = 'default',
			['<C-j>'] = { 'accept' },
			['<C-l>'] = { 'snippet_forward' },
			['<C-h>'] = { 'snippet_backward' },
			['<C-u>'] = { 'scroll_documentation_up' },
			['<C-d>'] = { 'scroll_documentation_down' },
			['<C-k>'] = { 'show' },
		},

		appearance = {
			nerd_font_variant = 'mono'
		},

		completion = {
			menu = {
				border = "rounded",
				draw = {
					treesitter = { "lsp", "path", "snippets", },
					columns = {
						{ "kind_icon", "label", "label_description", gap = 2 },
						{ "kind",      gap = 2 },
					},
				}
			},
			documentation = {
				auto_show = true,
				window = {
					border = "rounded",
				},
			},
			ghost_text = {
				enabled = true,
			},
		},

		signature = {
			enabled = true,
			window = {
				border = "rounded",
			},
		},

		sources = {
			default = { "lazydev", 'lsp', 'path', 'snippets' },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
			},

		},

		cmdline = {
			enabled = true,
			-- use 'inherit' to inherit mappings from top level `keymap` config
			keymap = {
				preset = 'inherit',
				['<C-j>'] = { 'accept' },
			},
			---@diagnostic disable-next-line: assign-type-mismatch
			sources = function()
				local type = vim.fn.getcmdtype()
				-- Search forward and backward
				if type == '/' or type == '?' then return { 'buffer' } end
				-- Commands
				if type == ':' or type == '@' then return { 'cmdline' } end
				return {}
			end,
			completion = {
				trigger = {
					show_on_blocked_trigger_characters = {},
					show_on_x_blocked_trigger_characters = {},
				},
				list = {
					selection = {
						-- When `true`, will automatically select the first item in the completion list
						preselect = true,
						-- When `true`, inserts the completion item automatically when selecting it
						auto_insert = true,
					},
				},
				-- Whether to automatically show the window when new completion items are available
				menu = { auto_show = false },
				-- Displays a preview of the selected item on the current line
				ghost_text = { enabled = true }
			}
		},

		snippets = { preset = "luasnip" },
		fuzzy = { implementation = "prefer_rust_with_warning" }
	})

	-- NOTE: make sure that lspconfig is loaded so that configs are setup
	require("lspconfig")

	vim.lsp.config("*", {
		capabilities = blink.get_lsp_capabilities(),
		handlers = M.override_and_get_handlers(),
	})

	vim.api.nvim_create_autocmd('LspAttach', {
		callback = function(ev)
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			local bufnr = ev.buf
			local on_attach = M.get_on_attach()
			on_attach(client, bufnr)
		end
	})

	-- NOTE: rust-analzer is handled by rustaceanvim. See ftplugin/rust.lua
	enable_if_installed("lua-language-server", "lua_ls")
	enable_if_installed("clangd", "clangd")
	enable_if_installed("vscode-eslint-language-server", "eslint")
	enable_if_installed("nil", "nil_ls")
	enable_if_installed("buf", "buf_ls")
	enable_if_installed("just-lsp", "just")
	enable_if_installed("fish-lsp", 'fish_lsp')
	enable_if_installed("zls", "zls")
	enable_if_installed("gopls", "gopls")
	enable_if_installed("vscode-json-language-server", "jsonls")
	enable_if_installed("vue-language-server", "vue_ls")
	enable_if_installed("gitlab-ci-ls", "gitlab_ci_ls")
	enable_if_installed("taplo", "taplo")
	enable_if_installed("ruff", "ruff")

	M.setup_ui()
end

return M

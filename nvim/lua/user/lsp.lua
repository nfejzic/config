local M = {}

local _border = "rounded"

---@return LspPicker
function M.get_telescope_picker(t_builtin)
	return {
		definitions = t_builtin.lsp_definitions,
		references = t_builtin.lsp_references,
		implementations = t_builtin.lsp_implementations,
		doc_symbols = t_builtin.document_symbols,
		workspace_symbols = t_builtin.workspace_symbols,
		buf_diagnostics = function() t_builtin.diagnostic({ buffer = 0 }) end
	}
end

---@param snacks Snacks
---@return LspPicker
function M.get_snacks_picker(snacks)
	return {
		definitions = snacks.picker.lsp_definitions,
		implementations = snacks.picker.lsp_implementations,
		references = snacks.picker.lsp_references,
		doc_symbols = snacks.picker.lsp_symbols,
		workspace_symbols = snacks.picker.lsp_workspace_symbols,
		buf_diagnostics = snacks.picker.diagnostics_buffer,
	}
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

M.setup_ui = function()
	local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

	---@type table|nil
	local diagnostic_cfg = {
		enable = true,
		virtual_text = true,
		underline = true,
		float = {
			-- focusable = false,
			-- style = "minimal",
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
			texthl = {
				[vim.diagnostic.severity.ERROR] = "DiagnosticDefault",
				[vim.diagnostic.severity.WARN] = "DiagnosticDefault",
				[vim.diagnostic.severity.HINT] = "DiagnosticDefault",
				[vim.diagnostic.severity.INFO] = "DiagnosticDefault",
			},
			numhl = {
				[vim.diagnostic.severity.ERROR] = "DiagnosticDefault",
				[vim.diagnostic.severity.WARN] = "DiagnosticDefault",
				[vim.diagnostic.severity.HINT] = "DiagnosticDefault",
				[vim.diagnostic.severity.INFO] = "DiagnosticDefault",
			},
			severity_sort = true,
		},
	}

	vim.diagnostic.config(diagnostic_cfg)

	vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError" })
	vim.fn.sign_define("DapStopped", { text = "->", texthl = "DiagnosticSignInfo" })
end

---@param get_picker fun(): LspPicker
M.get_on_attach = function(get_picker)
	return function(client, bufnr)
		local picker = get_picker()

		local inlay_hint_supported = vim.lsp.inlay_hint ~= nil and client.supports_method("textDocument/inlayHint")

		if inlay_hint_supported then
			vim.api.nvim_create_user_command("LspToggleInlayHints", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), {})
			end, {})

			vim.lsp.inlay_hint.enable(false, {}) -- disable inlay hints by default
		end

		-- Diagnostic keymaps
		require("user.keymaps").lsp(picker, inlay_hint_supported)

		vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufnr })

		-- disable semantic highlighting
		-- client.server_capabilities.semanticTokensProvider = nil
	end
end

---@param get_autocomplete_capabilities nil|fun() -> table
function M.get_global_capabilities(get_autocomplete_capabilities)
	local capabilities = vim.lsp.protocol.make_client_capabilities()

	---@diagnostic disable-next-line: need-check-nil, undefined-field
	capabilities.textDocument.completion.completionItem.snippetSupport = true

	if get_autocomplete_capabilities ~= nil then
		local completion_capabilities = get_autocomplete_capabilities()
		local glob_capabilities = vim.tbl_deep_extend("force", capabilities, completion_capabilities)

		return glob_capabilities
	end

	return capabilities
end

-- LSPs

M.clangd = function(opts, lspconfig, neoconf)
	return function()
		if neoconf.get("clangd.disable") then
			return
		end

		lspconfig.clangd.setup({
			on_attach = opts.on_attach,
			capabilities = opts.capabilities,
			handlers = opts.handlers,
			cmd = {
				"clangd",
				"--offset-encoding=utf-16",
			},
		})
	end
end

function M.rust_analyzer(opts, neoconf)
	return function()
		if neoconf.get("rust_analyzer.disable") then
			return
		end

		---@type rustaceanvim.Opts
		vim.g.rustaceanvim = {
			tools = {
				float_win_config = {
					border = "rounded",
					focusable = true,
				},
			},

			-- LSP configuration
			-- NOTE: If 'rust-analyzer' is installed through rustup, it has priority and will be used
			--       If that's not the case, then the binary installed through 'Mason' will be used
			server = {
				on_attach = opts.on_attach,
				capabilites = opts.capabilites,
				handlers = opts.handlers,
				standalone = false,
				default_settings = {
					-- rust-analyzer language server configuration
					["rust-analyzer"] = {
						hover = {
							links = {
								enable = false,
							},
						},
						checkOnSave = true,
						check = {
							enable = true,
							command = "clippy",
							features = "all",
						},
						files = {
							excludeDirs = { '.direnv' },
						},
					},
				},
			},
			-- DAP configuration
			dap = {
				autoload_configurations = true,
			},
		}
	end
end

M.zig_lsp = function(opts, lspconfig, neoconf)
	return function()
		if neoconf.get("zig_lsp.disable") then
			return
		end

		lspconfig.zls.setup({
			settings = {
				enable_build_on_save = true,
				enable_autofix = true,
			},
			on_attach = opts.on_attach,
			capabilites = opts.capabilities,
			handlers = opts.handlers,
		})
	end
end

M.go_lsp = function(opts, lspconfig, neoconf)
	return function()
		if neoconf.get("go_lsp.disable") then
			return
		end

		lspconfig.gopls.setup({
			settings = {
				gopls = {
					gofumpt = true,
					buildFlags = {
						"-tags=integration,unit",
					},
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						compositeLiteralTypes = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
				},
			},
			on_attach = opts.on_attach,
			capabilites = opts.capabilities,
			handlers = opts.handlers,
		})
	end
end

M.vtsls = function(opts, lspconfig, neoconf)
	return function()
		if neoconf.get("tsserver.disable") then
			return
		end

		if neoconf.get("ts_ls.disable") then
			return
		end

		if neoconf.get("vtsls.disable") then
			return
		end

		lspconfig.vtsls.setup({
			settings = {
				typescript = {
					inlayHints = {
						includeInlayParameterNameHints = "all",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionParameterTypeHints = true,
						includeInlayVariableTypeHints = true,
						includeInlayVariableTypeHintsWhenTypeMatchesName = false,
						includeInlayPropertyDeclarationTypeHints = true,
						includeInlayFunctionLikeReturnTypeHints = true,
						includeInlayEnumMemberValueHints = true,
					},
				},
			},
			on_attach = function(client, bufnr)
				client.server_capabilities.documentFormattingProvider = false

				local ts_utils = require("nvim-lsp-ts-utils")
				ts_utils.setup({})
				ts_utils.setup_client(client)

				opts.on_attach(client, bufnr)
			end,
			capabilites = opts.capabilites,
			handlers = opts.handlers,
		})
	end
end

M.jsonls = function(opts, lspconfig, neoconf)
	return function()
		if neoconf.get("jsonls.disable") then
			return
		end

		lspconfig.jsonls.setup({
			on_attach = function(client, bufnr)
				client.server_capabilities.document_formatting = false
				client.server_capabilities.document_range_formatting = false

				opts.on_attach(client, bufnr)
			end,
			capabilites = opts.capabilites,
			handlers = opts.handlers,
		})
	end
end

M.eslint = function(opts, lspconfig, neoconf)
	return function()
		if neoconf.get("eslint.disable") then
			return
		end

		lspconfig.eslint.setup({
			on_attach = opts.on_attach,
			capabilities = opts.capabilities,
			handlers = opts.handlers,
		})
	end
end

M.lua_ls = function(opts, lspconfig, neoconf)
	return function()
		if neoconf.get("lua_ls.disable") then
			return
		end

		lspconfig.lua_ls.setup({
			on_attach = opts.on_attach,
			capabilities = opts.capabilities,
			handlers = opts.handlers,
			settings = {
				Lua = {
					hint = {
						enable = true,
					},
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						-- let `folke/neodev` handle this
						-- library = vim.api.nvim_get_runtime_file("", true),
					},
				},
			},
		})
	end
end

function M.volar(opts, lspconfig, neoconf)
	return function()
		if neoconf.get("volar.disable") then
			return
		end

		lspconfig.volar.setup({
			filetypes = { "vue", "typescript", "javascript" },
			on_attach = opts.on_attach,
			capabilities = opts.capabilities,
			handlers = opts.handlers,
			documentFeatures = {
				documentFormatting = {},
			},
			settings = {
				typescript = {
					preferences = {
						-- "relative" | "non-relative" | "auto" | "shortest"(not sure)
						importModuleSpecifier = "non-relative",
					},
				},
			},
		})
	end
end

M.vue_ls = function(opts, lspconfig, neoconf)
	return function()
		if neoconf.get("vue_ls.disable") then
			return
		end

		lspconfig.vuels.setup({
			on_attach = opts.on_attach,
			capabilities = opts.capabilities,
			handlers = opts.handlers,
			settings = {
				vetur = {
					completion = {
						autoImport = true,
						tagCasing = "kebab",
						useScaffoldSnippets = true,
					},
					useWorkspaceDependencies = true,
					experimental = {
						templateInterpolationService = true,
					},
				},
				format = {
					enable = false,
					options = {
						useTabs = false,
						tabSize = 2,
					},
					scriptInitialIndent = false,
					styleInitialIndent = false,
					defaultFormatter = {},
				},
				validation = {
					template = false,
					script = false,
					style = false,
					templateProps = false,
					interpolation = false,
				},
			},
		})
	end
end

return M

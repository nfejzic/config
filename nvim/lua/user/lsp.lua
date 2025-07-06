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

function M.setup_ui()
	local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

	---@type table|nil
	local diagnostic_cfg = {
		enable = true,
		virtual_text = true,
		virtual_lines = false,
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
function M.get_on_attach(get_picker)
	return function(client, bufnr)
		require("fidget").setup({
			notification = {
				window = {
					winblend = 0,
				},
			},
		})

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

function M.clangd(neoconf)
	if neoconf ~= nil and neoconf.get("clangd.disable") then
		return
	end

	vim.lsp.config("clangd", {
		cmd = {
			"clangd",
			"--offset-encoding=utf-16",
		},
	})
	vim.lsp.enable("clangd")
end

function M.rust_analyzer(neoconf, opts)
	if neoconf ~= nil and neoconf.get("rust_analyzer.disable") then
		return
	end

	--- @module "rustaceanvim"
	--- @type rustaceanvim.Opts
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

	-- NOTE: no need to enable rust_analyzer. Rustaceanvim does that automatically
end

function M.lua_ls(neoconf)
	if neoconf ~= nil and neoconf.get("lua_ls.disable") then
		return
	end

	vim.lsp.config("lua_ls", {
		root_dir = function(bufnr, on_dir) on_dir(require("lazydev").find_workspace(bufnr)) end,
	})

	vim.lsp.enable("lua_ls")
end

function M.zig_lsp(neoconf)
	if neoconf ~= nil and (neoconf.get("zig_lsp.disable") or neoconf.get("zls.disable")) then
		return
	end

	vim.lsp.config("zls", {
		settings = {
			enable_build_on_save = true,
			enable_autofix = true,
		},
	})
	vim.lsp.enable("zls")
end

function M.gopls(neoconf)
	if neoconf ~= nil and neoconf.get("go_lsp.disable") then
		return
	end

	vim.lsp.config("gopls", {
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
	})

	vim.lsp.enable("gopls")
end

function M.jsonls(neoconf, on_attach)
	if neoconf ~= nil and neoconf.get("jsonls.disable") then
		return
	end

	vim.lsp.config("jsonls", {
		on_attach = function(client, bufnr)
			client.server_capabilities.document_formatting = false
			client.server_capabilities.document_range_formatting = false

			on_attach(client, bufnr)
		end,
	})
	vim.lsp.enable("jsonls")
end

function M.eslint(neoconf)
	if neoconf ~= nil and neoconf.get("eslint.disable") then
		return
	end

	vim.lsp.enable("eslint")
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

function M.vuels(neoconf)
	if neoconf ~= nil and neoconf.get("vue_ls.disable") then
		return
	end

	vim.lsp.config("vuels", {
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

	vim.lsp.enable("vuels")
end

function M.setup()
	local blink_ok, blink = pcall(require, "blink.cmp")
	local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	local _, neoconf = pcall(require, "neoconf")

	local on_attach = M.get_on_attach(function()
		local snacks_ok, snacks = pcall(require, "snacks")
		if snacks_ok then
			return M.get_snacks_picker(snacks)
		end

		-- just try to load telescope, it'll show errors if not available
		return M.get_snacks_picker(require("telescope.builtin"))
	end)

	local get_cmp_capabilities = nil

	if blink_ok then
		get_cmp_capabilities = blink.get_lsp_capabilities
	elseif cmp_ok then
		get_cmp_capabilities = cmp_nvim_lsp.default_capabilities
	end

	local global_capabilities = M.get_global_capabilities(get_cmp_capabilities)
	local handlers = M.override_and_get_handlers()

	local opts = {
		on_attach = on_attach,
		capabilities = global_capabilities,
		handlers = handlers,
	}

	local default_config = {
		log_level = vim.lsp.protocol.MessageType.Warning,
		message_level = vim.lsp.protocol.MessageType.Warning,
		settings = vim.empty_dict(),
		init_options = vim.empty_dict(),
		handlers = opts.handlers,
		autostart = true,
		capabilities = opts.capabilities,
		on_attach = opts.on_attach,
	}

	vim.lsp.config("*", {
		capabilities = opts.capabilities,
		handlers = opts.handlers,
		on_attach = opts.on_attach,
	})

	M.rust_analyzer(neoconf, opts)
	M.lua_ls(neoconf)
	M.clangd(neoconf)
	M.zig_lsp(neoconf)
	M.gopls(neoconf)
	M.jsonls(neoconf, opts.on_attach)
	M.eslint(neoconf)
	M.vuels(neoconf)

	M.setup_ui()
end

return M

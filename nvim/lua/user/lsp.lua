local M = {}

M.setup_ui = function()
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
	vim.lsp.handlers["textDocument/signatureHelp"] =
		vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

	vim.diagnostic.config({
		float = {
			-- focusable = false,
			-- style = 'minimal',
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	})

	local utils = require("user.utils")

	local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
	utils.if_nightly_else(function()
		-- API changed in neovim 0.10, currently nightly
		vim.diagnostic.config({
			enable = true,
			signs = {
				text = {
					["ERROR"] = signs.Error,
					["WARN"] = signs.Warn,
					["HINT"] = signs.Hint,
					["INFO"] = signs.Info,
				},
				texthl = {
					["ERROR"] = "DiagnosticDefault",
					["WARN"] = "DiagnosticDefault",
					["HINT"] = "DiagnosticDefault",
					["INFO"] = "DiagnosticDefault",
				},
				numhl = {
					["ERROR"] = "DiagnosticDefault",
					["WARN"] = "DiagnosticDefault",
					["HINT"] = "DiagnosticDefault",
					["INFO"] = "DiagnosticDefault",
				},
				severity_sort = true,
			},
		})
	end, function()
		-- define signs and their highlights
		for type, icon in pairs(signs) do
			local name = "DiagnosticSign" .. type
			local hl = name
			vim.fn.sign_define(name, { text = icon, texthl = hl })
		end
	end)

	-- use pretty gutter signs, fallback for plugins that don't support nightly
	-- style yet
	utils.if_nightly(function()
		for type, icon in pairs(signs) do
			local name = "DiagnosticSign" .. type
			local hl = "DiagnosticSignCustom" .. type
			vim.fn.sign_define(name, { text = icon, texthl = hl })
		end
	end)

	vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError" })
	vim.fn.sign_define("DapStopped", { text = "->", texthl = "DiagnosticSignInfo" })
end

M.get_on_attach = function(telescope_builtin)
	return function(client, bufnr)
		local inlay_hint_supported = vim.lsp.inlay_hint ~= nil and client.supports_method("textDocument/inlayHint")

		if inlay_hint_supported then
			-- TODO: inlay hints will be available in nightly. Right now, using
			-- nightly build will also work, but there are some issues with other
			-- plugins.
			vim.api.nvim_create_user_command("LspToggleInlayHints", function()
				if type(vim.lsp.inlay_hint) ~= "function" then
					vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled(0)) -- latest nightly
				else
					vim.lsp.inlay_hint(0, nil)
				end
			end, {})

			if type(vim.lsp.inlay_hint) ~= "function" then
				vim.lsp.inlay_hint.enable(0, false) -- disable inlay hints by default
			else
				vim.lsp.inlay_hint(0, false) -- disable inlay hints by default
			end
		end

		-- Diagnostic keymaps
		require("user.keymaps").lsp(telescope_builtin, inlay_hint_supported)

		vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	end
end

M.get_global_capabilities = function(cmp_nvim_lsp)
	local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
	local cmp_capabilities = cmp_nvim_lsp.default_capabilities()

	local capabilities = vim.tbl_deep_extend("force", lsp_capabilities, cmp_capabilities)

	---@diagnostic disable-next-line: need-check-nil, undefined-field
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	return capabilities
end

M.clangd = function(on_attach_fn, capabilities, lspconfig)
	return function()
		lspconfig.clangd.setup({
			cmd = { "/usr/bin/clangd" },
			on_attach = on_attach_fn,
			capabilities = capabilities,
		})
	end
end

M.rust_analyzer = function(on_attach)
	return function()
		---@diagnostic disable-next-line: inject-field
		vim.g.rustaceanvim = {
			-- Plugin configuration
			tools = {},
			-- LSP configuration
			server = {
				on_attach = function(client, bufnr)
					on_attach(client, bufnr)
				end,
				settings = {
					-- rust-analyzer language server configuration
					["rust-analyzer"] = {
						hover = {
							links = {
								enable = false,
							},
						},

						lens = { enable = true },
						inlayHints = { enable = true },
						completion = { autoimport = { enable = true } },
						rustc = { source = "discover" },
						updates = { channel = "nightly" },

						cargo = { allFeatures = true },
						checkOnSave = true,
						check = {
							enable = true,
							command = "clippy",
							features = "all",
						},
						procMacro = {
							enable = true,
						},
					},
				},
			},
			-- DAP configuration
			dap = {},
		}
	end
end

M.go_lsp = function(on_attach, capabilities, lspconfig)
	return function()
		lspconfig["gopls"].setup({
			settings = {
				gopls = {
					gofumpt = true,
				},
			},
			on_attach = on_attach,
			capabilites = capabilities,
		})
	end
end

M.tsserver = function(on_attach, lspconfig)
	return function()
		lspconfig["tsserver"].setup({
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

				on_attach(client, bufnr)
			end,
		})
	end
end

M.jsonls = function(on_attach, lspconfig)
	return function()
		lspconfig["jsonls"].setup({
			on_attach = function(client, bufnr)
				client.server_capabilities.document_formatting = false
				client.server_capabilities.document_range_formatting = false

				on_attach(client, bufnr)
			end,
		})
	end
end

M.eslint = function(on_attach, capabilities, lspconfig)
	return function()
		lspconfig["eslint"].setup({
			on_attach = on_attach,
			capabilities = capabilities,
		})
	end
end

M.lua_ls = function(on_attach, capabilities, lspconfig)
	return function()
		lspconfig.lua_ls.setup({
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				Lua = {
					hint = {
						enable = true,
					},
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
					},
				},
			},
		})
	end
end

M.vue_ls = function(on_attach, capabilities, lspconfig)
	return function()
		lspconfig["vuels"].setup({
			on_attach = on_attach,
			capabilities = capabilities,
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

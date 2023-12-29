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
	vim.fn.sign_define("DapStopped", { texthl = "DiagnosticSignInfo" })
end

M.get_on_attach = function(which_key, telescope_builtin)
	return function(client, bufnr)
		local wk = which_key

		local show_diagnostics = function()
			telescope_builtin.diagnostics({ bufnr = 0 })
		end

		-- Diagnostic keymaps
		wk.register({
			["<leader>"] = {
				l = {
					name = "LSP",
					D = { vim.lsp.buf.declaration, "Go to Declaration" },
					e = { vim.diagnostic.open_float, "Show diagnostics message" },
					-- h = { vim.lsp.buf.signature_help, 'Show signature help' },
					j = { vim.diagnostic.goto_next, "Go to next LSP diagnostics problem" },
					k = { vim.diagnostic.goto_prev, "Go to previous LSP diagnostics problem" },
					n = { vim.lsp.buf.rename, "Refactor Rename" },
					p = { vim.lsp.buf.hover, "Show hover popup" },
					q = { vim.diagnostic.setloclist, "Populate loclist with diagnostics" },
					r = { telescope_builtin.lsp_references, "Go to References" },
					s = { telescope_builtin.lsp_document_symbols, "Search document symbols" },
					w = { telescope_builtin.lsp_workspace_symbols, "Search workspace symbols" },
					M = { telescope_builtin.diagnostics, "Show diagnostics messages in all buffers" },
					d = { telescope_builtin.lsp_definitions, "Show definitions" },
					i = { telescope_builtin.lsp_implementations, "Show implementations" },
					m = { show_diagnostics, "Show diagnostics messages in current buffer" },
				},
				w = {
					name = "LSP Workspace",
					a = { vim.lsp.buf.add_workspace_folder, "Add workspace folder" },
					r = { vim.lsp.buf.remove_workspace_folder, "Remove workspace folder" },
					l = {
						function()
							print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
						end,
						"List workspace folders",
					},
				},
				["."] = { vim.lsp.buf.code_action, "Show code actions" },
			},
			g = {
				-- alternative keymaps
				d = { telescope_builtin.lsp_definitions, "Show definitions" },
				r = { telescope_builtin.lsp_references, "Go to References" },
				I = { telescope_builtin.lsp_implementations, "Show implemnetations" },
				D = { vim.lsp.buf.declaration, "Go to Declaration" },
				t = { vim.lsp.buf.type_definition, "Go to Type Definition" },
				h = { vim.diagnostic.open_float, "Show diagnostics message/help" },
			},
			K = { vim.lsp.buf.hover, "LSP Hover" },
			["]"] = { d = { vim.diagnostic.goto_next, "Go to next LSP diagnostics problem" } },
			["["] = { d = { vim.diagnostic.goto_prev, "Go to previous LSP diagnostics problem" } },
		})

		wk.register({
			["<leader>"] = {
				["."] = { vim.lsp.buf.code_action, "Show code actions" },
			},
		}, { mode = "v" })

		vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

		if vim.lsp.inlay_hint ~= nil and client.supports_method("textDocument/inlayHint") then
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

			wk.register({
				["<leader>"] = {
					l = {
						h = { "<cmd>LspToggleInlayHints<cr>", "Toggle inlay hints" },
					},
				},
			})

			if type(vim.lsp.inlay_hint) ~= "function" then
				vim.lsp.inlay_hint.enable(0, false) -- disable inlay hints by default
			else
				vim.lsp.inlay_hint(0, false) -- disable inlay hints by default
			end
		end

		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_buf_create_user_command(bufnr, "Format", function()
				require("conform").format()
			end, {})

			wk.register({
				["<leader>"] = {
					l = {
						f = { "<cmd>Format<cr>", "Format buffer" },
					},
				},
			})
		end
	end
end

M.get_global_capabilities = function(cmp_nvim_lsp)
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	return capabilities
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
			settings = {
				codeAction = {
					disableRuleComment = {
						enable = true,
						location = "separateLine",
					},
					showDocumentation = {
						enable = true,
					},
				},
				codeActionsOnSave = {
					mode = "all",
				},
				format = true,
				run = "onType",
			},
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

return {
	{
		"neovim/nvim-lspconfig",
		lazy = true,
		event = { "BufReadPost", "BufNewFile", "BufWritePre" },
		dependencies = {
			{ "folke/which-key.nvim" },
			{
				"williamboman/mason.nvim",
				opts = {
					ui = {
						border = "rounded",
					},
				},
			},

			{ "williamboman/mason-lspconfig.nvim", config = true },
			{ "folke/neodev.nvim" },
			{ "folke/neoconf.nvim" },

			-- formatters and formatting
			{
				"stevearc/conform.nvim",
				config = function()
					require("user.formatting")
				end,
			},

			-- TypeScript utilities
			{ "jose-elias-alvarez/nvim-lsp-ts-utils" },

			-- fidget spinner shows LSP loading progress
			{
				"j-hui/fidget.nvim",
				opts = {
					notification = {
						window = {
							winblend = 0,
						},
					},
				},
				lazy = true,
				event = "UIEnter",
			},

			{
				"mrcjkb/rustaceanvim",
				version = "^5",
				ft = { "rust" },
			},

			{ "hrsh7th/cmp-nvim-lsp" }, -- for auto-completion

			-- Go
			{
				"crispgm/nvim-go",
				lazy = true,
				filetype = { "go", "gomod" },
				config = function()
					require("go").setup({
						auto_format = false, -- done by conform
						auto_lint = false,
						-- linters: revive, errcheck, staticcheck, golangci-lint
						linter = "golangci-lint",
						-- linter_flags: e.g., {revive = {'-config', '/path/to/config.yml'}}
						linter_flags = {},
						-- lint_prompt_style: qf (quickfix), vt (virtual text)
						lint_prompt_style = "qf",
						test_flags = { "-v", "-tags=unit,integration" },
					})
				end,
			},

			{
				"rachartier/tiny-inline-diagnostic.nvim",
				event = "VeryLazy", -- Or `LspAttach`
				priority = 1000, -- needs to be loaded in first
				config = function()
					require('tiny-inline-diagnostic').setup({
						hi = {
							background = "None", -- Can be a highlight or a hexadecimal color (#RRGGBB)

							options = {
								-- Show the source of the diagnostic.
								show_source = true,

								-- Throttle the update of the diagnostic when moving cursor, in milliseconds.
								-- You can increase it if you have performance issues.
								-- Or set it to 0 to have better visuals.
								throttle = 20,

								-- The minimum length of the message, otherwise it will be on a new line.
								softwrap = 15,

								-- If multiple diagnostics are under the cursor, display all of them.
								multiple_diag_under_cursor = true,

								-- Enable diagnostic message on all lines.
								multilines = true,

								-- Show all diagnostics on the cursor line.
								show_all_diags_on_cursorline = true,

								-- Enable diagnostics on Insert mode. You should also se the `throttle` option to 0, as some artefacts may appear.
								enable_on_insert = false,

								overflow = {
									-- Manage the overflow of the message.
									--    - wrap: when the message is too long, it is then displayed on multiple lines.
									--    - none: the message will not be truncated.
									--    - oneline: message will be displayed entirely on one line.
									mode = "wrap",
								},

								-- Format the diagnostic message.
								-- Example:
								-- format = function(diagnostic)
								--     return diagnostic.message .. " [" .. diagnostic.source .. "]"
								-- end,
								format = nil,

								--- Enable it if you want to always have message with `after` characters length.
								break_line = {
									enabled = false,
									after = 30,
								},

								virt_texts = {
									priority = 2048,
								},

								-- Filter by severity.
								severity = {
									vim.diagnostic.severity.ERROR,
									vim.diagnostic.severity.WARN,
									vim.diagnostic.severity.INFO,
									vim.diagnostic.severity.HINT,
								},

								-- Overwrite events to attach to a buffer. You should not change it, but if the plugin
								-- does not works in your configuration, you may try to tweak it.
								overwrite_events = nil,
							},

						}
					})
				end
			}
		},

		config = function()
			local user_lsp = require("user.lsp")
			local lspconfig = require("lspconfig")
			local mason_lsp = require("mason-lspconfig")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")

			local neoconf = require("neoconf")

			neoconf.setup()
			require("neodev").setup()

			local on_attach = user_lsp.get_on_attach(function()
				return require("telescope.builtin")
			end)

			local global_capabilities = user_lsp.get_global_capabilities(cmp_nvim_lsp)
			local handlers = user_lsp.get_handlers()

			local opts = {
				on_attach = on_attach,
				capabilities = global_capabilities,
				handlers = handlers,
			}

			lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
				capabilities = global_capabilities,
			})

			-- NOTE: rustaceanvim recommends that we don't use mason, but rather
			-- install the rust-analyzer through rustup. In case rust-analyzer
			-- is not installed through, the `setup_handlers` won't be called.
			-- So let's call the setup here:
			if not require('mason-registry').is_installed('rust-analyzer') then
				local setup_rust_analyzer = user_lsp.rust_analyzer(opts, neoconf)
				setup_rust_analyzer()
			end

			mason_lsp.setup_handlers({
				-- The first entry (without a key) will be the default handler
				-- and will be called for each installed server that doesn't have
				-- a dedicated handler.
				function(server_name) -- default handler (optional)
					lspconfig[server_name].setup(opts)
				end,
				-- Next, targeted overrides for specific servers.
				["clangd"] = user_lsp.clangd(opts, lspconfig, neoconf),
				["rust_analyzer"] = user_lsp.rust_analyzer(opts, neoconf),
				["zls"] = user_lsp.zig_lsp(opts, lspconfig, neoconf),
				["gopls"] = user_lsp.go_lsp(opts, lspconfig, neoconf),
				["vtsls"] = user_lsp.vtsls(opts, lspconfig, neoconf),
				["jsonls"] = user_lsp.jsonls(opts, lspconfig, neoconf),
				["eslint"] = user_lsp.eslint(opts, lspconfig, neoconf),
				["lua_ls"] = user_lsp.lua_ls(opts, lspconfig, neoconf),
				["vuels"] = user_lsp.vue_ls(opts, lspconfig, neoconf),
				["volar"] = user_lsp.volar(opts, lspconfig, neoconf),
			})

			user_lsp.setup_ui()
		end,
	},
}

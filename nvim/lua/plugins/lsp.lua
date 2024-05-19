return {
	{
		"neovim/nvim-lspconfig",

		lazy = false,

		event = { "BufWinEnter" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall", "Mason" },

		dependencies = {
			-- for keymaps
			{ "folke/which-key.nvim" },

			{ "williamboman/mason.nvim", opts = {
				ui = {
					border = "rounded",
				},
			} },

			{
				"williamboman/mason-lspconfig.nvim",
				opts = {},
			},

			{ "folke/neodev.nvim" },

			{ "folke/neoconf.nvim" },

			-- formatters and formatting
			{
				"stevearc/conform.nvim",
				config = function()
					local conform = require("conform")
					local utils = require("user.utils")

					conform.setup({
						formatters_by_ft = {
							lua = { "stylua" },
							-- Conform will run multiple formatters sequentially
							python = { "isort", "black" },
							-- Use a sub-list to run only the first available formatter
							javascript = { { "prettierd", "prettier" } },
							typescript = { { "prettierd", "prettier" } },
							vue = { { "prettierd", "prettier" } },
							html = { { "prettierd", "prettier" } },
							markdown = { { "prettierd", "prettier" } },
							rust = {},
							c = {},
							go = { "gofumpt" },
							sql = { "sql_formatter", "sqlfmt" },
							["*"] = { "injected" },
						},
						format_on_save = function(bufnr)
							local buf_name = vim.api.nvim_buf_get_name(bufnr)

							local formatters = utils.filter_out_formatters(conform, { "injected" }, bufnr)

							local is_selfie = string.match(buf_name, "selfie")
							local is_beator = string.match(buf_name, "selfie")
							local is_monster = string.match(buf_name, "selfie")
							local is_json = string.match(buf_name, ".json")

							if is_selfie or is_beator or is_monster or is_json then
								return { timeout_ms = 500, lsp_fallback = false, formatters = formatters }
							else
								return {
									-- These options will be passed to conform.format()
									timeout_ms = 500,
									lsp_fallback = true,
									formatters = formatters,
								}
							end
						end,
					})

					vim.api.nvim_create_user_command("Format", function(args)
						local range = nil
						if args.count ~= -1 then
							local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
							range = {
								start = { args.line1, 0 },
								["end"] = { args.line2, end_line:len() },
							}
						end

						local curr_buf = vim.api.nvim_get_current_buf()
						local formatters = utils.filter_out_formatters(conform, { "injected" }, curr_buf)

						require("conform").format({
							async = true,
							lsp_fallback = true,
							range = range,
							formatters = formatters,
						})
					end, { range = true })

					vim.api.nvim_create_user_command("FormatInjected", function(args)
						local range = nil
						if args.count ~= -1 then
							local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
							range = {
								start = { args.line1, 0 },
								["end"] = { args.line2, end_line:len() },
							}
						end

						require("conform").format({
							async = true,
							lsp_fallback = true,
							range = range,
						})
					end, { range = true })

					require("user.keymaps").conform()
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
				version = "^4",
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
						-- notify: use nvim-notify
						notify = false,
						-- auto commands
						auto_format = false, -- done by conform
						auto_lint = false,
						-- linters: revive, errcheck, staticcheck, golangci-lint
						linter = "golangci-lint",
						-- linter_flags: e.g., {revive = {'-config', '/path/to/config.yml'}}
						linter_flags = {},
						-- lint_prompt_style: qf (quickfix), vt (virtual text)
						lint_prompt_style = "qf",
						-- formatter: goimports, gofmt, gofumpt, lsp
						formatter = "goimports",
						-- maintain cursor position after formatting loaded buffer
						maintain_cursor_pos = false,
						-- test flags: -count=1 will disable cache
						test_flags = { "-v", "-tags=unit,integration" },
						test_timeout = "30s",
						test_env = {},
						-- show test result with popup window
						test_popup = true,
						test_popup_auto_leave = false,
						test_popup_width = 80,
						test_popup_height = 10,
						-- test open
						test_open_cmd = "edit",
						-- struct tags
						tags_name = "json",
						tags_options = { "json=omitempty" },
						tags_transform = "snakecase",
						tags_flags = { "-skip-unexported" },
						-- quick type
						quick_type_flags = { "--just-types" },
					})
				end,
			},
		},

		config = function()
			local user_lsp = require("user.lsp")
			local lspconfig = require("lspconfig")
			local mason_lsp = require("mason-lspconfig")
			local mason_registry = require("mason-registry")
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

			-- if we decide to use rust_analyzer provided by `rustup`:
			if not mason_registry.is_installed("rust-analyzer") then
				local setup_fn = user_lsp.rust_analyzer(opts, neoconf)
				setup_fn()
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
				["tsserver"] = user_lsp.tsserver(opts, lspconfig, neoconf),
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

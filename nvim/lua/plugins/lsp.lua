return {
	{
		"neovim/nvim-lspconfig",
		lazy = false,
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

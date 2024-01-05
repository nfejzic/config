return {
	{
		"neovim/nvim-lspconfig",

		event = { "BufReadPost" },
		cmd = { "LspInfo", "LspInstall", "LspUninstall", "Mason" },
		lazy = false,

		dependencies = {
			-- for keymaps
			{ "folke/which-key.nvim" },

			{ "williamboman/mason.nvim", opts = {} },
			{
				"williamboman/mason-lspconfig.nvim",
				opts = {},
			},

			-- formatters and formatting
			{
				"stevearc/conform.nvim",
				config = function()
					local conform = require("conform")

					conform.setup({
						formatters_by_ft = {
							lua = { "stylua" },
							-- Conform will run multiple formatters sequentially
							-- python = { "isort", "black" },
							-- Use a sub-list to run only the first available formatter
							javascript = { { "prettierd", "prettier" } },
							typescript = { { "prettierd", "prettier" } },
							vue = { { "prettierd", "prettier" } },
							html = { { "prettierd", "prettier" } },
							markdown = { { "prettierd", "prettier" } },
							rust = { "rustfmt" },
							c = {},
						},
						format_on_save = function()
							local buf_name = vim.api.nvim_buf_get_name(0)

							local is_selfie = string.match(buf_name, "selfie")
							local is_beator = string.match(buf_name, "selfie")
							local is_monster = string.match(buf_name, "selfie")

							if is_selfie or is_beator or is_monster then
								return { timeout_ms = 500, lsp_fallback = false }
							else
								return {
									-- These options will be passed to conform.format()
									timeout_ms = 500,
									lsp_fallback = true,
								}
							end
						end,
					})

					vim.api.nvim_create_user_command("Format", function()
						conform.format({ lsp_fallback = true })
					end, {})
					require("user.keymaps").conform()
				end,
			},

			-- TypeScript utilities
			{ "jose-elias-alvarez/nvim-lsp-ts-utils" },

			-- fidget spinner shows LSP loading progress
			{ "j-hui/fidget.nvim", opts = {}, lazy = false },

			-- auto completions
			{ "hrsh7th/cmp-nvim-lsp" },

			-- JSON settings for individual language servers
			{
				"tamago324/nlsp-settings.nvim",
				lazy = true,
				opts = {
					config_home = vim.fn.stdpath("config") .. "/nlsp-settings",
					local_settings_dir = ".nlsp-settings",
					local_settings_root_markers = { ".git" },
					append_default_schemas = true,
					loader = "json",
				},
			},

			-- Icons in auto-complete of LSP (i.e. function, variable etc)
			{ "onsails/lspkind-nvim" },

			-- linting in neovim
			-- { 'mfussenegger/nvim-lint' },

			-- Rust
			{
				"mrcjkb/rustaceanvim",
				version = "^3", -- Recommended
				ft = { "rust" },
			},

			-- Go
			{
				"ray-x/go.nvim",
				lazy = true,

				event = { "CmdlineEnter" },
				ft = { "go", "gomod" },

				config = function()
					require("go").setup()
				end,
			},
		},

		config = function()
			local user_lsp = require("user.lsp")
			local telescope_builtin = require("telescope.builtin")
			local lspconfig = require("lspconfig")
			local mason_lsp = require("mason-lspconfig")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")

			local on_attach = user_lsp.get_on_attach(telescope_builtin)
			local global_capabilities = user_lsp.get_global_capabilities(cmp_nvim_lsp)

			local opts = {
				on_attach = on_attach,
				capabilities = global_capabilities,
			}

			lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
				capabilities = global_capabilities,
			})

			mason_lsp.setup_handlers({
				-- The first entry (without a key) will be the default handler
				-- and will be called for each installed server that doesn't have
				-- a dedicated handler.
				function(server_name) -- default handler (optional)
					lspconfig[server_name].setup(opts)
				end,
				-- Next, targeted overrides for specific servers.
				["clangd"] = user_lsp.clangd(on_attach, global_capabilities, lspconfig),
				["rust_analyzer"] = user_lsp.rust_analyzer(on_attach),
				["gopls"] = user_lsp.go_lsp(on_attach, global_capabilities, lspconfig),
				["tsserver"] = user_lsp.tsserver(on_attach, lspconfig),
				["jsonls"] = user_lsp.jsonls(on_attach, lspconfig),
				["emmet_ls"] = function()
					lspconfig["emmet_ls"].setup({ capabilities = global_capabilities })
				end,
				["eslint"] = user_lsp.eslint(on_attach, global_capabilities, lspconfig),
				["lua_ls"] = user_lsp.lua_ls(on_attach, global_capabilities, lspconfig),
				["vuels"] = user_lsp.vue_ls(on_attach, global_capabilities, lspconfig),
			})

			user_lsp.setup_ui()
		end,
	},
}

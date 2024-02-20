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
							-- python = { "isort", "black" },
							-- Use a sub-list to run only the first available formatter
							javascript = { { "prettierd", "prettier" } },
							typescript = { { "prettierd", "prettier" } },
							vue = { { "prettierd", "prettier" } },
							html = { { "prettierd", "prettier" } },
							markdown = { { "prettierd", "prettier" } },
							rust = { "rustfmt" },
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

							if is_selfie or is_beator or is_monster then
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
				lazy = false,
			},

			-- auto completions
			{ "hrsh7th/cmp-nvim-lsp" },

			-- JSON settings for individual language servers
			{
				"tamago324/nlsp-settings.nvim",
				lazy = false,
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
			-- {
			-- 	"mfussenegger/nvim-lint",
			-- 	lazy = false,
			-- 	config = function()
			-- 		require("lint").linters_by_ft = {
			-- 			go = { "revive" },
			-- 		}
			--
			-- 		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
			-- 			callback = function()
			-- 				require("lint").try_lint()
			-- 			end,
			-- 		})
			-- 	end,
			-- },

			-- Rust
			{
				"mrcjkb/rustaceanvim",
				version = "^4", -- Recommended
				ft = { "rust" },
			},

			-- Go
			{
				"crispgm/nvim-go",
				lazy = false,
				config = function()
					require("go").setup({
						-- notify: use nvim-notify
						notify = false,
						-- auto commands
						auto_format = false, -- done by conform
						auto_lint = false,
						-- linters: revive, errcheck, staticcheck, golangci-lint
						linter = "revive",
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
			-- {
			-- 	"ray-x/go.nvim",
			-- 	lazy = true,
			--
			-- 	event = { "CmdlineEnter" },
			-- 	ft = { "go", "gomod" },
			--
			-- 	config = function()
			-- 		require("go").setup({
			--
			-- 			disable_defaults = true, -- true|false when true set false to all boolean settings and replace all table
			-- 			-- settings with {}
			-- 			go = "go", -- go command, can be go[default] or go1.18beta1
			-- 			goimport = "gopls", -- goimport command, can be gopls[default] or either goimport or golines if need to split long lines
			-- 			fillstruct = "gopls", -- default, can also use fillstruct
			-- 			gofmt = "gofumpt", --gofmt cmd,
			-- 			max_line_len = 100, -- max line length in golines format, Target maximum line length for golines
			-- 			icons = false,
			-- 			verbose = false, -- output loginf in messages
			-- 			lsp_cfg = false, -- true: use non-default gopls setup specified in go/lsp.lua
			-- 			-- false: do nothing
			-- 			-- if lsp_cfg is a table, merge table with with non-default gopls setup in go/lsp.lua, e.g.
			-- 			--   lsp_cfg = {settings={gopls={matcher='CaseInsensitive', ['local'] = 'your_local_module_path', gofumpt = true }}}
			-- 			lsp_gofumpt = false, -- true: set default gofmt in gopls format to gofumpt
			-- 			lsp_on_attach = nil, -- nil: use on_attach function defined in go/lsp.lua,
			-- 			lsp_inlay_hints = {},
			-- 			gopls_cmd = nil, -- if you need to specify gopls path and cmd, e.g {"/home/user/lsp/gopls", "-logfile","/var/log/gopls.log" }
			-- 			gocoverage_sign = "█",
			-- 			sign_priority = 5, -- change to a higher number to override other signs
			-- 			dap_debug = true, -- set to false to disable dap
			-- 			dap_debug_keymap = false, -- true: use keymap for debugger defined in go/dap.lua
			-- 			-- false: do not use keymap in go/dap.lua.  you must define your own.
			-- 			-- Windows: Use Visual Studio keymap
			-- 			-- dap_debug_gui = {}, -- bool|table put your dap-ui setup here set to false to disable
			-- 			-- dap_debug_vt = { enabled_commands = true, all_frames = true }, -- bool|table put your dap-virtual-text setup here set to false to disable
			--
			-- 			-- dap_port = 38697, -- can be set to a number, if set to -1 go.nvim will pick up a random port
			-- 			-- dap_timeout = 15, --  see dap option initialize_timeout_sec = 15,
			-- 			-- dap_retries = 20, -- see dap option max_retries
			-- 			build_tags = "integration,unit", -- set default build tags
			-- 			-- textobjects = true, -- enable default text objects through treesittter-text-objects
			-- 			test_runner = "go", -- one of {`go`, `richgo`, `dlv`, `ginkgo`, `gotestsum`}
			-- 			-- float term recommend if you use richgo/ginkgo with terminal color
			--
			-- 			-- floaterm = { -- position
			-- 			-- 	posititon = "auto", -- one of {`top`, `bottom`, `left`, `right`, `center`, `auto`}
			-- 			-- 	width = 0.45, -- width of float window if not auto
			-- 			-- 	height = 0.98, -- height of float window if not auto
			-- 			-- 	title_colors = "nord", -- default to nord, one of {'nord', 'tokyo', 'dracula', 'rainbow', 'solarized ', 'monokai'}
			-- 			-- 	-- can also set to a list of colors to define colors to choose from
			-- 			-- 	-- e.g {'#D8DEE9', '#5E81AC', '#88C0D0', '#EBCB8B', '#A3BE8C', '#B48EAD'}
			-- 			-- },
			-- 			-- trouble = false, -- true: use trouble to open quickfix
			-- 			-- test_efm = false, -- errorfomat for quickfix, default mix mode, set to true will be efm only
			-- 			luasnip = true, -- enable included luasnip snippets. you can also disable while add lua/snips folder to luasnip load
			-- 			--  Do not enable this if you already added the path, that will duplicate the entries
			-- 			-- on_jobstart = function(cmd)
			-- 			-- 	_ = cmd
			-- 			-- end, -- callback for stdout
			-- 			-- on_stdout = function(err, data)
			-- 			-- 	_, _ = err, data
			-- 			-- end, -- callback when job started
			-- 			-- on_stderr = function(err, data)
			-- 			-- 	_, _ = err, data
			-- 			-- end, -- callback for stderr
			-- 			-- on_exit = function(code, signal, output)
			-- 			-- 	_, _, _ = code, signal, output
			-- 			-- end, -- callback for jobexit, output : string
			-- 			iferr_vertical_shift = 4, -- defines where the cursor will end up vertically from the begining of if err statement
			-- 		})
			-- 	end,
			-- },
		},

		config = function()
			local user_lsp = require("user.lsp")
			local telescope_builtin = require("telescope.builtin")
			local lspconfig = require("lspconfig")
			local mason_lsp = require("mason-lspconfig")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")

			require("neoconf").setup()
			require("neodev").setup()

			local on_attach = user_lsp.get_on_attach(telescope_builtin)
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

			local neoconf = require("neoconf")

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

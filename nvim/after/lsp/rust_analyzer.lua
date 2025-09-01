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

return {}

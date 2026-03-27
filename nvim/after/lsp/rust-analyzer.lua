--- @module "rustaceanvim"
--- @type rustaceanvim.Opts
vim.g.rustaceanvim = {
	tools = {
		float_win_config = {
			focusable = true,
		},
	},
	-- DAP configuration
	dap = {
		autoload_configurations = true,
	},
}

return {
	settings = {
		["rust-analyzer"] = {
			hover = {
				links = {
					enable = false,
				},
			},
			checkOnSave = true,
			check = {
				-- NOTE: setting 'features = "all"' might break diagnostics...
				command = "clippy",
			},
			cargo = {
				targetDir = true,
			},
			files = {
				excludeDirs = { '**/.direnv', '.direnv', '.nix' },
				exclude = { '**/.direnv', '.direnv', '.nix' },
				watcher = "client",
			},
		},
	},
}

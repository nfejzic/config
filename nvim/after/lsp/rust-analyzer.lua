--- @module "rustaceanvim"
--- @type rustaceanvim.Opts
vim.g.rustaceanvim = {
	tools = {
		float_win_config = {
			border = "rounded",
			focusable = true,
		},
	},
	server = {
		default_settings = {
			["rust-analyzer"] = {
				files = {
					exclude = { ".direnv" }
				}
			}
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
				enable = true,
				command = "clippy",
				features = "all",
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

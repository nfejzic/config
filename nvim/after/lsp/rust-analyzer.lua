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
				extraArgs = { "--no-deps", },
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

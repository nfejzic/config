return {
	{
		"folke/lazydev.nvim",

		ft = "lua", -- only load on lua files

		dependencies = {
			{ 'justinsgithub/wezterm-types', lazy = true },
		},

		opts = {
			integrations = {
				lspconfig = false,
				blink = true,
			},
			library = {
				{ path = "wezterm-types",      mods = { "wezterm" } },
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			}
		},
	},
}

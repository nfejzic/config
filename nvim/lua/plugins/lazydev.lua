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
				-- Needs `justinsgithub/wezterm-types` to be installed
				{ path = "wezterm-types",      mods = { "wezterm" } },
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			}
		},
	},
}

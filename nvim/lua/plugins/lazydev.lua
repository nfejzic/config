local config = function()
	require("lazydev").setup({
		integrations = {
			lspconfig = true,
			blink = false,
		},
		library = {
			{ path = "wezterm-types", mods = { "wezterm" } },
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		},
	})
end

config()

-- return {
-- 	{
-- 		"folke/lazydev.nvim",
--
-- 		ft = "lua", -- only load on lua files
--
-- 		dependencies = {
-- 			{ "justinsgithub/wezterm-types", lazy = true },
-- 		},
--
-- 		opts = {
-- 		},
-- 	},
-- }

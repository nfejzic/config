return {
	{
		-- NOTE: using `magazine.nvim` fork for now with recent updates, more features etc.
		"iguanacucumber/magazine.nvim",
		name = "nvim-cmp", -- Otherwise highlighting gets messed up
		-- "hrsh7th/nvim-cmp",

		dependencies = {
			{ "iguanacucumber/mag-nvim-lsp", name = "cmp-nvim-lsp", opts = {} },
			{ "iguanacucumber/mag-nvim-lua", name = "cmp-nvim-lua" },
			{ "iguanacucumber/mag-buffer",   name = "cmp-buffer" },
			{ "iguanacucumber/mag-cmdline",  name = "cmp-cmdline" },
			"https://codeberg.org/FelipeLema/cmp-async-path", -- not by me, but better than cmp-path

			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "L3MON4D3/LuaSnip",                   lazy = true },
			{ "saadparwaiz1/cmp_luasnip",           lazy = true },
			{ "nvim-lua/plenary.nvim" },

			-- Icons in auto-complete of LSP (i.e. function, variable etc)
			{ "onsails/lspkind-nvim" },
		},

		lazy = true,
		event = { "InsertEnter", "CmdlineEnter" },

		config = function()
			require("user.completion")
		end,
	},


	-- {
	-- 	'saghen/blink.cmp',
	-- 	dependencies = 'rafamadriz/friendly-snippets',
	--
	-- 	version = 'v0.*',
	--
	-- 	---@module 'blink.cmp'
	-- 	---@type blink.cmp.Config
	-- 	opts = {
	-- 		keymap = {
	-- 			preset = 'default',
	-- 			['<C-j>'] = { 'accept' },
	-- 			['<C-l>'] = { 'snippet_forward' },
	-- 			['<C-h>'] = { 'snippet_backward' },
	-- 			['<C-u>'] = { 'scroll_documentation_up' },
	-- 			['<C-d>'] = { 'scroll_documentation_down' },
	-- 			['<C-k>'] = { 'show' },
	-- 		},
	-- 		appearance = {
	-- 			use_nvim_cmp_as_default = true,
	-- 			nerd_font_variant = 'mono'
	-- 		},
	--
	-- 		completion = {
	-- 			ghost_text = {
	-- 				enabled = true,
	-- 			},
	-- 			menu = {
	-- 				border = 'rounded',
	-- 				draw = {
	-- 					treesitter = true,
	-- 					columns = {
	-- 						{ "label",     "label_description", gap = 1 },
	-- 						{ "kind_icon", "kind",              gap = 1 }
	-- 					},
	-- 				}
	-- 			},
	--
	-- 			documentation = {
	-- 				auto_show = true,
	-- 				auto_show_delay_ms = 50,
	-- 				window = {
	-- 					border = 'rounded',
	-- 					max_width = 100,
	-- 				},
	-- 			},
	-- 		},
	--
	--
	-- 		signature = {
	-- 			enabled = true,
	-- 			window = {
	-- 				border = 'rounded',
	-- 			}
	-- 		}
	-- 	},
	-- },
}

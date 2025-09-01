return {
	'saghen/blink.cmp',
	-- optional: provides snippets for the snippet source
	dependencies = {
		'rafamadriz/friendly-snippets',
		{ "L3MON4D3/LuaSnip", lazy = true },
	},

	lazy = true,
	version = '1.*',

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = 'default',
			['<C-j>'] = { 'accept' },
			['<C-l>'] = { 'snippet_forward' },
			['<C-h>'] = { 'snippet_backward' },
			['<C-u>'] = { 'scroll_documentation_up' },
			['<C-d>'] = { 'scroll_documentation_down' },
			['<C-k>'] = { 'show' },
		},

		appearance = {
			nerd_font_variant = 'mono'
		},

		completion = {
			menu = {
				border = "rounded",
				draw = {
					treesitter = { "lsp", "path", "snippets", },
					columns = {
						{ "kind_icon", "label", "label_description", gap = 2 },
						{ "kind",      gap = 2 },
					},
				}
			},
			documentation = {
				auto_show = true,
				window = {
					border = "rounded",
				},
			},
			ghost_text = {
				enabled = true,
			},
		},

		signature = {
			enabled = true,
			window = {
				border = "rounded",
			},
		},

		sources = {
			default = { "lazydev", 'lsp', 'path', 'snippets' },
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
			},

		},

		cmdline = {
			enabled = true,
			keymap = {
				preset = 'cmdline',
				['<Tab>'] = { 'show_and_insert', 'select_next' },
				['<S-Tab>'] = { 'show_and_insert', 'select_prev' },
				['<C-j>'] = { 'accept' },
			},
			sources = { 'buffer', 'cmdline' },
			completion = {
				trigger = {
					show_on_blocked_trigger_characters = {},
					show_on_x_blocked_trigger_characters = {},
				},
				list = {
					selection = {
						preselect = true,
						auto_insert = true,
					},
				},
				menu = { auto_show = true },
				ghost_text = { enabled = true }
			}
		},

		snippets = { preset = "luasnip" },
		fuzzy = { implementation = "prefer_rust_with_warning" }
	},
	opts_extend = { "sources.default" }
}

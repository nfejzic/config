return {
	-- {
	-- 	-- NOTE: using `magazine.nvim` fork for now with recent updates, more features etc.
	-- 	"iguanacucumber/magazine.nvim",
	-- 	name = "nvim-cmp", -- Otherwise highlighting gets messed up
	-- 	-- "hrsh7th/nvim-cmp",
	--
	-- 	dependencies = {
	-- 		{ "iguanacucumber/mag-nvim-lsp", name = "cmp-nvim-lsp", opts = {} },
	-- 		{ "iguanacucumber/mag-nvim-lua", name = "cmp-nvim-lua" },
	-- 		{ "iguanacucumber/mag-buffer",   name = "cmp-buffer" },
	-- 		{ "iguanacucumber/mag-cmdline",  name = "cmp-cmdline" },
	-- 		"https://codeberg.org/FelipeLema/cmp-async-path", -- not by me, but better than cmp-path
	--
	-- 		{ "hrsh7th/cmp-nvim-lsp-signature-help" },
	-- 		{ "L3MON4D3/LuaSnip",                   lazy = true },
	-- 		{ "saadparwaiz1/cmp_luasnip",           lazy = true },
	-- 		{ "nvim-lua/plenary.nvim" },
	--
	-- 		-- Icons in auto-complete of LSP (i.e. function, variable etc)
	-- 		{ "onsails/lspkind-nvim" },
	-- 	},
	--
	-- 	lazy = true,
	-- 	event = { "InsertEnter", "CmdlineEnter" },
	--
	-- 	config = function()
	-- 		require("user.completion")
	-- 	end,
	-- },

	{
		'saghen/blink.cmp',
		-- optional: provides snippets for the snippet source
		dependencies = {
			'rafamadriz/friendly-snippets',
			{ "L3MON4D3/LuaSnip", lazy = true },
		},

		-- use a release tag to download pre-built binaries
		-- version = '1.*',
		build = 'nix run .#build-plugin',

		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
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
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = 'mono'
			},

			-- (Default) Only show the documentation popup when manually triggered
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

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				-- default = { 'lsp', 'path', 'snippets', 'buffer' },
				default = { 'lsp', 'path', 'snippets' },
			},

			cmdline = {
				enabled = true,
				-- use 'inherit' to inherit mappings from top level `keymap` config
				keymap = {
					preset = 'cmdline',
					['<C-j>'] = { 'accept' },
				},
				---@diagnostic disable-next-line: assign-type-mismatch
				sources = function()
					local type = vim.fn.getcmdtype()
					-- Search forward and backward
					if type == '/' or type == '?' then return { 'buffer' } end
					-- Commands
					if type == ':' or type == '@' then return { 'cmdline' } end
					return {}
				end,
				completion = {
					trigger = {
						show_on_blocked_trigger_characters = {},
						show_on_x_blocked_trigger_characters = {},
					},
					list = {
						selection = {
							-- When `true`, will automatically select the first item in the completion list
							preselect = true,
							-- When `true`, inserts the completion item automatically when selecting it
							auto_insert = true,
						},
					},
					-- Whether to automatically show the window when new completion items are available
					menu = { auto_show = false },
					-- Displays a preview of the selected item on the current line
					ghost_text = { enabled = true }
				}
			},

			snippets = { preset = "luasnip" },

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" }
		},
		opts_extend = { "sources.default" }
	}
}

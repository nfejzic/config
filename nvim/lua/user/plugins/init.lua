local gh = require("user.plugins.lib").github

vim.pack.add({
	{ src = gh "nvim-mini/mini.icons", version = vim.version.range("*") },
	-- { src = github("nvim-mini/mini.diff"), version = vim.version.range("*") },

	gh "folke/which-key.nvim",
	gh "neovim/nvim-lspconfig",
	gh "j-hui/fidget.nvim",

	gh "stevearc/oil.nvim",
	gh "stevearc/quicker.nvim",
	gh "stevearc/conform.nvim",
	gh "stevearc/dressing.nvim",

	-- GIT
	gh "lewis6991/gitsigns.nvim",
	gh "tpope/vim-fugitive",

	-- other tpope
	gh "tpope/vim-repeat",
	gh "tpope/vim-surround",
	gh "tpope/vim-sleuth",

	gh "folke/snacks.nvim",

	-- UI
	gh "nvim-lualine/lualine.nvim",

	gh "AndrewRadev/tagalong.vim",

	-- local, development plugins
	"file:///~/Developer/nvim/colorize.nvim",
})

require('mini.icons').setup()
require("user.plugins.colorize")
require("lualine").setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		globalstatus = true,
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch" },
		-- lualine_c = { 'filename', { 'diagnostics', color = "StatusLine", colored = true } },
		lualine_c = { "filename", "diagnostics" },
		lualine_x = { "encoding", "location", { "filetype", icons_enabled = true } },
		lualine_y = {},
		lualine_z = {},
	},
})

require("dressing").setup({
	input = {
		start_in_insert = false,
		insert_only = false,
		win_options = {
			winblend = 0,
		},
	},
	select = {
		enabled = false,
	}
})

local oil = require("oil")
oil.setup({
	columns = {
		"icon",
		"permissions",
		"size",
		-- "mtime",
	},
	view_options = {
		show_hidden = true,
	},
	-- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
	delete_to_trash = true,
})

local quicker = require("quicker")
quicker.setup({
	-- Keep the cursor to the right of the filename and lnum columns
	constrain_cursor = false,
	highlight = {
		-- Use treesitter highlighting
		treesitter = true,
		-- Use LSP semantic token highlighting
		lsp = true,
		-- Load the referenced buffers to apply more accurate highlights (may be slow)
		load_buffers = false,
	},

	keys = {
		{ ">", quicker.expand,   desc = "Expand quickfix content" },
		{ "<", quicker.collapse, desc = "Expand quickfix content" },
	}
})

require("user.core.keymaps").set_keys({
	-- opens oil with current file being under the cursor
	{ "n", "<leader>ft", oil.open,         "Open File Explorer (Oil)" },
	{ "n", "-",          oil.open,         "Open File Explorer (Oil)" },
	{ "n", "<leader>fr", oil.toggle_float, "Open floating file explorer (Oil)" },
})

local wk = require("which-key")
require("user.core.keymaps").setup_which_key(wk)

-- load plugins
require("user.plugins.conform")
require("user.plugins.git")
require("user.plugins.snacks")
require("user.plugins.treesitter")
require("user.plugins.lsp").setup()
require("user.plugins.debug")
require("user.plugins.neotest")
require("user.plugins.smart_splits")

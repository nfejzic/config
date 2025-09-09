return {
	{
		'mrjones2014/smart-splits.nvim',

		lazy = true,
		event = "UiEnter",

		config = function()
			local smart_splits = require('smart-splits')
			local keymaps = require('user.keymaps')

			keymaps.set_keys({
				{ "n", "<A-h>", smart_splits.move_cursor_left,  "Move cursor to window on the left" },
				{ "n", "<A-j>", smart_splits.move_cursor_down,  "Move cursor to window on the left" },
				{ "n", "<A-k>", smart_splits.move_cursor_up,    "Move cursor to window on the left" },
				{ "n", "<A-l>", smart_splits.move_cursor_right, "Move cursor to window on the left" },

				{ "n", "<A-H>", smart_splits.resize_left,       "Move cursor to window on the left" },
				{ "n", "<A-J>", smart_splits.resize_down,       "Move cursor to window on the left" },
				{ "n", "<A-K>", smart_splits.resize_up,         "Move cursor to window on the left" },
				{ "n", "<A-L>", smart_splits.resize_right,      "Move cursor to window on the left" },

				{ "n", "<A-w>", "<CMD>quit<CR>",                "Close the currently focused window" },
			})
		end,
	}
}

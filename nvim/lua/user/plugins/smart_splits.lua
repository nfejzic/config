local gh = require("user.plugins.lib").github

vim.pack.add({
	gh "mrjones2014/smart-splits.nvim"
})

local ss = nil

--- @param method string
local function call(method)
	return function()
		if ss == nil then
			vim.notify("loading smart splits")
			ss = require("smart-splits")
		end

		ss[method]()
	end
end


local keymaps = require('user.core.keymaps')

keymaps.set_keys({
	{ "n", "<A-h>", call("move_cursor_left"),  "Move cursor to window on the left" },
	{ "n", "<A-j>", call("move_cursor_down"),  "Move cursor to window on the left" },
	{ "n", "<A-k>", call("move_cursor_up"),    "Move cursor to window on the left" },
	{ "n", "<A-l>", call("move_cursor_right"), "Move cursor to window on the left" },

	{ "n", "<A-H>", call("resize_left"),       "Move cursor to window on the left" },
	{ "n", "<A-J>", call("resize_down"),       "Move cursor to window on the left" },
	{ "n", "<A-K>", call("resize_up"),         "Move cursor to window on the left" },
	{ "n", "<A-L>", call("resize_right"),      "Move cursor to window on the left" },
})

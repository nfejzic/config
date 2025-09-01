return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-mini/mini.icons", lazy = true },

	config = function()
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

		require("user.keymaps").set_keys({
			-- opens oil with current file being under the cursor
			{ "n", "<leader>ft", oil.open,         "Open File Explorer (Oil)" },
			{ "n", "-",          oil.open,         "Open File Explorer (Oil)" },
			{ "n", "<leader>fr", oil.toggle_float, "Open floating file explorer (Oil)" },
		})
	end,
}

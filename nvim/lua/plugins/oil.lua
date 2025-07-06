return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", lazy = true, event = "VeryLazy" },

	-- do not lazy load in order to replace netrw
	lazy = true,
	cmd = "Oil",
	event = { "VimEnter */*,.*", "BufNew */*,.*" },

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

		require("user.keymaps").oil(oil)
	end,
}

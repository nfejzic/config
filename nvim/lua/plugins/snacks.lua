return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		config = function()
			local snacks = require("snacks")

			snacks.setup({
				bigfile = { enabled = false },
				dashboard = { enabled = false },
				explorer = { enabled = false },
				indent = { enabled = false },
				input = { enabled = false },
				picker = {
					enabled = true,
					layout = "ivy_split"
				},
				notifier = { enabled = false },
				quickfile = { enabled = false },
				scope = { enabled = false },
				scroll = { enabled = false },
				statuscolumn = { enabled = false },
				words = { enabled = false },
			})

			require("user.keymaps").snacks_picker_keymaps(snacks)
		end,
	}
}

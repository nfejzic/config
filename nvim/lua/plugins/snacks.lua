local dropdown_preset = {
	preset = "dropdown",
	layout = { width = 0.85, height = 0.9 },
}

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
					ui_select = true,
					layout = dropdown_preset,
					sources = {
						select = {
							layout = {
								preset = "select",
								layout = {
									relative = "cursor",
									width = 0.5,
								},
							},
						},
					},
				},
				notifier = { enabled = false },
				quickfile = { enabled = false },
				scope = { enabled = false },
				scroll = { enabled = false },
				statuscolumn = { enabled = false },
				words = { enabled = false },
				gitbrowse = { enabled = true },
			})

			local keymaps = require("user.keymaps")
			keymaps.snacks_picker_keymaps(snacks.picker)
			keymaps.snacks_gitbrowse_keymaps(snacks.gitbrowse)
		end,

	},
}

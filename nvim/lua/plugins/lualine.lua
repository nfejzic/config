return {
	"nvim-lualine/lualine.nvim",
	lazy = true,
	event = "UIEnter",

	dependencies = {
		"nvim-mini/mini.icons",
		"nfejzic/colorize.nvim",
	},

	config = function()
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

				-- lualine_y = { 'progress' },
				-- lualine_z = { 'location' }
			},
		})
	end,
}
